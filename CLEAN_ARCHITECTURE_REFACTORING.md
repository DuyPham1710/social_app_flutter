# Clean Architecture Refactoring - Typing Indicator

## 🎯 Vấn Đề Ban Đầu

### ❌ **TRƯỚC KHI REFACTOR** (Vi phạm Clean Architecture)

```dart
// CommentBloc trực tiếp phụ thuộc vào CommentSocketService
class CommentBloc {
  final CommentSocketService commentSocketService; // ❌ Data layer dependency
  
  void _onJoinPost(...) {
    commentSocketService.joinPost(event.postId); // ❌ Direct call to service
  }
}
```

**Vấn đề:**
1. ❌ **Presentation Layer gọi trực tiếp Data Layer** - Vi phạm dependency rule
2. ❌ **Không có abstraction** - Tight coupling
3. ❌ **Không có UseCase** - Business logic rò rỉ
4. ❌ **Không thể test độc lập** - Hard to mock
5. ❌ **Khó maintain** - Khi thay đổi service phải sửa BLoC

### ✅ **SAU KHI REFACTOR** (Đúng Clean Architecture)

```dart
// CommentBloc chỉ phụ thuộc vào UseCases (Domain layer)
class CommentBloc {
  final JoinPostUseCase _joinPostUseCase; // ✅ Domain layer dependency
  final LeavePostUseCase _leavePostUseCase;
  final EmitTypingUseCase _emitTypingUseCase;
  
  void _onJoinPost(...) {
    _joinPostUseCase(params: JoinPostParams(event.postId)); // ✅ Call through UseCase
  }
}
```

**Lợi ích:**
1. ✅ **Tuân theo Dependency Rule** - Presentation → Domain → Data
2. ✅ **Loose coupling** - Qua interface/abstraction
3. ✅ **Single Responsibility** - Mỗi layer có trách nhiệm riêng
4. ✅ **Dễ test** - Mock UseCases dễ dàng
5. ✅ **Dễ maintain** - Thay đổi service không ảnh hưởng BLoC

---

## 📊 Kiến Trúc Mới

### **Clean Architecture Layers**

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                            │
│                                                                  │
│  ┌────────────────┐         ┌────────────────┐                 │
│  │ ModalComment   │────────▶│  CommentBloc   │                 │
│  │   (Widget)     │         │    (BLoC)      │                 │
│  └────────────────┘         └───────┬────────┘                 │
│                                     │                            │
│                                     │ Uses                       │
│                                     ▼                            │
└─────────────────────────────────────┼─────────────────────────────┘
                                      │
┌─────────────────────────────────────┼─────────────────────────────┐
│                    DOMAIN LAYER      │                            │
│                                     │                            │
│              ┌──────────────────────┴─────────────────┐          │
│              │         Use Cases (Business Logic)     │          │
│              ├───────────────────────────────────────┤          │
│              │  - JoinPostUseCase                    │          │
│              │  - LeavePostUseCase                   │          │
│              │  - EmitTypingUseCase                  │          │
│              │  - ListenTypingUseCase                │          │
│              └───────────────┬───────────────────────┘          │
│                              │                                   │
│                              │ Implements                        │
│                              ▼                                   │
│              ┌─────────────────────────────┐                    │
│              │   CommentRepository         │                    │
│              │     (Interface)             │                    │
│              └───────────────┬─────────────┘                    │
│                              │                                   │
└──────────────────────────────┼───────────────────────────────────┘
                               │
┌──────────────────────────────┼───────────────────────────────────┐
│                    DATA LAYER│                                   │
│                              │                                   │
│                              ▼                                   │
│              ┌─────────────────────────────┐                    │
│              │ CommentRepositoryImpl       │                    │
│              │   (Implementation)          │                    │
│              └───────────────┬─────────────┘                    │
│                              │                                   │
│                              │ Uses                              │
│                              ▼                                   │
│              ┌─────────────────────────────┐                    │
│              │  CommentSocketService       │                    │
│              │   (WebSocket Data Source)   │                    │
│              └─────────────────────────────┘                    │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 📁 File Structure

### **Domain Layer** (Business Logic & Abstractions)

```
lib/features/post/domain/
├── repository/
│   └── comment_repository.dart          ← Interface (abstraction)
│
└── usecases/
    ├── join_post_usecase.dart           ← Business logic: Join post
    ├── leave_post_usecase.dart          ← Business logic: Leave post
    ├── emit_typing_usecase.dart         ← Business logic: Emit typing
    └── listen_typing_usecase.dart       ← Business logic: Listen typing
```

### **Data Layer** (Implementation Details)

```
lib/features/post/data/
└── repository/
    └── comment_repository_impl.dart     ← Repository implementation

lib/core/network/websocket/
└── comment_socket_service.dart          ← WebSocket data source
```

### **Presentation Layer** (UI & State Management)

