# Luồng Chạy Chi Tiết - Frontend & Backend

## 📊 Tổng Quan Kiến Trúc

```
┌─────────────────────────────────────────────────────────────────┐
│                         FLUTTER APP (FE)                         │
│  ┌──────────────┐      ┌──────────────┐      ┌──────────────┐  │
│  │   HomePage   │─────▶│   HomeBloc   │─────▶│ PostItem UI  │  │
│  └──────────────┘      └───────┬──────┘      └──────────────┘  │
│                                │                                 │
│                                ▼                                 │
│                    ┌─────────────────────┐                      │
│                    │ CommentSocketService│                      │
│                    └──────────┬──────────┘                      │
└───────────────────────────────┼──────────────────────────────────┘
                                │
                          WebSocket (socket.io)
                          ws://192.168.100.218:3000/comment
                                │
┌───────────────────────────────┼──────────────────────────────────┐
│                               ▼                                   │
│                    ┌─────────────────────┐                       │
│                    │  CommentGateway     │                       │
│                    │  (NestJS Backend)   │                       │
│                    └──────────┬──────────┘                       │
│                               │                                   │
│                               ▼                                   │
│                    ┌─────────────────────┐                       │
│                    │  CommentService     │                       │
│                    └──────────┬──────────┘                       │
│                               │                                   │
│                               ▼                                   │
│                    ┌─────────────────────┐                       │
│                    │  MongoDB Database   │                       │
│                    │  (Comments Schema)  │                       │
│                    └─────────────────────┘                       │
└───────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Luồng 1: Khởi Động App và Kết Nối WebSocket

### **Frontend (Flutter)**

#### 1. App khởi động (`main.dart`)
```dart
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies(); // ← Đăng ký dependencies
  
  final homeBloc = s1<HomeBloc>(); // ← Tạo HomeBloc
  runApp(MyApp());
}
```

#### 2. Dependency Injection (`injection.dart`)
```dart
Future<void> initializeDependencies() async {
  // Đăng ký CommentSocketService như singleton
  s1.registerSingleton<CommentSocketService>(CommentSocketService());
  
  // Đăng ký HomeBloc với CommentSocketService
  s1.registerFactory<HomeBloc>(
    () => HomeBloc(
      getHomePostsUseCase: s1(),
      commentSocketService: s1(), // ← Inject service
    ),
  );
}
```

#### 3. HomeBloc khởi tạo (`home_bloc.dart`)
```dart
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc({
    required this.commentSocketService,
  }) : super(HomeInitial()) {
    _initializeWebSocket(); // ← Tự động kết nối khi khởi tạo
  }
  
  Future<void> _initializeWebSocket() async {
    // Lấy userId từ SharedPreferences
    final userData = await TokenStorage.getUserData();
    final userId = userData?['id']; // ← userId MongoDB ObjectId
    
    if (userId != null) {
      // Kết nối WebSocket
      commentSocketService.connect(userId);
      
      // Lắng nghe stream để cập nhật UI
      _commentCountSubscription = commentSocketService
          .commentCountStream
          .listen((commentCounts) {
            add(UpdateCommentCountsEvent(commentCounts));
          });
    }
  }
}
```

#### 4. CommentSocketService kết nối (`comment_socket_service.dart`)
```dart
void connect(String userId) {
  // Tạo WebSocket URL
  final baseUrl = 'http://192.168.100.218:3000';
  
  _socket = IO.io(
    '$baseUrl/comment', // ← Namespace /comment
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .disableAutoConnect()
        .build(),
  );
  
  _socket!.connect();
  
  // Lắng nghe khi kết nối thành công
  _socket!.onConnect((_) {
    print('✅ Connected to comment socket');
    
    // Gửi event register với userId
    _socket!.emit('register', {'userId': userId});
  });
  
  // Lắng nghe xác nhận đăng ký
  _socket!.on('register:ack', (data) {
    print('✅ User registered: $data');
  });
}
```

### **Backend (NestJS)**

#### 5. CommentGateway nhận kết nối (`comment.gateway.ts`)
```typescript
@WebSocketGateway({
  cors: { origin: '*' },
  namespace: '/comment', // ← Namespace
})
export class CommentGateway {
  handleConnection(client: Socket) {
    console.log(`🔌 New client connected: ${client.id}`);
    
    // Gửi thông báo kết nối thành công
    client.emit('connected', {
      message: 'Connected to comment service',
      socketId: client.id,
      timestamp: new Date(),
    });
  }
}
```

#### 6. Backend nhận event `register`
```typescript
@SubscribeMessage('register')
handleRegister(client: Socket, payload: { userId: string }) {
  const { userId } = payload;
  
  // Lưu thông tin user vào Map
  this.connectedUsers.set(client.id, {
    userId: userId,
    connectedAt: new Date(),
  });
  
  console.log(`✅ User registered: ${userId}`);
  
  // Gửi xác nhận về client
  client.emit('register:ack', {
    message: 'Successfully registered',
    userId,
    socketId: client.id,
  });
}
```

**🔄 Kết quả**: WebSocket connection established, user đã được đăng ký với userId

---

## 🔄 Luồng 2: Load Posts và Comment Counts

### **Frontend (Flutter)**

#### 1. User vào HomePage
```dart
class HomePage extends StatefulWidget {
  @override
  void initState() {
    super.initState();
    // Load posts lần đầu
    context.read<HomeBloc>().add(LoadPostsEvent(page: 1, limit: 2));
  }
}
```

#### 2. HomeBloc xử lý LoadPostsEvent
```dart
Future<void> _onLoadPosts(
  LoadPostsEvent event,
  Emitter<HomeState> emit,
) async {
  emit(HomeLoading());
  
  // Gọi API để lấy danh sách posts
  final dataState = await getHomePostsUseCase(
    params: GetHomePostsParams(page: 1, limit: 2),
  );
  
  if (dataState is DataStateSuccess) {
    final posts = dataState.data!.data;
    
    // ✅ QUAN TRỌNG: Load comment counts cho từng post
    for (final post in posts) {
      commentSocketService.loadComments(post.id); // ← Gửi qua WebSocket
    }
    
    emit(HomeLoaded(posts, commentCounts: {}));
  }
}
```

#### 3. CommentSocketService gửi event `loadComments`
```dart
void loadComments(String postId) {
  if (_socket == null || !_socket!.connected) return;
  
  print('📤 Loading comments for post: $postId');
  
  // Gửi event đến backend
  _socket!.emit('loadComments', {'postId': postId});
}
```

### **Backend (NestJS)**

#### 4. CommentGateway nhận event `loadComments`
```typescript
@SubscribeMessage('loadComments')
async handleLoadComments(
  client: Socket, 
  payload: { postId: string }
) {
  const { postId } = payload;
  
  console.log(`📥 Loading comments for post ${postId}`);
  
  // Gọi CommentService để lấy comments từ DB
  const comments = await this.commentService.findByPostId(postId);
  
  // Gửi kết quả về client
  client.emit('commentsLoaded', {
    postId,
    comments,
    count: comments.length, // ← Số lượng comments
    timestamp: new Date(),
  });
}
```

#### 5. CommentService query MongoDB
```typescript
class CommentService {
  async findByPostId(postId: string) {
    // Query MongoDB để lấy tất cả comments của post
    return await this.commentModel
      .find({ postId })
      .populate('userId') // ← Populate user info
      .exec();
  }
}
```

### **Frontend (Flutter) - Nhận Response**

#### 6. CommentSocketService nhận event `commentsLoaded`
```dart
void connect(String userId) {
  // ... (code kết nối)
  
  // Lắng nghe event commentsLoaded
  _socket!.on('commentsLoaded', (data) {
    print('📥 Comments loaded: ${data['count']} comments');
    
    final postId = data['postId'] as String;
    final count = data['count'] as int;
    
    // Cập nhật vào Map
    _commentCounts[postId] = count;
    
    // Emit stream để UI cập nhật
    _commentCountController.add(Map.from(_commentCounts));
  });
}
```

#### 7. HomeBloc nhận stream update
```dart
Future<void> _initializeWebSocket() async {
  // Lắng nghe stream
  _commentCountSubscription = commentSocketService
      .commentCountStream
      .listen((commentCounts) {
        // Emit event để cập nhật state
        add(UpdateCommentCountsEvent(commentCounts));
      });
}

