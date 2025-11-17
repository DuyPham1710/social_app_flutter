import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_viewer_page.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';

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

  @override
  void initState() {
    super.initState();
    _currentPage = widget.page;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    context.read<HomeStoriesBloc>().add(
      LoadHomeStoriesEvent(page: _currentPage, limit: widget.limit),
    );
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
          return SizedBox(
            height: 200.w,
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          );
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
              height: 200.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                child: Row(children: [_buildAddStory()]),
              ),
            );
          }

          // Lấy story đầu tiên từ danh sách đã lọc
          final stories = groupsWithStories
              .map((group) => group.stories.first)
              .toList();
          return SizedBox(
            height: 200.w,
            child: ListView.separated(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildAddStory();
                }
                final story = stories[index - 1];
                final groupIndex = index - 1;
                return _buildStoryCard(story, groupIndex, groupsWithStories);
              },
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemCount: stories.length + 1,
            ),
          );
        }
        if (state is HomeStoriesError) {
          return SizedBox(
            height: 200.w,
            child: Center(child: Text(state.message)),
          );
        }
        return SizedBox(height: 200.w);
      },
    );
  }

  Widget _buildAddStory() {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 80.w,
              height: 120.w,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.textSecondary, width: 1),
              ),
            ),
            Positioned(
              bottom: -18.h,
              child: CircleAvatar(
                radius: 20.r,
                backgroundColor: AppColors.primary,
                child: Icon(Icons.add, size: 24.sp, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Text(
          "Add Story",
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
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
                width: 80.w,
                height: 120.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: story.mediaUrl != null
                      ? DecorationImage(
                          image: NetworkImage(story.mediaUrl!),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color: story.mediaUrl == null ? Colors.grey[300] : null,
                ),
              ),

              // Badge LIVE
              // Positioned(
              //   top: 8,
              //   right: 8,
              //   child: story.isLive
              //       ? Container(
              //           padding: EdgeInsets.symmetric(
              //             horizontal: 6.w,
              //             vertical: 2.h,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.black87,
              //             borderRadius: BorderRadius.circular(6.r),
              //           ),
              //           child: Text(
              //             "LIVE",
              //             style: TextStyle(
              //               color: Colors.white,
              //               fontSize: 10.sp,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         )
              //       : const SizedBox(),
              // ),

              // Avatar dưới chính giữa
              Positioned(
                bottom: -18.h,
                child: CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white,
                  child: CircleAvatar(
                    radius: 16.r,
                    backgroundImage: NetworkImage(story.user.avatarUrl ?? ""),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          Text(
            story.user.fullName ?? "Unknown",
            style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
