import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_viewer_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_create_page.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/stories_loading_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

import '../bloc/home_stories_bloc.dart';

class HomeStoriesWidget extends StatefulWidget {
  final int page;
  final int limit;
  const HomeStoriesWidget({super.key, this.page = 1, this.limit = 10});

  @override
  State<HomeStoriesWidget> createState() => _HomeStoriesWidgetState();
}

class _HomeStoriesWidgetState extends State<HomeStoriesWidget>
    with AutomaticKeepAliveClientMixin {
  late ScrollController _scrollController;
  int _currentPage = 1;
  bool _isLoadingMore = false;
  String? _currentUserId;
  String? _currentUserAvatar;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadCurrentUserId();
    context.read<HomeStoriesBloc>().add(
      LoadHomeStoriesEvent(page: _currentPage, limit: widget.limit),
    );
  }

  Future<void> _loadCurrentUserId() async {
    final userData = await TokenStorage.getUserData();
    if (userData != null && mounted) {
      setState(() {
        _currentUserId = userData['id'];
        _currentUserAvatar = userData['avatarUrl'] as String?;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final bloc = context.read<HomeStoriesBloc>();
      final state = bloc.state;
      if (state is HomeStoriesLoaded &&
          state.groupedStories.hasNext &&
          !_isLoadingMore) {
        _isLoadingMore = true;
        _currentPage++;
        bloc.add(LoadHomeStoriesEvent(page: _currentPage, limit: widget.limit));
        // Đợi bloc load xong mới cho phép load tiếp
        Future.delayed(const Duration(milliseconds: 500), () {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocBuilder<HomeStoriesBloc, HomeStoriesState>(
      builder: (context, state) {
        if (state is HomeStoriesLoading) {
          return const StoriesLoadingWidget();
        }
        if (state is HomeStoriesLoaded) {
          final groupedStories = state.groupedStories;
          // Lấy danh sách story đầu tiên của mỗi user
          final groupsWithStories = groupedStories.users
              .where((group) => group.stories.isNotEmpty)
              .toList();

          // Nếu không có user nào có story, chỉ hiển thị nút Add Story
          if (groupsWithStories.isEmpty) {
            return SizedBox(
              height: 200.rs(context),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.rs(context),
                  vertical: 8.rsh(context),
                ),
                child: Row(children: [_buildAddStory()]),
              ),
            );
          }

          // Lấy story đầu tiên từ danh sách đã lọc
          final stories = groupsWithStories
              .map((group) => group.stories.first)
              .toList();
          return SizedBox(
            height: 200.rs(context),
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                horizontal: 12.rs(context),
                vertical: 8.rsh(context),
              ),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddStory();
                }
                final story = stories[index - 1];
                final groupIndex = index - 1;
                return _buildStoryCard(story, groupIndex, groupsWithStories);
              },
              separatorBuilder: (_, __) => SizedBox(width: 12.rs(context)),
              itemCount: stories.length + 1,
            ),
          );
        }
        if (state is HomeStoriesError) {
          return SizedBox(
            height: 200.rs(context),
            child: Center(
              child: Text(
                state.message,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.rsp(context),
                ),
              ),
            ),
          );
        }
        return SizedBox(height: 200.rs(context));
      },
    );
  }

  Widget _buildAddStory() {
    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const StoryCreatePage()));
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 80.rs(context),
                height: 120.rs(context),
                decoration: BoxDecoration(
                  color: AppColors.secondBackground,
                  borderRadius: BorderRadius.circular(12.rsr(context)),
                  border: Border.all(color: AppColors.divider, width: 1),
                  image:
                      _currentUserAvatar != null &&
                          _currentUserAvatar!.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(_currentUserAvatar!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
              ),
              Positioned(
                bottom: -18.rsh(context),
                child: CircleAvatar(
                  radius: 20.rsr(context),
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.add,
                    size: 24.rsp(context),
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 30.rsh(context)),
          Text(
            context.l10n.homeAddStory,
            style: TextStyle(
              fontSize: 12.rsp(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryCard(
    story,
    int groupIndex,
    List<GroupedUserStoryEntity> groups,
  ) {
    // story là StoryEntity
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                StoryViewerPage(
                  groups: groups,
                  initialGroupIndex: groupIndex,
                  initialStoryIndex: 0,
                ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(0.0, 1.0);
                  const end = Offset.zero;
                  const curve = Curves.easeOut;

                  final tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
            // Tùy chỉnh thời gian chuyển cảnh
            transitionDuration: Duration(
              milliseconds: int.parse(dotenv.env['TRANSITION_TIME']!),
            ),
          ),
        );
      },
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                width: 80.rs(context),
                height: 120.rs(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.rsr(context)),
                  image: story.mediaUrl != null
                      ? DecorationImage(
                          image: NetworkImage(story.mediaUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: story.mediaUrl == null
                      ? AppColors.secondBackground
                      : null,
                ),
              ),

              // Avatar dưới chính giữa
              Positioned(
                bottom: -18.rsh(context),
                child: CircleAvatar(
                  radius: 18.rsr(context),
                  backgroundColor: AppColors.background,
                  child: CircleAvatar(
                    radius: 16.rsr(context),
                    backgroundImage: NetworkImage(
                      story.user.avatarUrl ??
                          "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 30.rsh(context)),

          Text(
            (_currentUserId != null && story.user.userId == _currentUserId)
                ? "Tin của bạn"
                : (story.user.fullName ?? "Unknown"),
            style: TextStyle(
              fontSize: 12.rsp(context),
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
