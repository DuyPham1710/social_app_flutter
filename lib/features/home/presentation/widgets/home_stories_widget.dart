import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class Story {
  final String name;
  final String imageUrl;
  final String avatarUrl;
  final bool isLive;

  Story({
    required this.name,
    required this.imageUrl,
    required this.avatarUrl,
    this.isLive = false,
  });
}

class HomeStoriesWidget extends StatelessWidget {
  const HomeStoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = [
      Story(name: "Add Story", imageUrl: "", avatarUrl: ""),
      Story(
        name: "Lam",
        imageUrl:
            "https://images.pexels.com/photos/432059/pexels-photo-432059.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg",
        isLive: true,
      ),
      Story(
        name: "Luân",
        imageUrl:
            "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
      ),
      Story(
        name: "Hiếu",
        imageUrl:
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      ),
      Story(
        name: "Hiếu",
        imageUrl:
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      ),
      Story(
        name: "Hiếu",
        imageUrl:
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      ),
      Story(
        name: "Hiếu",
        imageUrl:
            "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
        avatarUrl:
            "https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg",
      ),
    ];

    return SizedBox(
      height: 200.w,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final story = stories[index];
          if (index == 0) {
            return _buildAddStory();
          }
          return _buildStoryCard(story);
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemCount: stories.length,
      ),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.grey.shade400, width: 1),
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

  Widget _buildStoryCard(Story story) {
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
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: NetworkImage(story.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Badge LIVE
            Positioned(
              top: 8,
              right: 8,
              child: story.isLive
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        "LIVE",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : const SizedBox(),
            ),
            // Avatar dưới chính giữa
            Positioned(
              bottom: -18.h,
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundImage: NetworkImage(story.avatarUrl),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Text(
          story.name,
          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