```
lib/features/post/presentation/
├── bloc/comment/
│   ├── comment_bloc.dart                ← BLoC (uses UseCases)
│   ├── comment_event.dart
│   └── comment_state.dart
│
└── widgets/
    └── modal_comment.dart               ← UI widget
```

---

## 🔄 Dependency Flow

### **Dependency Rule:**
```
Presentation → Domain → Data
```

**Chi tiết:**
1. **Presentation depends on Domain**
   - `CommentBloc` depends on `UseCases`
   - `ModalComment` depends on `ListenTypingUseCase`

2. **Domain has NO dependencies** (chỉ có interfaces)
   - `CommentRepository` interface
   - `UseCases` implement business logic

3. **Data depends on Domain**
   - `CommentRepositoryImpl` implements `CommentRepository`
   - `CommentSocketService` là data source

---

## 📝 Code Examples

### **1. Domain Layer - Repository Interface**

```dart
// lib/features/post/domain/repository/comment_repository.dart

/// Repository interface - KHÔNG có implementation details
abstract class CommentRepository {
  void joinPost(String postId);
  void leavePost(String postId);
  void emitTyping({required String postId, required bool isTyping});
  Stream<TypingEvent> get typingStream;
}
```

**✅ Tại sao cần interface?**
- Abstraction - Presentation không biết về WebSocket
- Testability - Dễ mock trong unit tests
- Flexibility - Có thể thay đổi implementation (WebSocket → HTTP polling)

---

### **2. Domain Layer - Use Cases**

```dart
// lib/features/post/domain/usecases/join_post_usecase.dart

class JoinPostUseCase implements SyncUseCase<void, JoinPostParams> {
  final CommentRepository _repository;

  JoinPostUseCase(this._repository);

  @override
  void call({required JoinPostParams params}) {
    _repository.joinPost(params.postId);
  }
}
```

**✅ Tại sao cần UseCase?**
- **Single Responsibility** - Mỗi UseCase = 1 business operation
- **Reusability** - Có thể dùng trong nhiều BLoCs khác nhau
- **Testability** - Test business logic độc lập
- **Validation** - Có thể thêm validation trong UseCase

---

### **3. Data Layer - Repository Implementation**

```dart
// lib/features/post/data/repository/comment_repository_impl.dart

class CommentRepositoryImpl implements CommentRepository {
  final CommentSocketService _commentSocketService;

  CommentRepositoryImpl(this._commentSocketService);

  @override
  void joinPost(String postId) {
    _commentSocketService.joinPost(postId);
  }

  @override
  Stream<TypingEvent> get typingStream => 
      _commentSocketService.typingStream;
}
```

**✅ Vai trò của Repository Implementation:**
- Implement interface từ Domain layer
- Sử dụng data sources (WebSocket service)
- Có thể kết hợp nhiều data sources (cache + network)

---

### **4. Presentation Layer - BLoC**

```dart
// lib/features/post/presentation/bloc/comment/comment_bloc.dart

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final JoinPostUseCase _joinPostUseCase;
  final LeavePostUseCase _leavePostUseCase;
  final EmitTypingUseCase _emitTypingUseCase;

  CommentBloc({
    required JoinPostUseCase joinPostUseCase,
    required LeavePostUseCase leavePostUseCase,
    required EmitTypingUseCase emitTypingUseCase,
  }) : _joinPostUseCase = joinPostUseCase,
       _leavePostUseCase = leavePostUseCase,
       _emitTypingUseCase = emitTypingUseCase,
       super(CommentInitial()) {
    on<JoinPostEvent>(_onJoinPost);
    on<LeavePostEvent>(_onLeavePost);
    on<UserTypingEvent>(_onUserTyping);
  }

  void _onJoinPost(JoinPostEvent event, Emitter<CommentState> emit) {
    // ✅ Call UseCase - KHÔNG biết về WebSocket
    _joinPostUseCase(params: JoinPostParams(event.postId));
    emit(CommentJoined(postId: event.postId));
  }
}
```

**✅ BLoC chỉ biết về:**
- Events & States
- UseCases (Domain layer)
- **KHÔNG** biết về WebSocket, HTTP, Database, etc.

---

## 🧪 Testability

### **Before (Hard to Test)**

```dart
// ❌ Khó test vì phải mock cả WebSocket service
test('should join post', () {
  final mockService = MockCommentSocketService();
  final bloc = CommentBloc(commentSocketService: mockService);
  
  // Phải setup mock cho WebSocket connection, events, etc.
  when(mockService.connect(...)).thenReturn(...);
  when(mockService.joinPost(...)).thenReturn(...);
  
  bloc.add(JoinPostEvent('post123'));
  
  verify(mockService.joinPost('post123'));
});
```

### **After (Easy to Test)**

```dart
// ✅ Dễ test chỉ cần mock UseCase
test('should join post', () {
  final mockUseCase = MockJoinPostUseCase();
  final bloc = CommentBloc(
    joinPostUseCase: mockUseCase,
    leavePostUseCase: mockLeavePostUseCase,
    emitTypingUseCase: mockEmitTypingUseCase,
  );
  
  bloc.add(JoinPostEvent('post123'));
  
  // ✅ Simple verification
  verify(mockUseCase(params: JoinPostParams('post123')));
  expect(bloc.state, isA<CommentJoined>());
});
```

