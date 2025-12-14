import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:video_player/video_player.dart';

class StoryEditorPage extends StatefulWidget {
  final AssetEntity asset;

  const StoryEditorPage({
    super.key,
    required this.asset,
  });

  @override
  State<StoryEditorPage> createState() => _StoryEditorPageState();
}

class _StoryEditorPageState extends State<StoryEditorPage> {
  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _isPrivacyOff = false;

  @override
  void initState() {
    super.initState();
    _initializeMedia();
  }

  Future<void> _initializeMedia() async {
    if (widget.asset.type == AssetType.video) {
      final file = await widget.asset.file;
      if (file != null && mounted) {
        _videoController = VideoPlayerController.file(file);
        await _videoController!.initialize();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
          setState(() {
            _isVideoPlaying = true;
          });
        }
      }
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isVideo = widget.asset.type == AssetType.video;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content - Image/Video
            Center(
              child: _buildMediaContent(isVideo),
            ),
            // Top bar - Close button
            Positioned(
              top: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
            ),
            // Right side menu - Editing tools
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: _buildRightMenu(),
            ),
            // Bottom bar
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildBottomBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(bool isVideo) {
    if (isVideo) {
      if (_isVideoInitialized && _videoController != null) {
        return GestureDetector(
          onTap: () {
            if (_videoController!.value.isPlaying) {
              _videoController!.pause();
            } else {
              _videoController!.play();
            }
            setState(() {
              _isVideoPlaying = _videoController!.value.isPlaying;
            });
          },
          child: Center(
            child: AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
            ),
          ),
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(color: Colors.white),
        );
      }
    } else {
      return FutureBuilder<File?>(
        future: widget.asset.file,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Center(
              child: Image.file(
                snapshot.data!,
                fit: BoxFit.contain,
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        },
      );
    }
  }

  Widget _buildRightMenu() {
    return Container(
      width: 80.w,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMenuButton(
            icon: Icons.sticky_note_2_outlined,
            label: "Nhãn dán",
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          _buildMenuButton(
            icon: Icons.text_fields,
            label: "Văn bản",
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          _buildMenuButton(
            icon: Icons.music_note,
            label: "Nhạc",
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          _buildMenuButton(
            icon: Icons.auto_awesome,
            label: "Hiệu ứng",
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          _buildMenuButton(
            icon: Icons.brush,
            label: "Vẽ",
            onTap: () {},
          ),
          SizedBox(height: 20.h),
          _buildMenuButton(
            icon: Icons.alternate_email,
            label: "Gắn thẻ\nngười khác",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bottom buttons row
          Row(
            children: [
              // Settings button
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const StoryPrivacySettingsPage(),
                    ),
                  );
                },
              ),
              SizedBox(width: 8.w),
              const Spacer(),
              // Share button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement share functionality
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Chia sẻ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
