import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/network/websocket/socket_client.dart';
import 'package:social_app_fe/features/friend/data/data_sources/friend_online_service.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friend_suggestions_page.dart';
import 'package:social_app_fe/features/friend/presentation/pages/friends_list_page.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendHeaderChips extends StatefulWidget {
  final VoidCallback? onNeedRefresh;

  const FriendHeaderChips({super.key, this.onNeedRefresh});

  @override
  State<FriendHeaderChips> createState() => _FriendHeaderChipsState();
}

class _FriendHeaderChipsState extends State<FriendHeaderChips> {
  FriendOnlineService? _onlineService;
  StreamSubscription<int>? _onlineCountSubscription;
  Timer? _refreshTimer;
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
      final username =
          userData['username']?.toString() ??
          userData['fullName']?.toString() ??
          'User';

      if (userId.isEmpty) return;

      // Khởi tạo service
      final socketClient = s1<SocketClient>(instanceName: 'friendSocket');
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

      // Khởi tạo timer để tự động refresh sau mỗi 10 giây
      _refreshTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
        if (mounted && _onlineService != null) {
          _onlineService!.refreshOnlineCount();
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
    _refreshTimer?.cancel();
    _onlineCountSubscription?.cancel();
    _onlineService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildChip(
            label: _isLoading
                ? context.l10n.commonLoading
                : context.l10n.friendOnlineCount(_onlineCount),
            leading: _buildOnlineDot(),
          ),
          SizedBox(width: 8.rs(context)),
          _buildChip(
            label: context.l10n.friendTitle,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FriendsListPage()),
              );
              // Gọi callback để reload dữ liệu
              widget.onNeedRefresh?.call();
            },
          ),
          SizedBox(width: 8.rs(context)),
          _buildChip(
            label: context.l10n.friendSuggestionsTitle,
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
      ),
    );
  }

  Widget _buildOnlineDot() {
    return Container(
      width: 8.rsr(context),
      height: 8.rsr(context),
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
        padding: EdgeInsets.symmetric(
          horizontal: 12.rs(context),
          vertical: 8.rsh(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20.rsr(context)),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              blurRadius: 6.rsr(context),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (leading != null) ...[leading, SizedBox(width: 6.rs(context))],
            Text(
              label,
              style: TextStyle(
                fontSize: 12.rsp(context),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
