# Typing Indicator Implementation - Clean Architecture

## 📋 Tổng Quan

Tính năng typing indicator cho phép users thấy ai đang gõ comment trong cùng một post realtime. Được implement theo clean architecture với BLoC pattern.

## 🏗️ Kiến Trúc

```
┌─────────────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                            │
│                                                                  │
│  ┌────────────────┐         ┌────────────────┐                 │
│  │ ModalComment   │────────▶│  CommentBloc   │                 │
│  │   (Widget)     │         │   (BLoC)       │                 │
│  └────────────────┘         └───────┬────────┘                 │
│                                     │                            │
│                                     │ Events/States              │
│                                     │                            │
└─────────────────────────────────────┼─────────────────────────────┘
                                      │
                                      ▼
┌─────────────────────────────────────┼─────────────────────────────┐
│                    DATA LAYER        │                            │
│                                     │                            │
│                          ┌──────────▼───────────┐                │
│                          │ CommentSocketService │                │
│                          │  (WebSocket Client)  │                │
│                          └──────────┬───────────┘                │
│                                     │                            │
└─────────────────────────────────────┼─────────────────────────────┘
                                      │
                              WebSocket Events
                                      │
┌─────────────────────────────────────┼─────────────────────────────┐
│                    BACKEND          │                            │
│                                     ▼                            │
│                          ┌────────────────────┐                 │
│                          │  CommentGateway    │                 │
│                          │  (NestJS Socket)   │                 │
│                          └────────────────────┘                 │
└──────────────────────────────────────────────────────────────────┘
```

## 📁 Files Created/Modified

### Created Files:

1. **`lib/features/post/presentation/bloc/comment/comment_event.dart`**
   - `JoinPostEvent` - Join vào post room
   - `LeavePostEvent` - Leave post room
   - `UserTypingEvent` - User đang typing
   - `UpdateTypingUsersEvent` - Cập nhật danh sách users đang typing

2. **`lib/features/post/presentation/bloc/comment/comment_state.dart`**
   - `TypingUser` - Model cho typing user
   - `CommentInitial` - State khởi tạo
   - `CommentJoined` - State khi đã join post

3. **`lib/features/post/presentation/bloc/comment/comment_bloc.dart`**
   - Quản lý logic typing indicator
   - Handle join/leave post
   - Handle typing events

### Modified Files:

1. **`lib/core/network/websocket/comment_socket_service.dart`**
   - Thêm `typingStream` để emit typing events
   - Thêm `emitTyping()` method
   - Listen `userTyping` event từ backend
   - Thêm `TypingEvent` class

2. **`lib/core/di/injection.dart`**
   - Register `CommentBloc` factory

3. **`lib/features/post/presentation/widgets/post_action.dart`**
   - Thêm `postId` parameter
   - Truyền `postId` vào `ModalComment`

4. **`lib/features/post/presentation/widgets/post_item.dart`**
   - Truyền `post.id` vào `PostAction`

5. **`lib/features/post/presentation/widgets/modal_comment.dart`**
   - Thêm `postId` parameter
   - Integrate `CommentBloc`
   - Join post khi mở modal
   - Leave post khi đóng modal
   - Listen typing events
   - Emit typing event khi user gõ
   - Hiển thị typing indicator UI

---

## 🔄 Luồng Hoạt Động Chi Tiết

### 1️⃣ **Mở Modal Comment**

```dart
// User tap vào comment icon
PostAction(postId: 'post123', commentCount: 5)
    ↓
showModalBottomSheet(
  builder: (_) => ModalComment(postId: 'post123')
)
    ↓
_ModalCommentState.initState()
    ↓
_commentBloc = s1<CommentBloc>();
    ↓
_commentBloc.add(JoinPostEvent('post123'));
    ↓
CommentBloc._onJoinPost()
    ↓
commentSocketService.joinPost('post123');
    ↓
[WebSocket] emit('joinPost', {postId: 'post123'})
    ↓
Backend CommentGateway.handleJoinPost()
    ↓
client.join('post123'); // Join room
    ↓
emit('joinPost:ack') → Client
    ↓
CommentBloc emit CommentJoined(postId: 'post123')
    ↓
✅ Modal đã join post room, sẵn sàng nhận typing events
```

### 2️⃣ **User A Đang Gõ Comment**

```dart
// User A gõ text
TextField.controller.addListener(_onTextChanged)
    ↓
_onTextChanged() được gọi
    ↓
_controller.text.isNotEmpty == true
    ↓
_commentBloc.add(UserTypingEvent(
  postId: 'post123',
  isTyping: true
))
    ↓
CommentBloc._onUserTyping()
    ↓
commentSocketService.emitTyping(
  postId: 'post123',
  isTyping: true
)
    ↓
[WebSocket] emit('typing', {
  postId: 'post123',
  isTyping: true
})
    ↓
Backend CommentGateway.handleTyping()
    ↓
Lấy userConnection từ Map
    ↓
[WebSocket Broadcast] client.to('post123').emit('userTyping', {
  userId: 'user_A',
  username: 'John Doe',
  isTyping: true,
  postId: 'post123'
})
    ↓
✅ Tất cả users khác trong room nhận event
```

