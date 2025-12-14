import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/data/models/deezer_music_model.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_music_picker_page.dart';
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
  
  // Music state
  DeezerMusicModel? _selectedMusic;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initializeMedia();
    _setupAudioPlayer();
  }

  void _setupAudioPlayer() {
    _audioPlayer.onPlayerComplete.listen((_) {
      // Phát lại theo vòng lặp
      if (_selectedMusic != null && _selectedMusic!.preview.isNotEmpty) {
        _audioPlayer.play(UrlSource(_selectedMusic!.preview));
      }
    });
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
    _audioPlayer.dispose();
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
    final isVideo = widget.asset.type == AssetType.video;
    
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
          // Chỉ hiển thị option Nhạc nếu không phải video
          if (!isVideo) ...[
            SizedBox(height: 20.h),
            _buildMusicButton(),
          ],
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

  Widget _buildMusicButton() {
    return GestureDetector(
      onTap: () async {
        final selectedMusic = await Navigator.of(context).push<DeezerMusicModel>(
          MaterialPageRoute(
            builder: (_) => const StoryMusicPickerPage(),
          ),
        );

        if (selectedMusic != null) {
          setState(() {
            _selectedMusic = selectedMusic;
          });
          
          // Phát nhạc theo vòng lặp
          if (selectedMusic.preview.isNotEmpty) {
            await _audioPlayer.setReleaseMode(ReleaseMode.loop);
            await _audioPlayer.play(UrlSource(selectedMusic.preview));
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              shape: BoxShape.circle,
              border: _selectedMusic != null
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: _selectedMusic != null
                ? ClipOval(
                    child: Image.network(
                      _selectedMusic!.album.cover,
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.music_note, color: Colors.white, size: 24.sp);
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Icon(Icons.music_note, color: Colors.white, size: 24.sp);
                      },
                    ),
                  )
                : Icon(Icons.music_note, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            "Nhạc",
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