void _onUpdateCommentCounts(
  UpdateCommentCountsEvent event,
  Emitter<HomeState> emit,
) {
  if (state is HomeLoaded) {
    // Tạo state mới với commentCounts updated
    emit(HomeLoaded(
      currentState.posts!,
      commentCounts: event.commentCounts, // ← Map<postId, count>
      ...
    ));
  }
}
```

#### 8. UI tự động rebuild
```dart
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoaded) {
          return ListView.builder(
            itemBuilder: (context, index) {
              final post = state.posts![index];
              final commentCount = state.commentCounts?[post.id] ?? 0; // ← Lấy count
              
              return PostItem(
                post: post,
                commentCount: commentCount, // ← Truyền xuống UI
              );
            },
          );
        }
      },
    );
  }
}
```

#### 9. PostAction hiển thị comment count
```dart
class PostAction extends StatelessWidget {
  final int commentCount;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(CupertinoIcons.chat_bubble),
        Text("$commentCount"), // ← Hiển thị số comment
      ],
    );
  }
}
```

**🔄 Kết quả**: UI hiển thị số lượng comments của mỗi post

---

## 🔄 Luồng 3: Thêm Comment Mới (Realtime Update)

### **Scenario**: User A thêm comment, User B thấy cập nhật realtime

### **User A - Frontend (Flutter)**

#### 1. User A gửi comment
```dart
// Giả sử user nhấn nút "Send Comment"
commentSocketService.sendComment(
  postId: 'post123',
  content: 'Great post!',
);
```

#### 2. CommentSocketService emit event
```dart
void sendComment({
  required String postId,
  required String content,
  String? parentId,
}) {
  _socket!.emit('newComment', {
    'postId': postId,
    'content': content,
    if (parentId != null) 'parentId': parentId,
  });
}
```

### **Backend (NestJS)**

#### 3. CommentGateway nhận event `newComment`
```typescript
@SubscribeMessage('newComment')
async handleNewComment(
  client: Socket,
  payload: CreateCommentDto,
) {
  // Lấy thông tin user từ connectedUsers Map
  const userConnection = this.connectedUsers.get(client.id);
  const { postId, content } = payload;
  
  console.log(`💬 New comment from user ${userConnection.userId}`);
  
  // Lưu comment vào database
  const created = await this.commentService.create(
    payload,
    userConnection.userId,
  );
  
  const commentData = {
    comment: created, // ← Comment object với đầy đủ thông tin
    timestamp: new Date(),
    postId: postId.toString(),
  };
  
  // ✅ Gửi đến TẤT CẢ users khác trong cùng post room
  client.to(postId.toString()).emit('commentAdded', commentData);
  
  // ✅ Gửi xác nhận về chính user A
  client.emit('commentAdded:ack', {
    ...commentData,
    message: 'Comment created successfully',
  });
}
```

#### 4. CommentService lưu vào MongoDB
```typescript
class CommentService {
  async create(dto: CreateCommentDto, userId: string) {
    const comment = new this.commentModel({
      content: dto.content,
      userId: userId,
      postId: dto.postId,
      parentId: dto.parentId,
    });
    
    // Lưu vào MongoDB
    const saved = await comment.save();
    
    // Populate user info
    return await saved.populate('userId').execPopulate();
  }
}
```

### **User A - Frontend (Flutter) - Nhận ACK**

#### 5. User A nhận `commentAdded:ack`
```dart
void connect(String userId) {
  _socket!.on('commentAdded:ack', (data) {
    print('✅ Comment added successfully');
    
    final comment = CommentModel.fromJson(data['comment']);
    final postId = data['postId'] as String;
    
    // Tăng count
    _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;
    
    // Emit stream
    _commentCountController.add(Map.from(_commentCounts));
    
    // Emit comment added event
    _commentAddedController.add(CommentUpdateEvent(
      comment: comment,
      postId: postId,
      count: _commentCounts[postId]!,
    ));
  });
}
```

### **User B - Frontend (Flutter) - Nhận Update**

#### 6. User B nhận `commentAdded`
```dart
void connect(String userId) {
  _socket!.on('commentAdded', (data) {
    print('🔔 New comment added by someone else');
    
    final comment = CommentModel.fromJson(data['comment']);
    final postId = data['postId'] as String;
    
    // Tăng count
    _commentCounts[postId] = (_commentCounts[postId] ?? 0) + 1;
    
    // Emit stream để UI cập nhật
    _commentCountController.add(Map.from(_commentCounts));
    
    _commentAddedController.add(CommentUpdateEvent(
      comment: comment,
      postId: postId,
      count: _commentCounts[postId]!,
    ));
  });
}
```

#### 7. HomeBloc của cả User A và User B cập nhật state
```dart
// Stream subscription trigger
_commentCountSubscription = commentSocketService
    .commentCountStream
    .listen((commentCounts) {
      add(UpdateCommentCountsEvent(commentCounts));
    });