---

## 🔧 Dependency Injection

```dart
// lib/core/di/injection.dart

Future<void> initializeDependencies() async {
  // WebSocket Service (Data Source)
  s1.registerSingleton<CommentSocketService>(CommentSocketService());

  // Repository Implementation (Data Layer)
  s1.registerLazySingleton<CommentRepository>(
    () => CommentRepositoryImpl(s1()), // ← Inject service
  );

  // Use Cases (Domain Layer)
  s1.registerLazySingleton<JoinPostUseCase>(
    () => JoinPostUseCase(s1()), // ← Inject repository
  );
  s1.registerLazySingleton<LeavePostUseCase>(
    () => LeavePostUseCase(s1()),
  );
  s1.registerLazySingleton<EmitTypingUseCase>(
    () => EmitTypingUseCase(s1()),
  );
  s1.registerLazySingleton<ListenTypingUseCase>(
    () => ListenTypingUseCase(s1()),
  );

  // BLoC (Presentation Layer)
  s1.registerFactory<CommentBloc>(
    () => CommentBloc(
      joinPostUseCase: s1(), // ← Inject UseCases
      leavePostUseCase: s1(),
      emitTypingUseCase: s1(),
    ),
  );
}
```

**✅ Luồng dependency injection:**
```
Service → Repository → UseCase → BLoC
```

---

## 🎓 Clean Architecture Principles

### **1. Dependency Rule**
✅ Dependencies chỉ trỏ vào trong (inward)
```
Presentation → Domain ← Data
```

### **2. Separation of Concerns**
✅ Mỗi layer có trách nhiệm riêng:
- **Domain**: Business logic
- **Data**: Data sources & implementation
- **Presentation**: UI & state management

### **3. Abstraction**
✅ Presentation phụ thuộc vào abstraction (interfaces), không phụ thuộc concrete implementation

### **4. Testability**
✅ Mỗi layer test độc lập:
- Test UseCases without WebSocket
- Test BLoC without Repository
- Test Repository without Service

### **5. Maintainability**
✅ Thay đổi implementation không ảnh hưởng business logic:
- Đổi WebSocket → HTTP: Chỉ sửa `CommentRepositoryImpl`
- Thêm cache: Chỉ sửa Repository implementation
- Thay đổi BLoC: Không ảnh hưởng Domain

---

## 📊 So Sánh Before/After

| Aspect | Before ❌ | After ✅ |
|--------|-----------|----------|
| **Coupling** | Tight - BLoC → Service | Loose - BLoC → UseCase → Repository |
| **Testability** | Hard - Phải mock service | Easy - Mock UseCase |
| **Maintainability** | Low - Thay đổi service ảnh hưởng BLoC | High - Layers độc lập |
| **Reusability** | Low - Logic trong BLoC | High - UseCases reusable |
| **Dependencies** | Presentation → Data ❌ | Presentation → Domain → Data ✅ |
| **Clean Architecture** | ❌ Vi phạm | ✅ Tuân thủ |

---

## 🎯 Kết Luận

### **✅ Đã Đạt Được:**

1. **Tuân thủ Clean Architecture** 100%
2. **Dependency Rule** đúng: Presentation → Domain → Data
3. **Separation of Concerns** rõ ràng
4. **High Testability** - Dễ dàng unit test
5. **Low Coupling** - Thay đổi một layer không ảnh hưởng layers khác
6. **Single Responsibility** - Mỗi class có 1 trách nhiệm duy nhất

### **🚀 Lợi Ích Dài Hạn:**

- ✅ **Scalability**: Dễ thêm features mới
- ✅ **Maintainability**: Code dễ đọc, dễ sửa
- ✅ **Testability**: Dễ viết unit tests
- ✅ **Flexibility**: Dễ thay đổi implementation
- ✅ **Team Collaboration**: Nhiều người có thể làm việc song song trên các layers khác nhau

### **📚 Best Practices Applied:**

- ✅ SOLID Principles
- ✅ Dependency Inversion
- ✅ Interface Segregation
- ✅ Single Responsibility
- ✅ Separation of Concerns

---

## 🎓 Bài Học

**❌ SAI:**
```dart
// BLoC gọi trực tiếp Service
commentSocketService.joinPost(postId);
```

**✅ ĐÚNG:**
```dart
// BLoC gọi qua UseCase
_joinPostUseCase(params: JoinPostParams(postId));
```

**Nguyên tắc vàng:**
> "Presentation Layer KHÔNG BAO GIỜ gọi trực tiếp Data Layer.
> LUÔN đi qua Domain Layer (UseCases & Repositories)."

---

**🎉 Clean Architecture Achievement Unlocked!** 🏆