### 3️⃣ **User B Nhận Typing Event**

```dart
// User B đang xem cùng post
CommentSocketService._socket.on('userTyping')
    ↓
Nhận data: {
  userId: 'user_A',
  username: 'John Doe',
  isTyping: true,
  postId: 'post123'
}
    ↓
_typingController.add(TypingEvent(...))
    ↓
_ModalCommentState._typingSubscription receives event
    ↓
if (typingEvent.postId == widget.postId)
    ↓
_commentBloc.add(UpdateTypingUsersEvent(
  userId: 'user_A',
  username: 'John Doe',
  isTyping: true
))
    ↓
CommentBloc._onUpdateTypingUsers()
    ↓
updatedTypingUsers.add(TypingUser(
  userId: 'user_A',
  username: 'John Doe'
))
    ↓
emit(CommentJoined(
  postId: 'post123',
  typingUsers: {TypingUser(...)}
))
    ↓
BlocBuilder<CommentBloc, CommentState> rebuild
    ↓
_buildTypingIndicator() được gọi
    ↓
state.typingUsers.isNotEmpty == true
    ↓
Hiển thị: "John Doe is typing..."
    ↓
✅ User B thấy User A đang gõ
```

### 4️⃣ **User A Dừng Gõ**

```dart
// User A không gõ trong 1 giây
_typingTimer = Timer(Duration(seconds: 1), () {
  _commentBloc.add(UserTypingEvent(
    postId: 'post123',
    isTyping: false // ← Stop typing
  ));
})
    ↓
[WebSocket] emit('typing', {isTyping: false})
    ↓
Backend broadcast 'userTyping' {isTyping: false}
    ↓
User B nhận event
    ↓
updatedTypingUsers.removeWhere((user) => user.userId == 'user_A')
    ↓
emit(CommentJoined(typingUsers: {})) // Empty set
    ↓
_buildTypingIndicator() return SizedBox.shrink()
    ↓
✅ Typing indicator biến mất
```

### 5️⃣ **Đóng Modal**

```dart
// User đóng modal
_ModalCommentState.dispose()
    ↓
_commentBloc.add(LeavePostEvent('post123'));
    ↓
commentSocketService.leavePost('post123');
    ↓
[WebSocket] emit('leavePost', {postId: 'post123'})
    ↓
Backend: client.leave('post123')
    ↓
Backend: emit('userLeft') → Other users
    ↓
_commentBloc.close()
    ↓
_typingSubscription?.cancel()
    ↓
_typingTimer?.cancel()
    ↓
✅ Clean up resources
```

---

## 🎨 UI Implementation

### Typing Indicator Widget

```dart
Widget _buildTypingIndicator() {
  return BlocBuilder<CommentBloc, CommentState>(
    builder: (context, state) {
      if (state is CommentJoined && state.typingUsers.isNotEmpty) {
        final typingUsers = state.typingUsers.toList();
        String typingText;

        // 1 user typing
        if (typingUsers.length == 1) {
          typingText = '${typingUsers[0].username ?? 'Someone'} is typing...';
        }
        // 2 users typing
        else if (typingUsers.length == 2) {
          typingText = '${typingUsers[0].username} and ${typingUsers[1].username} are typing...';
        }
        // 3+ users typing
        else {
          typingText = '${typingUsers[0].username} and ${typingUsers.length - 1} others are typing...';
        }

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Row(
            children: [
              // Spinning indicator
              SizedBox(
                width: 16.w,
                height: 16.h,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[600]!),
                ),
              ),
              SizedBox(width: 8.w),
              // Typing text
              Text(
                typingText,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink(); // Hide when no one typing
    },
  );
}
```

### Position in Modal

```
┌─────────────────────────────┐
│   Modal Comment Header      │
├─────────────────────────────┤
│                             │
│   Comment List              │
│   (Scrollable)              │
│                             │
├─────────────────────────────┤
│ 🔄 "John is typing..."      │ ← Typing Indicator
├─────────────────────────────┤
│ 👤  [Comment Input Field]   │
│                         [📤] │
└─────────────────────────────┘
```

---

## 🔧 Technical Details

### CommentBloc State Management

```dart
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentSocketService commentSocketService;
  Timer? _typingDebounce;

  CommentBloc({required this.commentSocketService}) 
    : super(CommentInitial()) {
    on<JoinPostEvent>(_onJoinPost);
    on<LeavePostEvent>(_onLeavePost);
    on<UserTypingEvent>(_onUserTyping);
    on<UpdateTypingUsersEvent>(_onUpdateTypingUsers);
  }
}
```

### Typing Debounce Logic

