import 'dart:io';
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/media_type.dart' as core_media;
import 'package:social_app_fe/core/enums/privacy_type.dart' as core_privacy;
import 'package:social_app_fe/core/local/story_privacy_storage.dart';
import 'package:social_app_fe/features/story/data/models/deezer_music_model.dart';
import 'package:social_app_fe/features/story/domain/entities/create_story_entity.dart';
import 'package:social_app_fe/features/story/presentation/bloc/story_create_bloc.dart';
import 'package:social_app_fe/features/story/presentation/bloc/story_create_event.dart';
import 'package:social_app_fe/features/story/presentation/bloc/story_create_state.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_music_picker_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:video_player/video_player.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class StoryEditorPage extends StatefulWidget {
  final AssetEntity asset;

  const StoryEditorPage({super.key, required this.asset});

  @override
  State<StoryEditorPage> createState() => _StoryEditorPageState();
}

class _StoryEditorPageState extends State<StoryEditorPage> {
  static const _privacyPublic = 'public';
  static const _privacyFriends = 'friends';
  static const _privacyFriendsDetail = 'friendsDetail';

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;
  bool _isVideoPlaying = false;
  bool _isPrivacyOff = false;

  // Music state
  DeezerMusicModel? _selectedMusic;
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Edited image file
  File? _editedImageFile;

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
        child: BlocListener<StoryCreateBloc, StoryCreateState>(
          listener: (context, state) {
            if (state is StoryCreated) {
              showSuccessSnackBar(context, context.l10n.storyCreateSuccess);
              Navigator.of(context).maybePop();
            } else if (state is StoryCreateError) {
              showErrorSnackBar(context, state.message);
            }
          },
          child: Stack(
            children: [
              // Main content - Image/Video
              Center(child: _buildMediaContent(isVideo)),
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
              Positioned(right: 0, top: 0, bottom: 0, child: _buildRightMenu()),
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
      // Nếu có file đã chỉnh sửa, hiển thị nó
      if (_editedImageFile != null) {
        return Center(
          child: Image.file(_editedImageFile!, fit: BoxFit.contain),
        );
      }

      return FutureBuilder<File?>(
        future: widget.asset.file,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data != null) {
            return Center(
              child: Image.file(snapshot.data!, fit: BoxFit.contain),
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
            label: context.l10n.commonEdit,
            onTap: () => _openImageEditor(),
          ),
          SizedBox(height: 20.h),
          // Chỉ hiển thị option Nhạc nếu không phải video
          if (!isVideo) ...[SizedBox(height: 20.h), _buildMusicButton()],
        ],
      ),
    );
  }

  Widget _buildMusicButton() {
    return GestureDetector(
      onTap: () async {
        final selectedMusic = await Navigator.of(context)
            .push<DeezerMusicModel>(
              MaterialPageRoute(builder: (_) => const StoryMusicPickerPage()),
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
                        return Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24.sp,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24.sp,
                        );
                      },
                    ),
                  )
                : Icon(Icons.music_note, color: Colors.white, size: 24.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            context.l10n.storyMusic,
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
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
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
              BlocBuilder<StoryCreateBloc, StoryCreateState>(
                builder: (context, state) {
                  final isLoading = state is StoryCreating;
                  return ElevatedButton(
                    onPressed: isLoading ? null : _onSharePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.w,
                            height: 20.w,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(
                            context.l10n.postShare,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openImageEditor() async {
    // Chỉ cho phép chỉnh sửa ảnh, không phải video
    if (widget.asset.type == AssetType.video) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.storyImageOnlyEdit)));
      return;
    }

    try {
      // Lấy file gốc hoặc file đã chỉnh sửa
      final originalFile = _editedImageFile ?? await widget.asset.file;
      if (originalFile == null) {
        showErrorSnackBar(context, context.l10n.storyCannotReadDeviceFile);
        return;
      }

      // Đọc dữ liệu byte từ ảnh
      final imageBytes = await originalFile.readAsBytes();

      // Mở trình chỉnh sửa ảnh
      final editedImage = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(builder: (context) => ImageEditor(image: imageBytes)),
      );

      // Nếu người dùng đã chỉnh sửa xong và quay lại
      if (editedImage != null) {
        // Tạo tên file mới với timestamp để tránh cache
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final directory = originalFile.parent;
        final fileName = originalFile.path.split('/').last;
        final nameWithoutExt = fileName.split('.').first;
        final extension = fileName.split('.').last;
        final newPath =
            '${directory.path}/${nameWithoutExt}_edited_$timestamp.$extension';

        final newFile = File(newPath);

        // Ghi ảnh đã chỉnh sửa vào file mới
        await newFile.writeAsBytes(editedImage);

        // Clear image cache để force reload
        imageCache.clear();
        imageCache.clearLiveImages();

        setState(() {
          // Cập nhật với file mới
          _editedImageFile = newFile;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.storyImageEditFailed(e.toString())),
          ),
        );
      }
    }
  }

  Future<void> _onSharePressed() async {
    // Sử dụng file đã chỉnh sửa nếu có, không thì lấy file gốc từ AssetEntity
    File? file;
    if (_editedImageFile != null) {
      file = _editedImageFile;
    } else {
      file = await widget.asset.file;
    }

    if (file == null) {
      showErrorSnackBar(context, context.l10n.storyCannotReadDeviceFile);
      return;
    }

    // Xác định loại media
    final isVideo = widget.asset.type == AssetType.video;
    final mediaType = isVideo
        ? core_media.MediaType.video
        : core_media.MediaType.image;

    // Lấy cài đặt quyền riêng tư đã lưu
    final privacyLabel = await StoryPrivacyStorage.getPrivacy();
    final hiddenFriendIds = await StoryPrivacyStorage.getHiddenFriendIds();
    final allowedFriendIds = await StoryPrivacyStorage.getAllowedFriendIds();

    // Mặc định: bạn bè nếu chưa cấu hình
    core_privacy.PrivacyType privacyType = core_privacy.PrivacyType.friends;
    List<String>? friendsExcept;
    List<String>? friendsDetail;

    switch (privacyLabel) {
      case 'Công khai':
      case _privacyPublic:
        privacyType = core_privacy.PrivacyType.public;
      case 'Tùy chỉnh':
      case _privacyFriendsDetail:
        privacyType = core_privacy.PrivacyType.friendsDetail;
        friendsDetail = allowedFriendIds.isNotEmpty
            ? List.of(allowedFriendIds)
            : null;
      case 'Bạn bè':
      case _privacyFriends:
      default:
        if (hiddenFriendIds.isNotEmpty) {
          privacyType = core_privacy.PrivacyType.friendsExcept;
          friendsExcept = List.of(hiddenFriendIds);
        } else {
          privacyType = core_privacy.PrivacyType.friends;
        }
    }

    final storyEntity = CreateStoryEntity(
      title: null,
      mediaUrl: null,
      mediaType: mediaType,
      music: _selectedMusic,
      privacyType: privacyType,
      friendsExcept: friendsExcept,
      friendsDetail: friendsDetail,
      file: file,
    );

    context.read<StoryCreateBloc>().add(
      CreateStoryRequested(story: storyEntity),
    );
  }
}
