import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_request_item.dart';
import 'package:social_app_fe/features/friend/presentation/pages/sent_friend_requests_page.dart';
import 'package:social_app_fe/features/friend/presentation/utils/friend_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  final GlobalKey _moreMenuKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Load tất cả lời mời kết bạn khi khởi tạo
    context.read<FriendBloc>().add(const LoadFriendPage());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
              ),
              title: Text(
                context.l10n.friendRequestsTitle,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  key: _moreMenuKey,
                  onPressed: () {
                    _showMoreOptions(context);
                  },
                  icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Header section với số lượng lời mời
                  _buildHeaderSection(),

                  // Danh sách lời mời kết bạn
                  Expanded(child: _buildFriendRequestsList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return BlocBuilder<FriendBloc, FriendState>(
      buildWhen: (previous, current) {
        // Chỉ rebuild khi state liên quan đến friend requests thay đổi
        return current is FriendRequestsLoaded || current is FriendPageLoaded;
      },
      builder: (context, state) {
        int requestCount = 0;

        if (state is FriendRequestsLoaded) {
          requestCount = state.friendRequests.length;
        } else if (state is FriendPageLoaded) {
          requestCount = state.friendRequests.length;
        }

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 12.rsh(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    context.l10n.friendRequestsTitle,
                    style: TextStyle(
                      fontSize: 16.rsp(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 8.rs(context)),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.rs(context),
                      vertical: 2.rsh(context),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                    ),
                    child: Text(
                      '$requestCount',
                      style: TextStyle(
                        fontSize: 12.rsp(context),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  _showSortOptions(context);
                },
                child: Text(
                  context.l10n.friendSort,
                  style: TextStyle(
                    fontSize: 14.rsp(context),
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFriendRequestsList() {
    return BlocListener<FriendBloc, FriendState>(
      listener: (context, state) {
        if (state is FriendActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      localizedFriendActionMessage(context.l10n, state.message),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.rsr(context)),
              ),
            ),
          );
        } else if (state is FriendActionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      localizedFriendActionMessage(context.l10n, state.message),
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.rsr(context)),
              ),
              action: SnackBarAction(
                label: context.l10n.commonRetry,
                textColor: Colors.white,
                onPressed: () {
                  context.read<FriendBloc>().add(const LoadFriendPage());
                },
              ),
            ),
          );
        }
      },
      child: BlocBuilder<FriendBloc, FriendState>(
        buildWhen: (previous, current) {
          // Chỉ rebuild khi state liên quan đến friend requests (received) thay đổi
          return current is FriendRequestsLoading ||
              current is FriendRequestsLoaded ||
              current is FriendPageLoaded ||
              (current is FriendError && previous is FriendRequestsLoading);
        },
        builder: (context, state) {
          if (state is FriendRequestsLoading ||
              (state is FriendPageLoaded && state.isLoadingRequests)) {
            return _buildLoadingState();
          } else if (state is FriendRequestsLoaded ||
              state is FriendPageLoaded) {
            final friendRequests = state is FriendRequestsLoaded
                ? state.friendRequests
                : (state as FriendPageLoaded).friendRequests;
            final acceptedRequestIds = state is FriendRequestsLoaded
                ? state.acceptedRequestIds
                : (state as FriendPageLoaded).acceptedRequestIds;
            final rejectedRequestIds = state is FriendRequestsLoaded
                ? state.rejectedRequestIds
                : (state as FriendPageLoaded).rejectedRequestIds;

            if (friendRequests.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              backgroundColor: AppColors.background,
              color: AppColors.primary,
              onRefresh: () async {
                context.read<FriendBloc>().add(const LoadFriendPage());
                await Future.delayed(
                  const Duration(seconds: 1),
                ); // Đảm bảo refresh indicator hiển thị
              },
              child: ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.rs(context),
                  vertical: 8.rsh(context),
                ),
                itemCount: friendRequests.length,
                separatorBuilder: (context, index) =>
                    SizedBox(height: 12.rsh(context)),
                itemBuilder: (context, index) {
                  final request = friendRequests[index];
                  return _buildFriendRequestCard(
                    request,
                    acceptedRequestIds,
                    rejectedRequestIds,
                  );
                },
              ),
            );
          } else if (state is FriendError) {
            return _buildErrorState(state.message);
          }

          return _buildLoadingState();
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40.rs(context),
            height: 40.rs(context),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          SizedBox(height: 16.rsh(context)),
          Text(
            context.l10n.friendLoadingRequests,
            style: TextStyle(
              fontSize: 14.rsp(context),
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.rs(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.rsr(context),
              color: Colors.red[300],
            ),
            SizedBox(height: 16.rsh(context)),
            Text(
              context.l10n.commonErrorOccurred,
              style: TextStyle(
                fontSize: 18.rsp(context),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.rsh(context)),
            Text(
              localizedFriendActionMessage(context.l10n, message),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.rsp(context),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 24.rsh(context)),
            ElevatedButton.icon(
              onPressed: () {
                context.read<FriendBloc>().add(const LoadFriendPage());
              },
              icon: Icon(Icons.refresh, size: 18.rsr(context)),
              label: Text(context.l10n.commonRetry),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.background,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.rs(context),
                  vertical: 12.rsh(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.rsr(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestCard(
    dynamic request,
    Set<String> acceptedRequestIds,
    Set<String> rejectedRequestIds,
  ) {
    final isAccepted = acceptedRequestIds.contains(request.requestId);
    final isRejected = rejectedRequestIds.contains(request.requestId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.rsr(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.rsr(context),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FriendRequestItem(
        userId: request.senderId,
        name: request.displayName,
        mutualFriends: request.displayMutualFriends,
        timeAgo: localizedFriendTimeAgo(context.l10n, request.createdAt),
        avatarUrl: request.displayAvatarUrl,
        mutualFriendAvatars: request.mutualFriendAvatars,
        isAccepted: isAccepted,
        isRejected: isRejected,
        onAccept: () {
          context.read<FriendBloc>().add(
            AcceptFriendRequest(requestId: request.requestId),
          );
        },
        onReject: () {
          context.read<FriendBloc>().add(
            RejectFriendRequest(requestId: request.requestId),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
      backgroundColor: AppColors.background,
      color: AppColors.primary,
      onRefresh: () async {
        context.read<FriendBloc>().add(const LoadFriendPage());
        await Future.delayed(const Duration(seconds: 1));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.rs(context)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120.rs(context),
                    height: 120.rs(context),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.person_2,
                      size: 64.rsr(context),
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 24.rsh(context)),
                  Text(
                    context.l10n.friendNoRequests,
                    style: TextStyle(
                      fontSize: 18.rsp(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.rsh(context)),
                  Text(
                    context.l10n.friendNoRequestsDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.rsp(context),
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Hiển thị dialog sắp xếp
  void _showSortOptions(BuildContext context) {
    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.background,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.rsr(context)),
          ),
          title: Center(
            child: Text(
              context.l10n.friendSortBy,
              style: TextStyle(
                fontSize: 18.rsp(context),
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          content: SizedBox(
            width: 320.rs(context),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSortOption(
                  context.l10n.friendSortNewest,
                  'time',
                  false,
                  dialogContext,
                ),
                _buildSortOption(
                  context.l10n.friendSortOldest,
                  'time',
                  true,
                  dialogContext,
                ),
                _buildSortOption(
                  context.l10n.friendSortNameAz,
                  'name',
                  true,
                  dialogContext,
                ),
                _buildSortOption(
                  context.l10n.friendSortNameZa,
                  'name',
                  false,
                  dialogContext,
                ),
                _buildSortOption(
                  context.l10n.friendSortMostMutual,
                  'mutualFriends',
                  false,
                  dialogContext,
                ),
                _buildSortOption(
                  context.l10n.friendSortLeastMutual,
                  'mutualFriends',
                  true,
                  dialogContext,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.rsr(context)),
              topRight: Radius.circular(20.rsr(context)),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.rs(context),
                height: 4.rsh(context),
                margin: EdgeInsets.symmetric(vertical: 12.rsh(context)),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.rsr(context)),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                child: Text(
                  context.l10n.friendSortBy,
                  style: TextStyle(
                    fontSize: 18.rsp(context),
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 16.rsh(context)),
              _buildSortOption(
                context.l10n.friendSortNewest,
                'time',
                false,
                context,
              ),
              _buildSortOption(
                context.l10n.friendSortOldest,
                'time',
                true,
                context,
              ),
              _buildSortOption(
                context.l10n.friendSortNameAz,
                'name',
                true,
                context,
              ),
              _buildSortOption(
                context.l10n.friendSortNameZa,
                'name',
                false,
                context,
              ),
              _buildSortOption(
                context.l10n.friendSortMostMutual,
                'mutualFriends',
                false,
                context,
              ),
              _buildSortOption(
                context.l10n.friendSortLeastMutual,
                'mutualFriends',
                true,
                context,
              ),
              SizedBox(height: 16.rsh(context)),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildSortOption(
    String title,
    String sortBy,
    bool ascending,
    BuildContext popContext,
  ) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        bool isSelected = false;
        if (state is FriendRequestsLoaded) {
          isSelected = state.sortBy == sortBy && state.ascending == ascending;
        } else if (state is FriendPageLoaded) {
          isSelected = state.sortBy == sortBy && state.ascending == ascending;
        }

        return ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 16.rsp(context),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? AppColors.primary : AppColors.textPrimary,
            ),
          ),
          trailing: isSelected
              ? Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 20.rsr(context),
                )
              : null,
          onTap: () {
            context.read<FriendBloc>().add(
              SortFriendRequests(sortBy: sortBy, ascending: ascending),
            );
            Navigator.pop(popContext);
          },
        );
      },
    );
  }

  /// Hiển thị bottom modal với các tùy chọn hoặc popup menu trên web
  void _showMoreOptions(BuildContext context) async {
    if (ResponsiveHelper.isWebOrDesktop) {
      final renderBox =
          _moreMenuKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final overlay =
            Navigator.of(context).overlay!.context.findRenderObject()
                as RenderBox;
        final position = RelativeRect.fromRect(
          Rect.fromPoints(
            renderBox.localToGlobal(Offset.zero, ancestor: overlay),
            renderBox.localToGlobal(
              renderBox.size.bottomRight(Offset.zero),
              ancestor: overlay,
            ),
          ),
          Offset.zero & overlay.size,
        );

        final friendBloc = context.read<FriendBloc>();
        final value = await showMenu<String>(
          context: context,
          position: position,
          color: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.rsr(context)),
          ),
          items: [
            PopupMenuItem(
              value: 'sent_requests',
              child: Row(
                children: [
                  Icon(
                    Icons.send_outlined,
                    color: AppColors.textPrimary,
                    size: 18.rsr(context),
                  ),
                  SizedBox(width: 8.rs(context)),
                  Text(
                    context.l10n.friendViewSentRequests,
                    style: TextStyle(
                      fontSize: 14.rsp(context),
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

        if (!context.mounted) return;

        if (value == 'sent_requests') {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SentFriendRequestsPage(),
            ),
          );
          // Reload lại friend requests khi quay về
          if (result == true && mounted) {
            friendBloc.add(const LoadFriendPage());
          }
        }
        return;
      }
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.rsr(context)),
            topRight: Radius.circular(20.rsr(context)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40.rs(context),
              height: 4.rsh(context),
              margin: EdgeInsets.symmetric(vertical: 12.rsh(context)),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.rsr(context)),
              ),
            ),

            // Option: Xem lời mời đã gửi
            ListTile(
              leading: Icon(
                Icons.send_outlined,
                color: AppColors.textPrimary,
                size: 24.rsr(context),
              ),
              title: Text(
                context.l10n.friendViewSentRequests,
                style: TextStyle(
                  fontSize: 16.rsp(context),
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              onTap: () async {
                final friendBloc = context.read<FriendBloc>();
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SentFriendRequestsPage(),
                  ),
                );
                // Reload lại friend requests khi quay về
                if (result == true && mounted) {
                  friendBloc.add(const LoadFriendPage());
                }
              },
            ),

            SizedBox(height: 16.rsh(context)),
          ],
        ),
      ),
    );
  }
}