```dart
void _onUserTyping(UserTypingEvent event, Emitter<CommentState> emit) {
  _typingDebounce?.cancel();

  if (event.isTyping) {
    // Emit typing = true immediately
    commentSocketService.emitTyping(postId: event.postId, isTyping: true);
    
    // Auto-stop after 2 seconds
    _typingDebounce = Timer(Duration(seconds: 2), () {
      commentSocketService.emitTyping(postId: event.postId, isTyping: false);
    });
  } else {
    // User stopped manually
    commentSocketService.emitTyping(postId: event.postId, isTyping: false);
  }
}
```

### TypingUser Model

```dart
class TypingUser {
  final String userId;
  final String? username;

  const TypingUser({required this.userId, this.username});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TypingUser && userId == other.userId;

  @override
  int get hashCode => userId.hashCode;
}
```

---

## 🎯 Key Features

### ✅ Realtime Updates
- Typing events được broadcast realtime qua WebSocket
- Tất cả users trong cùng post room nhận updates ngay lập tức

### ✅ Multiple Users Support
- Hiển thị tên người đang typing
- Handle nhiều users typing cùng lúc:
  - 1 user: "John is typing..."
  - 2 users: "John and Jane are typing..."
  - 3+ users: "John and 5 others are typing..."

### ✅ Smart Debouncing
- Auto stop typing sau 2 giây không activity
- Cancel previous timer khi user tiếp tục gõ
- Optimize số lượng socket events

### ✅ Clean Architecture
- **Presentation**: CommentBloc, CommentEvent, CommentState
- **Data**: CommentSocketService (WebSocket client)
- **Separation of Concerns**: UI không biết về WebSocket details

### ✅ Memory Management
- Auto dispose subscriptions khi đóng modal
- Cancel timers để tránh memory leaks
- Leave post room khi không cần

---

## 🧪 Testing Scenarios

### Test Case 1: Single User Typing
```
1. User A mở modal comment
2. User A bắt đầu gõ
3. User B mở modal cùng post
4. ✅ User B thấy: "User A is typing..."
```

### Test Case 2: Multiple Users Typing
```
1. User A, B, C mở modal cùng post
2. User A bắt đầu gõ
3. User B bắt đầu gõ
4. ✅ User C thấy: "User A and User B are typing..."
5. User D bắt đầu gõ
6. ✅ User C thấy: "User A and 2 others are typing..."
```

### Test Case 3: Stop Typing
```
1. User A đang gõ
2. User B thấy typing indicator
3. User A dừng gõ 2 giây
4. ✅ Typing indicator biến mất ở User B
```

### Test Case 4: Close Modal
```
1. User A mở modal và gõ
2. User B thấy typing indicator
3. User A đóng modal
4. ✅ Typing indicator biến mất ngay lập tức
5. ✅ User A đã leave post room
```

---

## 🚀 Usage

### Mở Modal với Typing Indicator

```dart
// Từ PostAction hoặc bất kỳ đâu
showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  builder: (context) => ModalComment(
    postId: 'your-post-id',
    isPressComment: true, // Auto focus input
  ),
);
```

### Custom Typing Indicator Style

```dart
// Trong _buildTypingIndicator(), bạn có thể customize:
Text(
  typingText,
  style: TextStyle(
    fontSize: 14.sp,           // Thay đổi size
    color: Colors.blue,        // Thay đổi màu
    fontWeight: FontWeight.w500, // Thay đổi weight
  ),
)
```

---

## 📊 Performance Optimization

1. **Debounce Timer**: Giảm số lượng socket events
2. **Set for TypingUsers**: O(1) lookup, tránh duplicates
3. **Stream Subscription**: Chỉ listen khi modal mở
4. **BLoC Pattern**: Efficient state management
5. **Dispose Pattern**: Clean up resources đúng cách

---

## 🔒 Security Considerations

1. **User Authentication**: Backend verify user qua `connectedUsers` Map
2. **Post Authorization**: Chỉ users trong post room nhận events
3. **Input Validation**: Backend validate postId trước khi join room

---

## 🎓 Clean Architecture Benefits

1. **Testability**: Dễ dàng unit test CommentBloc
2. **Maintainability**: Logic tách biệt rõ ràng
3. **Scalability**: Dễ thêm features mới (reactions, etc.)
4. **Reusability**: CommentBloc có thể dùng cho nhiều UI khác nhau

---

## 🔮 Future Enhancements

Có thể mở rộng thêm:
- ✨ Animated typing dots (... → .. → .)
- ✨ Show avatar của người đang typing
- ✨ Sound notification khi có typing
- ✨ Custom typing timeout cho từng user
- ✨ Typing indicator cho reply comments

---

## 🎉 Kết Luận

Tính năng typing indicator đã được implement hoàn chỉnh theo clean architecture với:
- ✅ Realtime updates qua WebSocket
- ✅ Multiple users support
- ✅ Smart debouncing
- ✅ Clean code structure
- ✅ Proper resource management
- ✅ Beautiful UI

Code dễ maintain, test và mở rộng trong tương lai! 🚀

