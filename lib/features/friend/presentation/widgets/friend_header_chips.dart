import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_online_service.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_suggestions_page.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friends_list_page.dart';

class FriendHeaderChips extends StatefulWidget {
  final VoidCallback? onNeedRefresh;
  
  const FriendHeaderChips({
    super.key,
    this.onNeedRefresh,
  });

  @override
  State<FriendHeaderChips> createState() => _FriendHeaderChipsState();
}

class _FriendHeaderChipsState extends State<FriendHeaderChips> {
  FriendOnlineService? _onlineService;
  StreamSubscription<int>? _onlineCountSubscription;
  int _onlineCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeOnlineService();
  }

  Future<void> _initializeOnlineService() async {
    try {
      // Lấy thông tin user hiện tại
      final userData = await TokenStorage.getUserData();
      if (userData == null || !mounted) return;

      final userId = userData['id']?.toString() ?? '';
      final username = userData['username']?.toString() ?? 
                      userData['fullName']?.toString() ?? 'User';

      if (userId.isEmpty) return;

      // Khởi tạo service
      final socketClient = SocketClient();
      _onlineService = FriendOnlineService(socketClient);
      
      // Kết nối và lắng nghe
      _onlineService!.connect(userId, username);
      
      // Lắng nghe stream số lượng online
      _onlineCountSubscription = _onlineService!.onlineCountStream.listen(
        (count) {
          if (mounted) {
            setState(() {
              _onlineCount = count;
              _isLoading = false;
            });
          }
        },
        onError: (error) {
          developer.log(
            'Error in online count stream: $error',
            name: 'FriendHeaderChips',
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      );

      // Set timeout để hiển thị loading nếu không nhận được data
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _isLoading) {
          setState(() {
            _isLoading = false;
          });
        }
      });
    } catch (e) {
      developer.log(
        'Error initializing online service: $e',
        name: 'FriendHeaderChips',
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _onlineCountSubscription?.cancel();
    _onlineService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildChip(
          label: _isLoading
              ? 'Đang tải...'
              : '$_onlineCount người đang online',
          leading: _buildOnlineDot(),
          onTap: () {
            // Refresh số lượng online
            _onlineService?.refreshOnlineCount();
          },
        ),
        SizedBox(width: 8.w),
        _buildChip(
          label: 'Bạn bè',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FriendsListPage(),
              ),
            );
            // Gọi callback để reload dữ liệu
            widget.onNeedRefresh?.call();
          },
        ),
        SizedBox(width: 8.w),
        _buildChip(
          label: 'Gợi ý',
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const FriendSuggestionsPage(),
              ),
            );
            // Gọi callback để reload dữ liệu
            widget.onNeedRefresh?.call();
          },
        ),
      ],
    );
  }

  Widget _buildOnlineDot() {
    return Container(
      width: 8.r,
      height: 8.r,
      decoration: const BoxDecoration(
        color: Color(0xFF2CD45C),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildChip({
    required String label,
    Widget? leading,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) ...[
              leading,
              SizedBox(width: 6.w),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}



