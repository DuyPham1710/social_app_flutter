# Clean Architecture Refactoring - Comment Feature

## 📋 Tổng quan

Refactored để tách biệt **Comment Count & Typing** ra khỏi `CommentSocketService` và áp dụng đúng Clean Architecture principles.

---

## 🏗️ Cấu trúc sau refactoring

```
lib/
├── core/
│   └── network/
│       └── websocket/
│           ├── socket_client.dart                    ← GENERIC WebSocket client
│           └── comment_socket_service.dart           ← CHỈ xử lý CRUD comment
│
└── features/
    ├── comment/
    │   ├── data/
    │   │   ├── data_sources/
    │   │   │   └── remote/
    │   │   │       └── comment_remote_data_source.dart  ← Count & Typing logic
    │   │   ├── models/
    │   │   │   ├── comment_model.dart
    │   │   │   └── typing_event_model.dart              ← NEW: Model cho typing events
    │   │   └── repository/
    │   │       └── comment_repository_impl.dart
    │   │
    │   ├── domain/
    │   │   ├── entities/
    │   │   │   ├── comment_entity.dart
    │   │   │   └── typing_entity.dart                   ← NEW: Entity cho typing
    │   │   ├── repository/
    │   │   │   └── comment_repository.dart
    │   │   └── usecases/
    │   │       ├── connect_comment_socket_usecase.dart ← NEW
    │   │       ├── get_comment_count_usecase.dart      ← NEW
    │   │       ├── listen_comment_count_usecase.dart   ← NEW
    │   │       ├── join_post_usecase.dart
    │   │       ├── leave_post_usecase.dart
    │   │       ├── emit_typing_usecase.dart
    │   │       └── listen_typing_usecase.dart
    │   │
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── comment_bloc.dart
    │       │   ├── comment_event.dart
    │       │   └── comment_state.dart
    │       └── widgets/
    │           └── modal_comment.dart
    │
    └── home/
        └── presentation/
            └── bloc/
                └── home_bloc.dart                      ← UPDATED: Dùng CommentRemoteDataSource
```

---

## 🔄 Những thay đổi chính

### 1. **SocketClient (core/network/websocket/socket_client.dart)**

**GENERIC WebSocket client** - có thể dùng cho mọi features (comments, chat, notifications, etc.)

```dart
class SocketClient {
  void connect({required String namespace, required String userId});
  void emit(String event, dynamic data);
  Stream<dynamic> on(String event);
  void disconnect();
  void dispose();
}
```

**✅ Lợi ích:**
- Generic - không specific cho một feature
- Reusable - dùng lại cho Chat, Notifications, Live Updates
- Single Responsibility - chỉ lo WebSocket connection

---

### 2. **CommentSocketService (core/network/websocket/comment_socket_service.dart)**

**GIẢM TRÁCH NHIỆM** - chỉ xử lý CRUD comments:

**TRƯỚC:**
```dart
class CommentSocketService {
  // ❌ Comment count logic
  final Map<String, int> _commentCounts = {};
  Stream<Map<String, int>> get commentCountStream;
  
  // ❌ Typing logic
  Stream<TypingEvent> get typingStream;
  void emitTyping({required String postId, required bool isTyping});
  
  // ✅ CRUD operations
  void sendComment({required String postId, required String content});
  void deleteComment({required String commentId, required String postId});
}
```

**SAU:**
```dart
class CommentSocketService {
  // ✅ CHỈ CRUD operations
  Stream<CommentUpdateEvent> get commentAddedStream;
  Stream<CommentDeletedEvent> get commentDeletedStream;
  
  void sendComment({required String postId, required String content});
  void deleteComment({required String commentId, required String postId});
}
```

**✅ Lợi ích:**
- Single Responsibility - chỉ lo CRUD
- Đơn giản hơn, dễ maintain
- Không vi phạm Clean Architecture

---

### 3. **CommentRemoteDataSource (features/comment/data/data_sources/remote/)**

**MỚI** - Feature-specific data source cho Comment Count & Typing:

```dart
class CommentRemoteDataSource {
  final SocketClient _socketClient;
  final Map<String, int> _commentCounts = {};
  
  Stream<Map<String, int>> get commentCountStream;
  Stream<TypingEventModel> get typingStream;
  
  void connect(String userId);
  void joinPost(String postId);
  void leavePost(String postId);
  void loadComments(String postId);
  void emitTyping({required String postId, required bool isTyping});
  int getCommentCount(String postId);
}
```

