import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/enums/layout_type.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_state.dart';
import 'package:social_app_fe/features/post/domain/entities/create_post_entity.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_bloc.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_event.dart';
import 'package:social_app_fe/features/post/presentation/bloc/post_state.dart';
import 'package:social_app_fe/features/post/presentation/pages/camera_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/edit_selected_image_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/gallery_picker_screen.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/selected_images_display.dart';
import 'package:social_app_fe/shared/helpers/camera_helper.dart';
import 'package:social_app_fe/shared/helpers/privacy_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityCreatePostPage extends StatefulWidget {
  final String communityId;
  final String? userRole;
  final VoidCallback? onPostCreated;

  const CommunityCreatePostPage({
    super.key,
    required this.communityId,
    this.userRole,
    this.onPostCreated,
  });

  @override
  State<CommunityCreatePostPage> createState() =>
      _CommunityCreatePostPageState();
}

class _CommunityCreatePostPageState extends State<CommunityCreatePostPage> {
  List<AssetEntity> _selectedAssets = [];
  final TextEditingController _captionController = TextEditingController();
  LayoutType _selectedLayout = LayoutType.classic;
  final PrivacyType _selectedPrivacy = PrivacyType.public;
  final String _selectedPrivacyLabel = PrivacyUtil.privacyTypeToLabel(
    PrivacyType.public,
  );
  bool _isCreatingPost = false;

  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(LoadCurrentUserEvent());
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  Future<void> _createPost() async {
    FocusScope.of(context).unfocus();

    if (_captionController.text.trim().isEmpty && _selectedAssets.isEmpty) {
      showErrorSnackBar(context, context.l10n.postContentOrPhotoRequired);
      return;
    }

    setState(() {
      _isCreatingPost = true;
    });

    try {
      final files = <File>[];
      for (final asset in _selectedAssets) {
        final file = await asset.file;
        if (file != null) {
          files.add(file);
        }
      }

      final postEntity = CreatePostEntity(
        caption: _captionController.text.trim().isNotEmpty
            ? _captionController.text.trim()
            : null,
        files: files.isNotEmpty ? files : null,
        layout: _selectedLayout,
        privacyType: _selectedPrivacy,
        orders: files.isNotEmpty
            ? List.generate(files.length, (index) => index)
            : null,
        titles: null,
        friendsExcept: null,
        friendsDetail: null,
        communityId: widget.communityId,
      );

      context.read<PostBloc>().add(CreatePostRequested(postEntity: postEntity));
    } catch (e) {
      setState(() {
        _isCreatingPost = false;
      });

      showErrorSnackBar(
        context,
        context.l10n.postCreateGenericError(e.toString()),
      );
    }
  }

  void _onSelectImage(BuildContext context) async {
    PermissionStatus status;

    if (Platform.isIOS) {
      status = await Permission.photos.request();
    } else {
      if (Platform.isAndroid) {
        if (await Permission.photos.isGranted ||
            await Permission.photos.request().isGranted) {
          status = PermissionStatus.granted;
        } else {
          status = await Permission.storage.request();
        }
      } else {
        status = await Permission.storage.request();
      }
    }

    if (status.isGranted) {
      final result = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (_) => GalleryPickerScreen(
            selectedAssets: _selectedAssets,
            openCamera: () => _openCamera(),
          ),
        ),
      );

      if (result != null && result is List<AssetEntity>) {
        setState(() {
          _selectedAssets = result;
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      showErrorSnackBar(context, context.l10n.postPhotoPermissionRequired);
    }
  }

  Future<void> _openCamera() async {
    try {
      final hasPermissions = await CameraHelper.requestCameraPermissions();

      if (!hasPermissions) {
        if (mounted) {
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Text(context.l10n.postCameraPermissionTitle),
              content: Text(context.l10n.postCameraPermissionMessage),
              actions: [
                CupertinoDialogAction(
                  child: Text(context.l10n.commonOk),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          );
        }
        return;
      }

      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CameraScreen()),
      );

      if (result != null && result is Map<String, dynamic>) {
        await _handleCameraResult(result);
      }
    } catch (_) {}
  }

  Future<void> _handleCameraResult(Map<String, dynamic> result) async {
    final String filePath = result['path'];
    final String fileType = result['type'];

    if (fileType == 'photo') {
      final File imageFile = File(filePath);

      final editedFiles = await Navigator.push<List<File>>(
        context,
        MaterialPageRoute(
          builder: (context) => EditSelectedImagePage(
            imageFiles: [imageFile],
            initialIndex: 0,
            onAdd: null,
            onRemoveAtIndex: null,
          ),
        ),
      );

      if (editedFiles != null && editedFiles.isNotEmpty) {
        for (final file in editedFiles) {
          try {
            final AssetEntity? asset = await _createAssetFromFile(file);
            if (asset != null) {
              setState(() {
                _selectedAssets.add(asset);
              });
            }
          } catch (e) {
            if (mounted) {
              showErrorSnackBar(
                context,
                context.l10n.postCannotAddPhoto(e.toString()),
              );
            }
          }
        }
      }
    }
  }

