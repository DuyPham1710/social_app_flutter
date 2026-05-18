import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart';
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
import 'package:social_app_fe/features/post/presentation/helpers/tag_helper.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_state.dart';
import 'package:social_app_fe/shared/helpers/camera_helper.dart';
import 'package:social_app_fe/features/post/presentation/pages/camera_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/gallery_picker_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/edit_selected_image_page.dart';
import 'package:social_app_fe/features/privacy/presentation/page/privacy_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/tag_friends_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/selected_images_display.dart';
import 'package:social_app_fe/shared/helpers/privacy_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class CreatePostPage extends StatefulWidget {
  final VoidCallback? onPostCreated;
  final String? communityId;

  const CreatePostPage({super.key, this.onPostCreated, this.communityId});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  List<AssetEntity> _selectedAssets = [];
  final TextEditingController _captionController = TextEditingController();
  LayoutType _selectedLayout = LayoutType.classic;
  late PrivacyType _selectedPrivacy;
  String _selectedPrivacyLabel = '';
  List<String> _friendsExceptIds = [];
  List<String> _friendsDetailIds = [];
  List<Map<String, String>> _taggedUsers = [];
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
    // ẩn bàn phím
    FocusScope.of(context).unfocus();

    // Kiểm tra nếu cả caption và ảnh đều trống
    if (_captionController.text.trim().isEmpty && _selectedAssets.isEmpty) {
      showErrorSnackBar(
        context,
        'Vui lòng nhập nội dung hoặc chọn ảnh để đăng',
      );
      return;
    }

    // Validation: Nếu chọn friends_except hoặc friends_detail, phải có danh sách bạn bè
    if (_selectedPrivacy == PrivacyType.friendsExcept &&
        _friendsExceptIds.isEmpty) {
      showErrorSnackBar(context, 'Vui lòng chọn bạn bè cần ẩn bài viết');

      return;
    }

    if (_selectedPrivacy == PrivacyType.friendsDetail &&
        _friendsDetailIds.isEmpty) {
      showErrorSnackBar(context, 'Vui lòng chọn bạn bè được phép xem bài viết');

      return;
    }

    setState(() {
      _isCreatingPost = true;
    });

    try {
      // Convert AssetEntity to File
      List<File> files = [];
      for (var asset in _selectedAssets) {
        final file = await asset.file;
        if (file != null) {
          files.add(file);
        }
      }

      // Chỉ gửi friendsExcept/friendsDetail nếu privacy type tương ứng
      List<String>? friendsExcept;
      List<String>? friendsDetail;

      if (_selectedPrivacy == PrivacyType.friendsExcept &&
          _friendsExceptIds.isNotEmpty) {
        friendsExcept = _friendsExceptIds;
      }
      if (_selectedPrivacy == PrivacyType.friendsDetail &&
          _friendsDetailIds.isNotEmpty) {
        friendsDetail = _friendsDetailIds;
      }

      // Create post entity
      final postEntity = CreatePostEntity(
        caption: _captionController.text.trim().isNotEmpty
            ? _captionController.text.trim()
            : null,
        files: files.isNotEmpty ? files : null,
        layout: _selectedLayout,
        privacyType: _selectedPrivacy,
        // orders and titles can be added later if needed
        orders: files.isNotEmpty
            ? List.generate(files.length, (index) => index)
            : null,
        titles: null, // Can be added if needed
        friendsExcept: friendsExcept,
        friendsDetail: friendsDetail,
        taggedUserIds: _taggedUsers.isNotEmpty
            ? _taggedUsers.map((e) => e['id']!).toList()
            : null,
        communityId: widget.communityId,
      );

      // Trigger BLoC event
      context.read<PostBloc>().add(CreatePostRequested(postEntity: postEntity));
    } catch (e) {
      setState(() {
        _isCreatingPost = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Có lỗi xảy ra: ${e.toString()}')));
    }
  }

  void _onSelectImage(BuildContext context) async {
    PermissionStatus status;

    if (Platform.isIOS) {
      // iOS dùng quyền photos
      status = await Permission.photos.request();
    } else {
      // Android
      if (Platform.isAndroid) {
        // Android 13 (SDK 33+) trở lên có quyền riêng cho ảnh
        if (await Permission.photos.isGranted ||
            await Permission.photos.request().isGranted) {
          status = PermissionStatus.granted;
        } else {
          // Dự phòng cho các bản Android cũ hơn
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
      showErrorSnackBar(context, 'Cần quyền truy cập ảnh để tiếp tục');
    }
  }

  Future<void> _openTagFriends() async {
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => TagFriendsPage(
          initialSelectedFriends: _taggedUsers.map((e) => e['id']!).toList(),
        ),
      ),
    );
    if (result != null && result is List<Map<String, String>>) {
      setState(() {
        _taggedUsers = result;
      });
    }
  }

  Widget _buildTaggedText() {
    final taggedNames = _taggedUsers.map((e) => e['name']!).toList();
    return TagHelper.buildTagsOnly(taggedNames: taggedNames);
  }

  Future<void> _openCamera() async {
    try {
      // Check camera permissions first
      final hasPermissions = await CameraHelper.requestCameraPermissions();

      if (!hasPermissions) {
        if (mounted) {
          // Show permission denied dialog
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Quyền truy cập Camera'),
              content: const Text(
                'Ứng dụng cần quyền truy cập camera và microphone để chụp ảnh và quay video.',
              ),

              actions: [
                CupertinoDialogAction(
                  child: const Text('OK'),
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
    } catch (e) {
      print('Error opening camera: $e');
    }
  }

  // Handle camera result và navigate đến ImageEditor
  Future<void> _handleCameraResult(Map<String, dynamic> result) async {
    final String filePath = result['path'];
    final String fileType = result['type'];

    // Chỉ xử lý ảnh, bỏ qua video
    if (fileType == 'photo') {
      final File imageFile = File(filePath);

      // Navigate đến EditSelectedImagePage để chỉnh sửa ảnh
      final editedFiles = await Navigator.push<List<File>>(
        context,
        MaterialPageRoute(
          builder: (context) => EditSelectedImagePage(
            imageFiles: [imageFile],
            initialIndex: 0,
            onAdd: null, // Không cần thêm ảnh trong trường hợp này
            onRemoveAtIndex: null, // Không cần xóa trong trường hợp này
          ),
        ),
      );

      // Nếu có file được edit, convert thành AssetEntity
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
            print('Error creating AssetEntity from file: $e');
            // Fallback: Show error message
            if (mounted) {
              showErrorSnackBar(context, "Không thể thêm ảnh: $e");
            }
          }
        }
      }
    } else if (fileType == 'video') {
      // Handle video nếu cần
      print('Video captured: $filePath');
      // TODO: Implement video handling if needed
    }
  }

  // Helper method để tạo AssetEntity từ File
  Future<AssetEntity?> _createAssetFromFile(File file) async {
    try {
      // Lưu file vào gallery
      final AssetEntity asset = await PhotoManager.editor.saveImageWithPath(
        file.path,
        title: "camera_${DateTime.now().millisecondsSinceEpoch}",
      );

      return asset;
    } catch (e) {
      print('Error creating AssetEntity: $e');
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
                "Ảnh/video",
                Colors.green,
                onTap: () => {Navigator.pop(context), _onSelectImage(context)},
              ),
              _optionRow(
                CupertinoIcons.chart_bar,
                "Thăm dò ý kiến",
                Colors.orange,
              ),
              _optionRow(
                Icons.person_add_alt_1,
                "Gắn thẻ người khác",
                Colors.blueAccent,
              ),
              _optionRow(
                Icons.emoji_emotions,
                "Cảm xúc/hoạt động",
                Colors.amber,
              ),
              _optionRow(Icons.location_on, "Check in", Colors.redAccent),
              _optionRow(
                Icons.video_camera_front,
                "Video trực tiếp",
                Colors.pinkAccent,
              ),
              _optionRow(
                Icons.camera_alt,
                "Camera",
                Colors.blueAccent,
                onTap: () => _openCamera(),
              ),
              _optionRow(Icons.music_note, "Nhạc", Colors.redAccent),
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
          // Clear form (SnackBar hiển thị ở main_page)
          _captionController.clear();
          setState(() {
            _selectedAssets.clear();
          });
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

            title: Text(
              'Tạo bài viết',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
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
                            'Đăng',
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
                                          Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            children: [
                                              Text(
                                                state.user.fullName ??
                                                    'unknown',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14.sp,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                              if (_taggedUsers.isNotEmpty) ...[
                                                Text(
                                                  ' cùng với ',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: _openTagFriends,
                                                  child: _buildTaggedText(),
                                                ),
                                              ],
                                            ],
                                          ),

                                          SizedBox(height: 8.h),

                                          BlocProvider(
                                            create: (_) => s1<PrivacyBloc>()
                                              ..add(
                                                GetDefaultPrivacyRequested(),
                                              ),
                                            child: BlocBuilder<PrivacyBloc, PrivacyState>(
                                              builder: (context, state) {
                                                if (state is PrivacyLoading) {
                                                  return const CupertinoActivityIndicator();
                                                }

                                                if (state is PrivacyLoaded) {
                                                  _selectedPrivacyLabel =
                                                      state.selectedPrivacy;
                                                  _selectedPrivacy =
                                                      PrivacyUtil.labelToPrivacyType(
                                                        state.selectedPrivacy,
                                                      );
                                                }

                                                return GestureDetector(
                                                  onTap: () async {
                                                    final result = await Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (_) =>
                                                            BlocProvider.value(
                                                              value: context
                                                                  .read<
                                                                    PrivacyBloc
                                                                  >(), // dùng lại bloc
                                                              child: PrivacyPage(
                                                                selectedOption:
                                                                    _selectedPrivacyLabel,
                                                              ),
                                                            ),
                                                      ),
                                                    );

                                                    if (result != null) {
                                                      setState(() {
                                                        // result có thể là String (cũ) hoặc Map (mới)
                                                        if (result is Map) {
                                                          _selectedPrivacyLabel =
                                                              result['label']
                                                                  as String;
                                                          _friendsExceptIds =
                                                              (result['friendsExcept']
                                                                      as List<
                                                                        dynamic
                                                                      >?)
                                                                  ?.map(
                                                                    (e) => e
                                                                        .toString(),
                                                                  )
                                                                  .toList() ??
                                                              [];
                                                          _friendsDetailIds =
                                                              (result['friendsDetail']
                                                                      as List<
                                                                        dynamic
                                                                      >?)
                                                                  ?.map(
                                                                    (e) => e
                                                                        .toString(),
                                                                  )
                                                                  .toList() ??
                                                              [];
                                                        } else if (result
                                                            is String) {
                                                          // Backward compatibility
                                                          _selectedPrivacyLabel =
                                                              result;
                                                          _friendsExceptIds =
                                                              [];
                                                          _friendsDetailIds =
                                                              [];
                                                        }

                                                        _selectedPrivacy =
                                                            PrivacyUtil.labelToPrivacyType(
                                                              _selectedPrivacyLabel,
                                                            );
                                                      });
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 10.h,
                                                          vertical: 4.w,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      color: AppColors.primary.withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                    ),

                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          getIcon(
                                                            _selectedPrivacyLabel,
                                                          ),
                                                          color: AppColors.primary,
                                                          size: 14.sp,
                                                        ),

                                                        SizedBox(width: 4.w),

                                                        Text(
                                                          _selectedPrivacyLabel,
                                                          style: TextStyle(
                                                            color: AppColors.primary,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontSize: 13.sp,
                                                          ),
                                                        ),

                                                        SizedBox(width: 2.w),

                                                        Icon(
                                                          Icons.arrow_drop_down,
                                                          color: AppColors.primary,
                                                          size: 18.sp,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
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

                  /// Ô nhập "Bạn đang nghĩ gì?"
                  TextField(
                    controller: _captionController,
                    cursorColor: AppColors.primary,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.sp,
                    ),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Bạn đang nghĩ gì?',
                      hintStyle: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 18.sp,
                      ),
                      border: InputBorder.none,
                    ),
                  ),

                  /// Selected images display
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
                      onImageEdited: (index, newFile) async {
                        try {
                          final AssetEntity? asset = await _createAssetFromFile(
                            newFile,
                          );
                          if (asset != null && mounted) {
                            setState(() {
                              _selectedAssets[index] = asset;
                            });
                          }
                        } catch (e) {
                          print('Error updating edited asset: $e');
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),

          bottomNavigationBar: Container(
            padding: EdgeInsets.only(
              top: 10.h,
              bottom: 90.h,
              left: 8.w,
              right: 8.w,
            ),
            color: AppColors.background,

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Divider(height: 1.h, color: AppColors.divider),

                SizedBox(height: 10.h),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _bottomIcon(
                        Icons.image_outlined,
                        "Thư viện",
                        onTap: () => _onSelectImage(context),
                      ),
                      _bottomIcon(
                        Icons.person_add_alt_1,
                        "Gắn thẻ",
                        onTap: _openTagFriends,
                      ),
                      _bottomIcon(Icons.emoji_emotions_outlined, "Cảm xúc"),
                      _bottomIcon(Icons.location_on_outlined, "Vị trí"),
                      _bottomIcon(
                        CupertinoIcons.ellipsis,
                        "Thêm",
                        onTap: () => _showMoreOptions(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 90.w),
        margin: EdgeInsets.only(right: 8.w),
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 24.sp),
            SizedBox(height: 4.h),
            Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