**✅ Lợi ích:**
- Feature-specific - thuộc về Comment feature
- Parse JSON ở đúng layer (Data layer)
- Dùng SocketClient (generic) thay vì tự quản lý socket
- Dễ test - có thể mock SocketClient

---

### 4. **Entities & Models**

#### **TypingEntity (Domain layer)**
```dart
class TypingEntity {
  final String userId;
  final String? username;
  final bool isTyping;
  final String postId;
}
```

#### **TypingEventModel (Data layer)**
```dart
class TypingEventModel extends TypingEntity {
  factory TypingEventModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
```

**✅ Lợi ích:**
- Entity-Model pattern đúng chuẩn Clean Architecture
- Entity không phụ thuộc vào implementation details
- Model lo serialization/deserialization

---

### 5. **Repository Pattern**

#### **CommentRepository (Domain layer)**
```dart
abstract class CommentRepository {
  void connect(String userId);
  void joinPost(String postId);
  void leavePost(String postId);
  void emitTyping({required String postId, required bool isTyping});
  int getCommentCount(String postId);
  
  Stream<TypingEntity> get typingStream;
  Stream<Map<String, int>> get commentCountStream;
  
  void disconnect();
}
```

#### **CommentRepositoryImpl (Data layer)**
```dart
class CommentRepositoryImpl implements CommentRepository {
  final CommentRemoteDataSource _remoteDataSource;
  
  // Implement tất cả methods bằng cách delegate to data source
  @override
  void connect(String userId) => _remoteDataSource.connect(userId);
  
  @override
  Stream<TypingEntity> get typingStream => _remoteDataSource.typingStream;
  
  @override
  Stream<Map<String, int>> get commentCountStream => 
      _remoteDataSource.commentCountStream;
}
```

**✅ Lợi ích:**
- Abstract interface trong Domain layer
- Implementation trong Data layer
- Dễ thay đổi data source (WebSocket → HTTP, etc.)

---

### 6. **UseCases**

Tạo mới các UseCases:

1. **ConnectCommentSocketUseCase** - Connect socket
2. **GetCommentCountUseCase** - Lấy count hiện tại
3. **ListenCommentCountUseCase** - Listen real-time updates
4. **JoinPostUseCase** - Join post room
5. **LeavePostUseCase** - Leave post room
6. **EmitTypingUseCase** - Emit typing status
7. **ListenTypingUseCase** - Listen typing events

**Ví dụ:**
```dart
class ListenCommentCountUseCase 
    implements StreamUseCase<Map<String, int>, NoParams> {
  final CommentRepository _repository;
  
  @override
  Stream<Map<String, int>> call({required NoParams params}) {
    return _repository.commentCountStream;
  }
}
```

**✅ Lợi ích:**
- Mỗi UseCase 1 responsibility
- Dễ test từng UseCase riêng lẻ
- BLoC chỉ gọi UseCases, không biết về Repository

---

### 7. **HomeBloc Update**

**TRƯỚC:**
```dart
class HomeBloc {
  final CommentSocketService commentSocketService;
  
  void _initializeWebSocket() {
    commentSocketService.connect(userId);
    _subscription = commentSocketService.commentCountStream.listen(...);
  }
}
```

**SAU:**
```dart
class HomeBloc {
  final CommentRemoteDataSource commentRemoteDataSource;
  
  void _initializeWebSocket() {
    commentRemoteDataSource.connect(userId);
    _subscription = commentRemoteDataSource.commentCountStream.listen(...);
  }
}
```

**✅ Lợi ích:**
- Dùng đúng Data Source thay vì Service
- Separation of concerns rõ ràng

---

### 8. **Dependency Injection**

```dart
// Generic WebSocket Client
s1.registerSingleton<SocketClient>(SocketClient());

// CRUD Comment Service (giữ nguyên cho CRUD operations)
s1.registerSingleton<CommentSocketService>(CommentSocketService());

// Comment Remote Data Source (Count & Typing)
s1.registerLazySingleton<CommentRemoteDataSource>(
  () => CommentRemoteDataSource(s1()),
);

// Repository
s1.registerLazySingleton<CommentRepository>(
  () => CommentRepositoryImpl(s1()),
);

// UseCases
s1.registerLazySingleton<ConnectCommentSocketUseCase>(
  () => ConnectCommentSocketUseCase(s1()),
);
s1.registerLazySingleton<GetCommentCountUseCase>(
  () => GetCommentCountUseCase(s1()),
);
s1.registerLazySingleton<ListenCommentCountUseCase>(
  () => ListenCommentCountUseCase(s1()),
);

// BLoCs
s1.registerFactory<HomeBloc>(
  () => HomeBloc(
    getHomePostsUseCase: s1(),
    commentRemoteDataSource: s1(),
  ),
);
```

