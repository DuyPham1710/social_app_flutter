import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
  final AssetEntity? asset;
  final Uint8List? webFileBytes;
  final String? webFileName;
  final bool isVideo;

  const StoryEditorPage({
    super.key,
    this.asset,
    this.webFileBytes,
    this.webFileName,
    this.isVideo = false,
  }) : assert(asset != null || webFileBytes != null);

  @override
  State<StoryEditorPage> createState() => _StoryEditorPageState();
}

class _StoryEditorPageState extends State<StoryEditorPage> {
  static const _privacyPublic = 'public';
  static const _privacyFriends = 'friends';
  static const _privacyFriendsDetail = 'friendsDetail';

  VideoPlayerController? _videoController;
  bool _isVideoInitialized = false;

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
    final isVideo = widget.isVideo || widget.asset?.type == AssetType.video;
    if (isVideo && widget.asset != null) {
      final file = await widget.asset!.file;
      if (file != null && mounted) {
        _videoController = VideoPlayerController.file(file);
        await _videoController!.initialize();
        if (mounted) {
          setState(() {
            _isVideoInitialized = true;
          });
          _videoController!.setLooping(true);
          _videoController!.play();
        }
      }
    } else if (isVideo && widget.webFileBytes != null && kIsWeb) {
      // Dùng XFile từ cross_file để tạo blob URL trên Web
      final xfile = XFile.fromData(
        widget.webFileBytes!,
        name: widget.webFileName ?? 'video.mp4',
      );
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(xfile.path),
      );
      await _videoController!.initialize();
      if (mounted) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController!.setLooping(true);
        _videoController!.play();
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
    final isVideo = widget.isVideo || widget.asset?.type == AssetType.video;
    return Container(
      color: Colors.black,

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 450),
          child: Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: BlocListener<StoryCreateBloc, StoryCreateState>(
                listener: (context, state) {
                  if (state is StoryCreated) {
                    showSuccessSnackBar(
                      context,
                      context.l10n.storyCreateSuccess,
                    );
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
                        padding: EdgeInsets.all(12.rs(context)),
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
            ),
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
            setState(() {});
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

      if (widget.webFileBytes != null) {
        return Center(
          child: Image.memory(widget.webFileBytes!, fit: BoxFit.contain),
        );
      }

      if (widget.asset != null) {
        return FutureBuilder<File?>(
          future: widget.asset!.file,
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

      return const SizedBox.shrink();
    }
  }

  Widget _buildRightMenu() {
    final isVideo = widget.isVideo || widget.asset?.type == AssetType.video;

    return Container(
      width: 80.rs(context),
      padding: EdgeInsets.symmetric(vertical: 20.rsh(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildMenuButton(
            icon: Icons.sticky_note_2_outlined,
            label: context.l10n.commonEdit,
            onTap: () => _openImageEditor(),
          ),
          SizedBox(height: 20.rsh(context)),
          // Chỉ hiển thị option Nhạc nếu không phải video
          if (!isVideo) ...[
            SizedBox(height: 20.rsh(context)),
            _buildMusicButton(),
          ],
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
            width: 50.rs(context),
            height: 50.rs(context),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
              border: _selectedMusic != null
                  ? Border.all(color: AppColors.primary, width: 2)
                  : null,
            ),
            child: _selectedMusic != null
                ? ClipOval(
                    child: Image.network(
                      kIsWeb
                          ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(_selectedMusic!.album.cover)}'
                          : _selectedMusic!.album.cover,
                      width: 50.rs(context),
                      height: 50.rs(context),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24.rsp(context),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 24.rsp(context),
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.music_note,
                    color: Colors.white,
                    size: 24.rsp(context),
                  ),
          ),
          SizedBox(height: 4.rsh(context)),
          Text(
            context.l10n.storyMusic,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.rsp(context),
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
            width: 50.rs(context),
            height: 50.rs(context),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24.rsp(context)),
          ),
          SizedBox(height: 4.rsh(context)),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.rsp(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.rs(context),
        vertical: 12.rsh(context),
      ),
      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3)),
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
              SizedBox(width: 8.rs(context)),
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
                        horizontal: 24.rs(context),
                        vertical: 12.rsh(context),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.rsr(context)),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            width: 20.rs(context),
                            height: 20.rs(context),
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
                              fontSize: 15.rsp(context),
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
    final isVideo = widget.isVideo || widget.asset?.type == AssetType.video;
    if (isVideo) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.storyImageOnlyEdit)));
      return;
    }

    try {
      // Đọc dữ liệu byte từ ảnh
      Uint8List? imageBytes;
      if (_editedImageFile != null) {
        imageBytes = await _editedImageFile!.readAsBytes();
      } else if (widget.webFileBytes != null) {
        imageBytes = widget.webFileBytes;
      } else if (widget.asset != null) {
        final originalFile = await widget.asset!.file;
        if (originalFile != null) {
          imageBytes = await originalFile.readAsBytes();
        }
      }

      if (!mounted) return;
      if (imageBytes == null) {
        showErrorSnackBar(context, context.l10n.storyCannotReadDeviceFile);
        return;
      }

      // Mở trình chỉnh sửa ảnh
      final editedImage = await Navigator.push<Uint8List?>(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(image: imageBytes!),
        ),
      );

      // Nếu người dùng đã chỉnh sửa xong và quay lại
      if (editedImage != null) {
        if (kIsWeb) {
          if (!mounted) return;
          showErrorSnackBar(
            context,
            context.l10n.storyWebImageEditNotSupported,
          );
          return;
        }

        // Tạo tên file mới với timestamp để tránh cache
        final originalFile = await widget.asset?.file;
        if (originalFile != null) {
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
    Uint8List? fileBytes;
    String? fileName;

    if (_editedImageFile != null) {
      file = _editedImageFile;
    } else if (widget.webFileBytes != null) {
      fileBytes = widget.webFileBytes;
      fileName = widget.webFileName;
    } else if (widget.asset != null) {
      file = await widget.asset!.file;
    }

    if (!mounted) return;
    if (file == null && fileBytes == null) {
      showErrorSnackBar(context, context.l10n.storyCannotReadDeviceFile);
      return;
    }

    // Xác định loại media
    final isVideo = widget.isVideo || widget.asset?.type == AssetType.video;
    final mediaType = isVideo
        ? core_media.MediaType.video
        : core_media.MediaType.image;

    // Lấy cài đặt quyền riêng tư đã lưu
    final privacyLabel = await StoryPrivacyStorage.getPrivacy();
    final hiddenFriendIds = await StoryPrivacyStorage.getHiddenFriendIds();
    final allowedFriendIds = await StoryPrivacyStorage.getAllowedFriendIds();
    if (!mounted) return;

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
      fileBytes: fileBytes,
      fileName: fileName,
    );

    context.read<StoryCreateBloc>().add(
      CreateStoryRequested(story: storyEntity),
    );
  }
}
