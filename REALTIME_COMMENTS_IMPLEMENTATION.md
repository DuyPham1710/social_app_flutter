# Tích Hợp Realtime Comment Count - Hướng Dẫn

## Tổng Quan

Tính năng này cho phép hiển thị số lượng bình luận realtime trên trang home bằng cách sử dụng WebSocket để kết nối với backend NestJS comment gateway.

## Các Thành Phần Đã Tạo

### 1. Comment Entity & Model

- **File**: `lib/features/post/domain/entities/comment_entity.dart`
  - Entity định nghĩa cấu trúc dữ liệu comment trong domain layer
  
- **File**: `lib/features/post/data/models/comment_model.dart`
  - Model sử dụng Freezed để serialize/deserialize dữ liệu từ API
  - Có phương thức `toEntity()` để chuyển đổi sang CommentEntity

### 2. WebSocket Service

- **File**: `lib/core/network/websocket/comment_socket_service.dart`
  - Service quản lý kết nối WebSocket với comment gateway backend
  - Namespace: `/comment`
  - Base URL: Lấy từ `BASE_URL` constant (http://192.168.100.218:3000/)

#### Các Event WebSocket Được Hỗ Trợ:

**Client -> Server:**
- `register`: Đăng ký user với userId
- `joinPost`: Join vào room của một bài post
- `leavePost`: Rời khỏi room của một bài post
- `loadComments`: Load danh sách comments của một post
- `newComment`: Gửi comment mới
- `deleteComment`: Xóa comment

**Server -> Client:**
- `connected`: Kết nối thành công
- `register:ack`: Xác nhận đăng ký thành công
- `commentAdded`: Có comment mới được thêm
- `commentAdded:ack`: Xác nhận comment của user đã được thêm
- `commentDeleted`: Comment bị xóa
- `commentDeleted:ack`: Xác nhận comment của user đã bị xóa
- `commentsLoaded`: Danh sách comments đã được load
- `error`: Có lỗi xảy ra

#### Streams:

- `commentAddedStream`: Stream nhận sự kiện khi có comment mới
- `commentDeletedStream`: Stream nhận sự kiện khi comment bị xóa
- `commentCountStream`: Stream nhận Map<postId, commentCount> cập nhật

### 3. HomeBloc Updates

**File**: `lib/features/home/presentation/bloc/home_bloc.dart`

#### Thay đổi:
- Thêm `CommentSocketService` dependency
- Tự động kết nối WebSocket khi khởi tạo bloc
- Lắng nghe `commentCountStream` và emit event `UpdateCommentCountsEvent`
- Load comment counts cho tất cả posts khi load posts hoặc load more
- Dispose subscription khi bloc bị đóng

### 4. HomeState & HomeEvent Updates

**HomeState** (`lib/features/home/presentation/bloc/home_state.dart`):
- Thêm field `commentCounts: Map<String, int>?` để lưu comment count của từng post

**HomeEvent** (`lib/features/home/presentation/bloc/home_event.dart`):
- Thêm `UpdateCommentCountsEvent` để cập nhật comment counts

### 5. UI Updates

**PostAction** (`lib/features/post/presentation/widgets/post_action.dart`):
- Thêm parameter `commentCount`
- Hiển thị số lượng comment realtime
- Text động: "View all X comment(s)" hoặc "No comments yet"

**PostItem** (`lib/features/post/presentation/widgets/post_item.dart`):
- Thêm parameter `commentCount`
- Truyền `commentCount` xuống `PostAction`

**HomePage** (`lib/features/home/presentation/pages/home_page.dart`):
- Lấy comment count từ `state.commentCounts?[post.id]`
- Truyền xuống `PostItem`

### 6. Dependency Injection

**File**: `lib/core/di/injection.dart`
- Đăng ký `CommentSocketService` như singleton
- Inject `CommentSocketService` vào `HomeBloc`

### 7. TokenStorage Updates

**File**: `lib/core/local/token_storage.dart`
- Thêm phương thức `saveUserData()` để lưu user data
- Thêm phương thức `getUserData()` để lấy user data (bao gồm userId)
- Cập nhật `saveTokens()` để có thể lưu userData cùng lúc
- Cập nhật `clear()` để xóa userData khi logout

**File**: `lib/features/auth/data/repository/auth_repository_impl.dart`
- Lưu user data khi login thành công

## Luồng Hoạt Động

1. **Khởi động App**
   - `HomeBloc` được khởi tạo
   - `_initializeWebSocket()` được gọi
   - Lấy `userId` từ `TokenStorage.getUserData()`
   - Kết nối WebSocket với `commentSocketService.connect(userId)`
   - Đăng ký lắng nghe `commentCountStream`

2. **Load Posts**
   - User vào trang home
   - `LoadPostsEvent` được dispatch
   - Posts được load từ API
   - Với mỗi post, gọi `commentSocketService.loadComments(post.id)`
   - Backend emit event `commentsLoaded` với count hiện tại
   - `CommentSocketService` cập nhật `_commentCounts` map
   - Emit mới `commentCountStream`
   - `HomeBloc` nhận stream và add `UpdateCommentCountsEvent`
   - UI được cập nhật với số lượng comment mới

3. **Realtime Updates**
   - Khi có comment mới được thêm (từ bất kỳ user nào)
   - Backend emit `commentAdded` hoặc `commentAdded:ack`
   - `CommentSocketService` tăng count trong `_commentCounts`
   - Emit mới `commentCountStream`
   - UI tự động cập nhật

4. **Xóa Comment**
   - Khi comment bị xóa
   - Backend emit `commentDeleted` hoặc `commentDeleted:ack`
   - `CommentSocketService` giảm count trong `_commentCounts`
   - Emit mới `commentCountStream`
   - UI tự động cập nhật

## Cách Sử Dụng

### Để Join vào Post (nếu cần chi tiết realtime hơn):

```dart
commentSocketService.joinPost(postId);
```

### Để Leave Post:

```dart
commentSocketService.leavePost(postId);
```

### Để Gửi Comment Mới:

```dart
commentSocketService.sendComment(
  postId: 'post-id',
  content: 'Your comment',
  parentId: 'parent-comment-id', // optional
);
```

### Để Xóa Comment:

```dart
commentSocketService.deleteComment(
  commentId: 'comment-id',
  postId: 'post-id',
);
```

### Để Lắng Nghe Comment Events:

```dart
// Listen to comment added
commentSocketService.commentAddedStream.listen((event) {
  print('Comment added: ${event.comment.content}');
  print('Post ID: ${event.postId}');
  print('New count: ${event.count}');
});

// Listen to comment deleted
commentSocketService.commentDeletedStream.listen((event) {
  print('Comment deleted: ${event.commentId}');
  print('Post ID: ${event.postId}');
  print('New count: ${event.count}');
});
```

## Lưu Ý Quan Trọng

1. **WebSocket Connection**: 
   - Chỉ kết nối một lần khi `HomeBloc` khởi tạo
   - Tự động reconnect nếu mất kết nối (do socket.io client)

2. **Memory Management**:
   - Stream subscriptions được dispose khi `HomeBloc.close()` được gọi
   - WebSocket service được register như singleton, nên cần dispose thủ công khi cần

3. **Error Handling**:
   - Tất cả WebSocket errors được log ra console
   - UI không bị crash nếu WebSocket fail

4. **Performance**:
   - Comment counts được cache trong memory (`_commentCounts` map)
   - Chỉ emit stream khi có thay đổi

## Testing

### Test Backend Connection:

1. Đảm bảo backend đang chạy ở `http://192.168.100.218:3000`
2. Kiểm tra namespace `/comment` có hoạt động
3. Login vào app để có `userId`
4. Mở trang home và check logs:
   ```
   [CommentSocket] Connecting to comment socket: ...
   [CommentSocket] Connected to comment socket
   [CommentSocket] User registered: ...
   ```

### Test Realtime Updates:

1. Mở app trên 2 devices hoặc emulators
2. Tạo comment trên device 1
3. Kiểm tra comment count cập nhật trên device 2

## Troubleshooting

### WebSocket không kết nối:

- Kiểm tra `BASE_URL` trong `lib/core/constants/constants.dart`
- Kiểm tra backend có chạy không
- Kiểm tra firewall/network settings

### Comment count không cập nhật:

- Check logs để xem có nhận được events không
- Kiểm tra `userId` có được lưu trong `TokenStorage` không
- Kiểm tra `HomeBloc` có được khởi tạo đúng không

### Build errors:

```bash
cd social_app_fe
dart run build_runner build --delete-conflicting-outputs
```

## Dependencies

Đã có sẵn trong `pubspec.yaml`:
- `socket_io_client: ^3.1.2`
- `equatable: ^2.0.0`
- `flutter_bloc: ^9.1.0`
- `freezed_annotation: ^2.4.4`
- `json_annotation: ^4.9.0`

## Tương Lai

Có thể mở rộng để:
- Hiển thị danh sách comments trong post detail
- Typing indicator (user đang gõ comment)
- Online users trong post
- Reply comments với nested structure
- Edit comments realtime