// Event handler
void _onUpdateCommentCounts(...) {
  emit(HomeLoaded(
    posts,
    commentCounts: event.commentCounts, // ← Updated counts
  ));
}
```

#### 8. UI của cả User A và User B tự động rebuild
```dart
// BlocBuilder tự động rebuild khi state thay đổi
BlocBuilder<HomeBloc, HomeState>(
  builder: (context, state) {
    if (state is HomeLoaded) {
      final commentCount = state.commentCounts?[post.id] ?? 0;
      // UI hiển thị số mới: count + 1
      return PostAction(commentCount: commentCount);
    }
  },
);
```

**🔄 Kết quả**: 
- User A thấy comment count tăng ngay lập tức (via `commentAdded:ack`)
- User B thấy comment count tăng ngay lập tức (via `commentAdded`)
- Database đã được cập nhật
- Tất cả users đang xem cùng post đều thấy cập nhật realtime

---

## 🔄 Luồng 4: Xóa Comment (Realtime Update)

### **Frontend (Flutter)**

#### 1. User xóa comment
```dart
commentSocketService.deleteComment(
  commentId: 'comment456',
  postId: 'post123',
);
```

### **Backend (NestJS)**

#### 2. CommentGateway xử lý
```typescript
@SubscribeMessage('deleteComment')
async handleDeleteComment(
  client: Socket,
  payload: { commentId: string; postId: string },
) {
  const { commentId, postId } = payload;
  const userConnection = this.connectedUsers.get(client.id);
  
  // Xóa comment trong database
  await this.commentService.remove(commentId, userConnection.userId);
  
  const deleteData = {
    id: commentId,
    postId,
    timestamp: new Date(),
  };
  
  // Broadcast đến tất cả users
  client.to(postId).emit('commentDeleted', deleteData);
  client.emit('commentDeleted:ack', deleteData);
}
```

### **Frontend (Flutter) - Nhận Update**

#### 3. Tất cả users nhận event và cập nhật
```dart
_socket!.on('commentDeleted', (data) {
  final postId = data['postId'] as String;
  
  // Giảm count
  if (_commentCounts[postId] != null && _commentCounts[postId]! > 0) {
    _commentCounts[postId] = _commentCounts[postId]! - 1;
  }
  
  // Emit stream
  _commentCountController.add(Map.from(_commentCounts));
});
```

**🔄 Kết quả**: Comment count giảm đi 1, tất cả users thấy cập nhật realtime

---

## 🔍 Các Điểm Quan Trọng

### 1. **WebSocket Rooms**
Backend sử dụng Socket.IO rooms để group users theo post:
```typescript
// User join post room
client.join(postId);

