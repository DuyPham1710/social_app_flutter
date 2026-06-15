import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/friend/presentation/widgets/friend_suggestion_item.dart';
import 'package:social_app_fe/features/friend/presentation/utils/friend_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class FriendSuggestionsPage extends StatefulWidget {
  const FriendSuggestionsPage({super.key});

  @override
  State<FriendSuggestionsPage> createState() => _FriendSuggestionsPageState();
}

class _FriendSuggestionsPageState extends State<FriendSuggestionsPage> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    // Load tất cả gợi ý kết bạn khi khởi tạo
    context.read<FriendBloc>().add(const LoadFriendPage());
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels < position.maxScrollExtent - 200) return;

    final bloc = context.read<FriendBloc>();
    final currentState = bloc.state;

    bool hasMore = true;
    bool isLoadingMore = false;
    int nextPage = 1;

    if (currentState is FriendPageLoaded) {
      hasMore = currentState.hasMoreSuggestions;
      isLoadingMore = currentState.isLoadingMoreSuggestions;
      nextPage = currentState.suggestionPage + 1;
    } else if (currentState is FriendSuggestionsLoaded) {
      hasMore = currentState.hasMoreSuggestions;
      isLoadingMore = currentState.isLoadingMore;
      nextPage = currentState.suggestionPage + 1;
    } else {
      return;
    }

    if (!hasMore || isLoadingMore) return;

    bloc.add(LoadFriendSuggestions(page: nextPage, limit: 10, append: true));
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
              surfaceTintColor: Colors.transparent,
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
              ),
              title: Text(
                context.l10n.friendSuggestionsTitle,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  icon: Icon(
                    CupertinoIcons.search,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header section
                  _buildHeaderSection(),

                  // Danh sách gợi ý bạn bè
                  Expanded(child: _buildFriendSuggestionsList()),
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
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 12.rsh(context),
          ),
          child: Text(
            context.l10n.friendPeopleYouMayKnow,
            style: TextStyle(
              fontSize: 16.rsp(context),
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        );
      },
    );
  }

  Widget _buildFriendSuggestionsList() {
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
        builder: (context, state) {
          if (state is FriendSuggestionsLoading ||
              (state is FriendPageLoaded && state.isLoadingSuggestions)) {
            return _buildLoadingState();
          } else if (state is FriendSuggestionsLoaded ||
              state is FriendPageLoaded) {
            final friendSuggestions = state is FriendSuggestionsLoaded
                ? state.friendSuggestions
                : (state as FriendPageLoaded).friendSuggestions;
            final sentRequestUserIds = state is FriendSuggestionsLoaded
                ? state.sentRequestUserIds
                : (state as FriendPageLoaded).sentRequestUserIds;

            if (friendSuggestions.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              backgroundColor: AppColors.background,
              color: AppColors.primary,
              onRefresh: () async {
                context.read<FriendBloc>().add(const LoadFriendPage());
                await Future.delayed(const Duration(seconds: 1));
              },
              child: ListView.separated(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: 16.rs(context),
                  vertical: 8.rsh(context),
                ),
                itemCount:
                    friendSuggestions.length + (_isLoadingMore(state) ? 1 : 0),
                separatorBuilder: (context, index) =>
                    SizedBox(height: 8.rsh(context)),
                itemBuilder: (context, index) {
                  if (_isLoadingMore(state) &&
                      index == friendSuggestions.length) {
                    return _buildLoadMoreIndicator();
                  }
                  final suggestion = friendSuggestions[index];
                  return _buildFriendSuggestionCard(
                    suggestion,
                    sentRequestUserIds,
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
            context.l10n.friendLoadingSuggestions,
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
                foregroundColor: Colors.white,
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

  Widget _buildFriendSuggestionCard(
    dynamic suggestion,
    Set<String> sentRequestUserIds,
  ) {
    final isSent = sentRequestUserIds.contains(suggestion.userId);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.rsr(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12.rsr(context),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FriendSuggestionItem(
        userId: suggestion.userId,
        name: suggestion.fullName ?? context.l10n.commonUser,
        mutualFriends: suggestion.mutualFriends ?? 0,
        avatarUrl:
            suggestion.avatarUrl ??
            'https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg',
        mutualFriendAvatars: suggestion.mutualFriendAvatars,
        isSent: isSent,
        onAddFriend: () {
          context.read<FriendBloc>().add(
            SendFriendRequest(receiverId: suggestion.userId),
          );
        },
        onRemove: () {
          context.read<FriendBloc>().add(
            RemoveFriendSuggestion(userId: suggestion.userId),
          );
        },
      ),
    );
  }

  bool _isLoadingMore(FriendState state) {
    if (state is FriendPageLoaded) return state.isLoadingMoreSuggestions;
    if (state is FriendSuggestionsLoaded) return state.isLoadingMore;
    return false;
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.rsh(context)),
      child: Center(
        child: SizedBox(
          width: 28.rs(context),
          height: 28.rs(context),
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return RefreshIndicator(
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
                    context.l10n.friendNoSuggestions,
                    style: TextStyle(
                      fontSize: 18.rsp(context),
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 12.rsh(context)),
                  Text(
                    context.l10n.friendNoSuggestionsDescription,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.rsp(context),
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 32.rsh(context)),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<FriendBloc>().add(const LoadFriendPage());
                    },
                    icon: Icon(Icons.refresh, size: 18.rsr(context)),
                    label: Text(context.l10n.commonRefresh),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
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
          ),
        ),
      ),
    );
  }
}
