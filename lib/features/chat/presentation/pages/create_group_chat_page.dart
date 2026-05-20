import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_event.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/conversation/conversation_state.dart';
import 'package:social_app_fe/features/chat/presentation/helper/chat_helper.dart';
import 'package:social_app_fe/features/chat/presentation/pages/chat_detail_page.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class CreateGroupChatPage extends StatefulWidget {
  final List<FriendEntity> friends;

  const CreateGroupChatPage({super.key, required this.friends});

  @override
  State<CreateGroupChatPage> createState() => _CreateGroupChatPageState();
}

class _CreateGroupChatPageState extends State<CreateGroupChatPage> {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  List<FriendEntity> _selectedFriends = [];
  List<FriendEntity> _filteredFriends = [];
  File? _groupAvatar;
  bool _hasChanges = false;
  String? _userId;
  String? _username;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _filteredFriends = widget.friends;
    _searchController.addListener(_onSearchChanged);
    _groupNameController.addListener(_onContentChanged);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userData = await TokenStorage.getUserData();
    setState(() {
      _userId = userData?['id'];
      _username = userData?['username'];
    });
  }

  @override
  void dispose() {
    _groupNameController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredFriends = widget.friends;
      } else {
        _filteredFriends = widget.friends.where((friend) {
          final fullName = friend.fullName?.toLowerCase() ?? '';
          final username = friend.username?.toLowerCase() ?? '';
          return fullName.contains(query) || username.contains(query);
        }).toList();
      }
    });
  }

  void _onContentChanged() {
    setState(() {
      _hasChanges = _groupNameController.text.isNotEmpty ? true : false;
    });
  }

  void _toggleFriendSelection(FriendEntity friend) {
    setState(() {
      if (_selectedFriends.contains(friend)) {
        _selectedFriends.remove(friend);
      } else {
        _selectedFriends.add(friend);
      }
      _hasChanges = _selectedFriends.isNotEmpty ? true : false;
    });
  }

  void _removeFriend(FriendEntity friend) {
    setState(() {
      _selectedFriends.remove(friend);
      _hasChanges = _selectedFriends.isNotEmpty ? true : false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _groupAvatar = File(pickedFile.path);
          _hasChanges = true;
        });
      }
    } catch (e) {
      showErrorSnackBar(context, 'Lỗi khi chọn ảnh: $e');
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(
                  Icons.camera_alt,
                  color: AppColors.textPrimary,
                  size: 24.sp,
                ),
                title: Text(
                  'Chụp ảnh',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.textPrimary,
                  size: 24.sp,
                ),
                title: Text(
                  'Chọn từ thư viện',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Hủy thao tác?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn hủy tạo nhóm chat không?',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Không',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Hủy',
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Future<void> _createGroupChat() async {
    if (_selectedFriends.isEmpty) {
      showErrorSnackBar(context, 'Vui lòng chọn ít nhất 1 người');
      return;
    }

    if (_userId == null) {
      showErrorSnackBar(context, 'Không tìm thấy thông tin người dùng');
      return;
    }

    setState(() {
      _isCreating = true;
    });

    try {
      final groupName = _groupNameController.text.trim();
      final participantIds = _selectedFriends.map((f) => f.userId).toList();

      // TODO: Upload avatar if exists
      // For now, avatar is null or local path
      String? avatarUrl;
      if (_groupAvatar != null) {
        // You can implement upload avatar logic here
        // avatarUrl = await uploadAvatar(_groupAvatar!);
        avatarUrl = _groupAvatar!.path; // Temporary: use local path
      }

      print('Creating group chat with:');
      print('- Name: $groupName');
      print('- Participants: $participantIds');
      print('- Avatar: $avatarUrl');

      // Dispatch CreateConversationEvent
      context.read<ConversationBloc>().add(
        CreateConversationEvent(
          userId: _userId!,
          participantIds: participantIds,
          isGroup: true,
          name: groupName.isNotEmpty ? groupName : null,
          avatar: avatarUrl,
        ),
      );
    } catch (e) {
      setState(() {
        _isCreating = false;
      });

      showErrorSnackBar(context, 'Lỗi khi tạo nhóm chat: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConversationBloc, ConversationState>(
      listener: (context, state) {
        if (state is CreateConversationSuccess) {
          setState(() {
            _isCreating = false;
          });

          // Navigate to chat detail page
          final conversation = state.conversation;

          // Get other participants (exclude current user)
          final otherParticipants = conversation.participants
              .where((p) => p.userId != _userId)
              .toList();

          String displayName = ChatHelper.formatConversationName(
            conversation,
            otherParticipants,
            null,
          );

          final messageBloc = s1<MessageBloc>();

          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => messageBloc,
                child: ChatDetailPage(
                  userId: _userId!,
                  username: _username!,
                  conversationId: conversation.id,
                  // friendInfo: friendInfo,
                  unreadCount: 0,
                  firstUnreadMessageIndex: null,
                  isGroup: true,
                  groupName: displayName,
                  groupAvatar: conversation.avatar,
                  participants: otherParticipants,
                ),
              ),
            ),
          );
        } else if (state is ConversationError) {
          setState(() {
            _isCreating = false;
          });

          showErrorSnackBar(context, 'Lỗi: ${state.message}');
        }
      },
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
              onPressed: () async {
                if (await _onWillPop()) {
                  Navigator.pop(context);
                }
              },
            ),
            title: Text(
              'Nhóm chat mới',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                fontSize: 18.sp,
              ),
            ),
          ),

          body: Column(
            children: [
              // Group avatar and name input
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    // Camera/Avatar button
                    GestureDetector(
                      onTap: _showImageSourceBottomSheet,
                      child: Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: AppColors.textSecondary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: _groupAvatar != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  _groupAvatar!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt,
                                color: AppColors.textSecondary,
                                size: 26.sp,
                              ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Group name input
                    Expanded(
                      child: TextField(
                        controller: _groupNameController,
                        cursorColor: AppColors.primary,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Tên nhóm (không bắt buộc)',
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 15.sp,
                          ),
                          filled: true,
                          fillColor: AppColors.textSecondary.withOpacity(0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Search field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: TextField(
                  controller: _searchController,
                  cursorColor: AppColors.primary,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15.sp,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 15.sp,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.textSecondary,
                    ),
                    filled: true,
                    fillColor: AppColors.textSecondary.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
              ),

              // Selected friends section
              if (_selectedFriends.isNotEmpty)
                Container(
                  height: 90.h,
                  padding: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _selectedFriends.length,
                    separatorBuilder: (context, index) => SizedBox(width: 12.w),
                    itemBuilder: (context, index) {
                      final friend = _selectedFriends[index];
                      return _buildSelectedFriendItem(friend);
                    },
                  ),
                ),

              // Section title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gợi ý',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Friends list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  itemCount: _filteredFriends.length,
                  itemBuilder: (context, index) {
                    final friend = _filteredFriends[index];
                    final isSelected = _selectedFriends.contains(friend);
                    return _buildFriendListItem(friend, isSelected);
                  },
                ),
              ),

              // Create button - only show if more than 2 users selected
              if (_selectedFriends.length >= 2)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  child: ElevatedButton(
                    onPressed: _isCreating ? null : _createGroupChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.5,
                      ),
                    ),
                    child: _isCreating
                        ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Tạo nhóm chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedFriendItem(FriendEntity friend) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.textSecondary.withOpacity(0.1),
              backgroundImage: friend.avatarUrl != null
                  ? NetworkImage(friend.avatarUrl!)
                  : null,
              child: friend.avatarUrl == null
                  ? Text(
                      friend.fullName?[0].toUpperCase() ??
                          friend.username?[0].toUpperCase() ??
                          '',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : null,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _removeFriend(friend),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.cancel,
                    size: 18.sp,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 60.w,
          child: Text(
            friend.fullName ?? friend.username ?? '',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildFriendListItem(FriendEntity friend, bool isSelected) {
    return InkWell(
      onTap: () => _toggleFriendSelection(friend),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: AppColors.textSecondary.withOpacity(0.1),
              backgroundImage: friend.avatarUrl != null
                  ? NetworkImage(friend.avatarUrl!)
                  : null,
              child: friend.avatarUrl == null
                  ? Text(
                      friend.fullName?[0].toUpperCase() ??
                          friend.username?[0].toUpperCase() ??
                          '',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.fullName ?? friend.username ?? '',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (friend.fullName != null)
                    Text(
                      '${friend.username}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary.withOpacity(0.3),
                  width: 2,
                ),
                color: isSelected ? AppColors.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
