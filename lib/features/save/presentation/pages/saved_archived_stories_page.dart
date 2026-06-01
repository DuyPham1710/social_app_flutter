import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/domain/usecases/get_my_archived_stories_usecase.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_viewer_page.dart';
import 'package:social_app_fe/features/story/presentation/widgets/video_thumbnail_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SavedArchivedStoriesPage extends StatelessWidget {
  const SavedArchivedStoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usecase = s1<GetMyArchivedStoriesUsecase>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.iconPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          context.l10n.storyArchivePageTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<DataState<GroupedStoryListEntity>>(
        future: usecase(page: 1, limit: 50),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final state = snapshot.data!;
          if (state is DataStateError) {
            return Center(
              child: Text(
                state.error.toString(),
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          final data =
              (state as DataStateSuccess<GroupedStoryListEntity>).data!;
          if (data.users.isEmpty || data.users.first.stories.isEmpty) {
            return Center(
              child: Text(
                context.l10n.storyNoArchivedStories,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }

          final group = data.users.first; // user hiện tại
          final stories = group.stories;

          return Padding(
            padding: EdgeInsets.all(12.w),
            child: MasonryGridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 10.w,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final story = stories[index];
                final mediaUrl = story.mediaUrl;

                Widget mediaChild;
                if (mediaUrl != null && mediaUrl.isNotEmpty) {
                  if (story.mediaType == MediaType.video) {
                    mediaChild = VideoThumbnailWidget(
                      videoUrl: mediaUrl,
                      width: double.infinity,
                      height: double.infinity,
                    );
                  } else {
                    mediaChild = Image.network(
                      mediaUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        final total = loadingProgress.expectedTotalBytes;
                        final loaded = loadingProgress.cumulativeBytesLoaded;
                        final value = total == null ? null : loaded / total;
                        return Center(
                          child: SizedBox(
                            width: 18.w,
                            height: 18.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: value,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _StoryMediaPlaceholder(
                          mediaType: story.mediaType,
                        );
                      },
                    );
                  }
                } else {
                  mediaChild = _StoryMediaPlaceholder(
                    mediaType: story.mediaType,
                  );
                }

                final overlayIcon = story.mediaType == MediaType.video
                    ? Icons.play_circle_fill_rounded
                    : story.mediaType == MediaType.text
                    ? Icons.text_fields_rounded
                    : null;

                return InkWell(
                  borderRadius: BorderRadius.circular(14.r),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryViewerPage(
                          groups: [group],
                          initialGroupIndex: 0,
                          initialStoryIndex: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.r),
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: ColoredBox(
                            color: AppColors.secondBackground,
                            child: mediaChild,
                          ),
                        ),
                        if (overlayIcon != null)
                          Positioned(
                            right: 8.w,
                            top: 8.w,
                            child: Container(
                              padding: EdgeInsets.all(6.w),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Icon(
                                overlayIcon,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                            ),
                          ),
                        Positioned(
                          left: 8.w,
                          right: 8.w,
                          bottom: 8.w,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Text(
                              (story.title == null ||
                                      story.title!.trim().isEmpty)
                                  ? context.l10n.storyDefaultName(
                                      (index + 1).toString(),
                                    )
                                  : story.title!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _StoryMediaPlaceholder extends StatelessWidget {
  final MediaType mediaType;
  const _StoryMediaPlaceholder({required this.mediaType});

  @override
  Widget build(BuildContext context) {
    final icon = mediaType == MediaType.video
        ? Icons.videocam_rounded
        : mediaType == MediaType.text
        ? Icons.text_fields_rounded
        : Icons.image_rounded;

    return Container(
      alignment: Alignment.center,
      color: AppColors.secondBackground,
      child: Icon(icon, size: 34.sp, color: AppColors.textSecondary),
    );
  }
}