---

## 📊 So sánh TRƯỚC vs SAU

| Aspect | Trước ❌ | Sau ✅ |
|--------|---------|--------|
| **Socket Client** | Comment-specific | Generic, reusable |
| **CommentSocketService** | CRUD + Count + Typing | CHỈ CRUD |
| **Data Source** | Không có | CommentRemoteDataSource |
| **Entities** | Không có TypingEntity | TypingEntity + TypingEventModel |
| **Repository** | Reference SocketService | Reference DataSource |
| **UseCases** | 4 UseCases | 7 UseCases (đầy đủ hơn) |
| **Layer separation** | Vi phạm Clean Architecture | Đúng Clean Architecture |
| **Testability** | Khó (phụ thuộc Socket) | Dễ (mock từng layer) |
| **Reusability** | Không reuse được | SocketClient reuse cho tất cả features |
| **Scalability** | Khó mở rộng | Dễ thêm features (Chat, Notifications) |

---

## 🎯 Luồng hoạt động

### **1. Comment Count Real-time**

```
Backend (NestJS)
    ↓
    emit 'commentAdded' / 'commentDeleted' / 'commentsLoaded'
    ↓
SocketClient (Generic)
    ↓ parse event
CommentRemoteDataSource
    ↓ update _commentCounts Map
    ↓ emit to commentCountStream
CommentRepositoryImpl
    ↓
HomeBloc
    ↓ listen to stream
    ↓ add UpdateCommentCountsEvent
    ↓
HomeState (updated commentCounts)
    ↓
PostItem widget
    ↓
PostAction widget (hiển thị count)
```

### **2. Typing Indicator**

```
User nhập text vào ModalComment
    ↓
_onTextChanged()
    ↓
CommentBloc.add(UserTypingEvent)
    ↓
EmitTypingUseCase
    ↓
CommentRepository.emitTyping()
    ↓
CommentRemoteDataSource.emitTyping()
    ↓
SocketClient.emit('typing')
    ↓
Backend broadcast 'userTyping'
    ↓
SocketClient.on('userTyping')
    ↓
CommentRemoteDataSource.typingStream
    ↓
ListenTypingUseCase
    ↓
ModalComment._typingSubscription
    ↓
CommentBloc.add(UpdateTypingUsersEvent)
    ↓
CommentState (updated typingUsers)
    ↓
_buildTypingIndicator() (hiển thị "Someone is typing...")
```

---

## ✅ Kết luận

### **Đã hoàn thành:**
1. ✅ Tạo `SocketClient` generic
2. ✅ Tạo `CommentRemoteDataSource` cho Count & Typing
3. ✅ Refactor `CommentSocketService` - chỉ giữ CRUD
4. ✅ Tạo `TypingEntity` và `TypingEventModel`
5. ✅ Tạo 3 UseCases mới: `ConnectCommentSocketUseCase`, `GetCommentCountUseCase`, `ListenCommentCountUseCase`
6. ✅ Update `CommentRepository` và `CommentRepositoryImpl`
7. ✅ Update `HomeBloc` để dùng `CommentRemoteDataSource`
8. ✅ Update dependency injection

### **Lợi ích:**
- ✅ **Clean Architecture** - đúng 100% nguyên tắc
- ✅ **Separation of Concerns** - mỗi layer làm đúng việc của nó
- ✅ **Reusability** - `SocketClient` dùng cho tất cả features
- ✅ **Testability** - dễ test từng layer riêng lẻ
- ✅ **Maintainability** - dễ maintain và mở rộng
- ✅ **Scalability** - dễ thêm features mới (Chat, Notifications, etc.)

### **Tiếp theo (nếu cần):**
- [ ] Thêm error handling cho WebSocket
- [ ] Thêm retry logic khi connection bị mất
- [ ] Thêm unit tests cho từng layer
- [ ] Tạo Chat feature sử dụng `SocketClient` chung

---

**Tạo bởi:** AI Assistant  
**Ngày:** 2025-10-13  
**Mục đích:** Document clean architecture refactoring cho Comment feature