  Future<AssetEntity?> _createAssetFromFile(File file) async {
    try {
      final AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
        file.path,
        title: 'camera_${DateTime.now().millisecondsSinceEpoch}',
      );

      return asset;
    } catch (_) {
      return null;
    }
  }

  void _showMoreOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              SizedBox(height: 10.h),
              _optionRow(
                Icons.image,
                context.l10n.postPhotoVideo,
                Colors.green,
                onTap: () => {Navigator.pop(context), _onSelectImage(context)},
              ),
              _optionRow(
                CupertinoIcons.chart_bar,
                context.l10n.postPoll,
                Colors.orange,
              ),
              _optionRow(
                Icons.person_add_alt_1,
                context.l10n.postTagPeople,
                Colors.blueAccent,
              ),
              _optionRow(
                Icons.emoji_emotions,
                context.l10n.postFeelingActivity,
                Colors.amber,
              ),
              _optionRow(
                Icons.location_on,
                context.l10n.postCheckIn,
                Colors.redAccent,
              ),
              _optionRow(
                Icons.video_camera_front,
                context.l10n.postLiveVideo,
                Colors.pinkAccent,
              ),
              _optionRow(
                Icons.camera_alt,
                context.l10n.postCamera,
                Colors.blueAccent,
                onTap: () => _openCamera(),
              ),
              _optionRow(
                Icons.music_note,
                context.l10n.postMusic,
                Colors.redAccent,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _optionRow(
    IconData icon,
    String text,
    Color color, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Divider(height: 1.h, color: AppColors.divider),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
            child: Row(
              children: [
                Icon(icon, color: color, size: 26.sp),
                SizedBox(width: 18.w),
                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        setState(() {
          _isCreatingPost = state is PostCreating;
        });

        if (state is PostCreating) {
          widget.onPostCreated?.call();
        }

        if (state is PostCreated) {
          _captionController.clear();
          setState(() {
            _selectedAssets.clear();
          });

          // Nếu user không phải admin, thông báo bài viết chờ duyệt
          if (widget.userRole != 'admin') {
            showSuccessSnackBar(
              context,
              context.l10n.communityPostPendingApproval,
            );
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            toolbarHeight: 72.h,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              color: AppColors.textPrimary,
              onPressed: () => Navigator.of(context).maybePop(),
            ),
            title: Text(
              context.l10n.communityCreatePostTitle,
              softWrap: true,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
            centerTitle: false,
            actions: [
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isCreatingPost ? null : _createPost,
                    child: _isCreatingPost
                        ? SizedBox(
                            width: 14.sp,
                            height: 14.sp,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            context.l10n.postSubmit,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  SizedBox(width: 12.w),
                ],
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.fromLTRB(12.w, 8.h, 4.w, 16.h),
              child: Column(
                children: [
                  BlocBuilder<MenuBloc, MenuState>(
                    builder: (context, state) {
                      if (state is MenuLoadingState) {
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }

                      if (state is MenuLoadedState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundImage: NetworkImage(
                                state.user.avatarUrl ??
                                    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background,
                                        borderRadius: BorderRadius.circular(
                                          14.r,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            state.user.fullName ??
                                                context.l10n.commonUnknown,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13.sp,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.h,
                                              vertical: 4.w,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF3B82F6,
                                              ).withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  getIcon(
                                                    _selectedPrivacyLabel,
                                                  ),
                                                  color: const Color(
                                                    0xFF3B82F6,
                                                  ),
                                                  size: 14.sp,
                                                ),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  _selectedPrivacyLabel,
                                                  style: TextStyle(
                                                    color: const Color(
                                                      0xFF3B82F6,
                                                    ),
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 13.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 14.h),
                  TextField(
                    controller: _captionController,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: context.l10n.postWriteSomethingHint,
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                  if (_selectedAssets.isNotEmpty) ...[
                    SelectedImagesDisplay(
                      selectedAssets: _selectedAssets,
                      onChangedLayout: (layout) {
                        setState(() {
                          _selectedLayout = layout;
                        });
                      },
                      onEdit: () => _onSelectImage(context),
                      onRemove: (assets) {
                        setState(() {
                          _selectedAssets.clear();
                        });
                      },
                      onRemoveAtIndex: (index) {
                        setState(() {
                          _selectedAssets.removeAt(index);
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 8.w),
            color: AppColors.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(height: 1.h, color: AppColors.divider),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _bottomIcon(
                      Icons.image,
                      color: Colors.green,
                      onTap: () => _onSelectImage(context),
                    ),
                    _bottomIcon(
                      Icons.person_add_alt_1,
                      color: Colors.blueAccent,
                    ),
                    _bottomIcon(Icons.emoji_emotions, color: Colors.amber),
                    _bottomIcon(Icons.location_on, color: Colors.redAccent),
                    _bottomIcon(
                      CupertinoIcons.ellipsis_circle,
                      color: Colors.grey,
                      onTap: () => _showMoreOptions(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon, {Color? color, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, color: color, size: 28.sp),
    );
  }
}