// Emit chỉ đến users trong room
client.to(postId).emit('commentAdded', data);
```

### 2. **Data Flow Pattern**
```
User Action → Socket Event → Backend Gateway → Service → Database
                    ↓
              Backend Response
                    ↓
          Socket Event (broadcast)
                    ↓
         All Clients Update UI
```

### 3. **State Management**
- **Backend**: Lưu user connections trong Map (memory)
- **Frontend**: Lưu comment counts trong Map (memory) + BLoC state

### 4. **Error Handling**
- Backend validate input và emit 'error' event nếu fail
- Frontend log errors nhưng không crash UI

### 5. **Performance Optimization**
- Comment counts được cache trong memory
- Chỉ emit stream khi có thay đổi thực sự
- UI chỉ rebuild khi state thay đổi (via BLoC)

---

## 📝 Summary Flow Chart

```
┌──────────────┐
│  App Start   │
└──────┬───────┘
       │
       ▼
┌──────────────┐
│  HomeBloc    │
│  Initialize  │
└──────┬───────┘
       │
       ▼
┌─────────────────────┐
│  WebSocket Connect  │
│  emit: register     │
└──────┬──────────────┘
       │
       ▼
┌──────────────────────┐
│  Backend Register    │
│  emit: register:ack  │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐
│  Load Posts (API)    │
└──────┬───────────────┘
       │
       ▼
┌──────────────────────┐     ┌─────────────────┐
│  For Each Post:      │────▶│  emit:          │
│  emit: loadComments  │     │  loadComments   │
└──────────────────────┘     └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │  Backend Query  │
                             │  MongoDB        │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │  emit:          │
                             │  commentsLoaded │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │  Update Map     │
                             │  Emit Stream    │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │  BLoC Update    │
                             │  State          │
                             └────────┬────────┘
                                      │
                                      ▼
                             ┌─────────────────┐
                             │  UI Rebuild     │
                             │  Show Counts    │
                             └─────────────────┘
```

---

## 🎯 Kết Luận

1. **WebSocket Connection**: Duy trì kết nối persistent giữa Flutter app và NestJS server
2. **Event-Driven**: Sử dụng events để giao tiếp 2 chiều
3. **Realtime Updates**: Tất cả clients nhận updates ngay lập tức
4. **State Management**: BLoC pattern quản lý state trên Flutter side
5. **Scalable**: Có thể mở rộng thêm nhiều events khác (typing, reactions, etc.)

Luồng này đảm bảo:
- ✅ Dữ liệu luôn đồng bộ giữa tất cả clients
- ✅ Performance tốt với caching
- ✅ Error handling proper
- ✅ Dễ maintain và extend

