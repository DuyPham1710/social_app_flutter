import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
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
import 'package:social_app_fe/l10n/l10n.dart';
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
  List<dynamic> _selectedAssets = [];
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
      showErrorSnackBar(context, context.l10n.postContentOrPhotoRequired);
      return;
    }

    // Validation: Nếu chọn friends_except hoặc friends_detail, phải có danh sách bạn bè
    if (_selectedPrivacy == PrivacyType.friendsExcept &&
        _friendsExceptIds.isEmpty) {
      showErrorSnackBar(context, context.l10n.postSelectHiddenFriendsRequired);

      return;
    }

    if (_selectedPrivacy == PrivacyType.friendsDetail &&
        _friendsDetailIds.isEmpty) {
      showErrorSnackBar(context, context.l10n.postSelectAllowedFriendsRequired);

      return;
    }

    setState(() {
      _isCreatingPost = true;
    });

    try {
      // Convert AssetEntity to File or extract PlatformFile bytes
      List<File> files = [];
      List<Uint8List> fileBytesList = [];
      List<String> fileNames = [];

      for (var asset in _selectedAssets) {
        if (asset is AssetEntity) {
          final file = await asset.file;
          if (file != null) {
            files.add(file);
          }
        } else if (asset is PlatformFile) {
          if (asset.bytes != null) {
            fileBytesList.add(asset.bytes!);
            fileNames.add(asset.name);
          }
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
        fileBytesList: fileBytesList.isNotEmpty ? fileBytesList : null,
        fileNames: fileNames.isNotEmpty ? fileNames : null,
        layout: _selectedLayout,
        privacyType: _selectedPrivacy,
        // orders and titles can be added later if needed
        orders: files.isNotEmpty
            ? List.generate(files.length, (index) => index)
            : (fileBytesList.isNotEmpty
                  ? List.generate(fileBytesList.length, (index) => index)
                  : null),
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.postCreateGenericError(e.toString())),
        ),
      );
    }
  }

  void _onSelectImage(BuildContext context) async {
    if (kIsWeb) {
      final result = await FilePicker.pickFiles(
        type: FileType.media,
        allowMultiple: true,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        if (!mounted) return;

        setState(() {
          _selectedAssets.addAll(result.files);
        });
      }
      return;
    }

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
            selectedAssets: _selectedAssets.whereType<AssetEntity>().toList(),
            openCamera: () => _openCamera(),
          ),
        ),
      );

      if (result != null && result is List<AssetEntity>) {
        setState(() {
          // Xóa hết ảnh cũ nếu là dùng gallery picker (vì result trả về danh sách chọn mới)
          _selectedAssets = result;
        });
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      showErrorSnackBar(context, context.l10n.postPhotoPermissionRequired);
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
    return TagHelper.buildTagsOnly(
      l10n: context.l10n,
      taggedNames: taggedNames,
    );
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
              showErrorSnackBar(
                context,
                context.l10n.postCannotAddPhoto(e.toString()),
              );
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
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.rsr(context)),
        ),
      ),

      builder: (_) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 12.rsh(context)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.rsh(context)),

              Container(
                width: 40.rs(context),
                height: 4.rsh(context),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(10.rsr(context)),
                ),
              ),

              SizedBox(height: 10.rsh(context)),

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
          Divider(height: 1.rsh(context), color: AppColors.divider),

          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 10.rsh(context),
              horizontal: 20.rs(context),
            ),
            child: Row(
              children: [
                Icon(icon, color: color, size: 26.rsp(context)),

                SizedBox(width: 18.rs(context)),

                Text(
                  text,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.rsp(context),
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
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveHelper.feedMaxWidth,
            ),
            child: Scaffold(
              backgroundColor: AppColors.background,
              appBar: AppBar(
                backgroundColor: AppColors.background,
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                automaticallyImplyLeading: false,

                title: Text(
                  context.l10n.postCreateTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20.rsp(context),
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
                            horizontal: 20.rs(context),
                            vertical: 10.rsh(context),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12.rsr(context),
                            ),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isCreatingPost ? null : _createPost,

                        child: _isCreatingPost
                            ? SizedBox(
                                width: 14.rsp(context),
                                height: 14.rsp(context),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                context.l10n.postSubmit,
                                style: TextStyle(
                                  fontSize: 14.rsp(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),

                      SizedBox(width: 12.rs(context)),
                    ],
                  ),
                ],
              ),

              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    12.rs(context),
                    8.rsh(context),
                    4.rs(context),
                    16.rsh(context),
                  ),

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
                                  radius: 20.rsr(context),
                                  backgroundImage: NetworkImage(
                                    state.user.avatarUrl ??
                                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSrHT9KQ3vag-Gdd9sjA7pi6zl2f_ho4Gh7Vg&s',
                                  ),
                                ),

                                SizedBox(width: 12.rs(context)),

                                Expanded(
                                  child: GestureDetector(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 10.rs(context),
                                            vertical: 8.rsh(context),
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.background,
                                            borderRadius: BorderRadius.circular(
                                              14.rsr(context),
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
                                                        context
                                                            .l10n
                                                            .commonUnknown,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14.rsp(context),
                                                      color:
                                                          AppColors.textPrimary,
                                                    ),
                                                  ),
                                                  if (_taggedUsers
                                                      .isNotEmpty) ...[
                                                    SizedBox(
                                                      width: 6.rs(context),
                                                    ),
                                                    Text(
                                                      context.l10n.postWith,
                                                      style: TextStyle(
                                                        fontSize: 14.rsp(
                                                          context,
                                                        ),
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 6.rs(context),
                                                    ),
                                                    GestureDetector(
                                                      onTap: _openTagFriends,
                                                      child: _buildTaggedText(),
                                                    ),
                                                  ],
                                                ],
                                              ),

                                              SizedBox(height: 8.rsh(context)),

                                              BlocProvider(
                                                create: (_) => s1<PrivacyBloc>()
                                                  ..add(
                                                    GetDefaultPrivacyRequested(),
                                                  ),
                                                child: BlocBuilder<PrivacyBloc, PrivacyState>(
                                                  builder: (context, state) {
                                                    if (state
                                                        is PrivacyLoading) {
                                                      return const CupertinoActivityIndicator();
                                                    }

                                                    if (state
                                                        is PrivacyLoaded) {
                                                      _selectedPrivacyLabel =
                                                          state.selectedPrivacy;
                                                      _selectedPrivacy =
                                                          PrivacyUtil.labelToPrivacyType(
                                                            state
                                                                .selectedPrivacy,
                                                          );
                                                    }

                                                    return GestureDetector(
                                                      onTap: () async {
                                                        final result = await Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (_) => BlocProvider.value(
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
                                                              horizontal: 10
                                                                  .rsh(context),
                                                              vertical: 4.rs(
                                                                context,
                                                              ),
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .primary
                                                              .withValues(
                                                                alpha: 0.1,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                8.rsr(context),
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
                                                              color: AppColors
                                                                  .primary,
                                                              size: 14.rsp(
                                                                context,
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              width: 4.rs(
                                                                context,
                                                              ),
                                                            ),

                                                            Text(
                                                              _selectedPrivacyLabel,
                                                              style: TextStyle(
                                                                color: AppColors
                                                                    .primary,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 13
                                                                    .rsp(
                                                                      context,
                                                                    ),
                                                              ),
                                                            ),

                                                            SizedBox(
                                                              width: 2.rs(
                                                                context,
                                                              ),
                                                            ),

                                                            Icon(
                                                              Icons
                                                                  .arrow_drop_down,
                                                              color: AppColors
                                                                  .primary,
                                                              size: 18.rsp(
                                                                context,
                                                              ),
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

                      SizedBox(height: 14.rsh(context)),

                      /// Ô nhập "Bạn đang nghĩ gì?"
                      TextField(
                        controller: _captionController,
                        cursorColor: AppColors.primary,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18.rsp(context),
                        ),
                        maxLines: null,
                        decoration: InputDecoration(
                          hintText: context.l10n.postWriteSomethingHint,
                          hintStyle: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 18.rsp(context),
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
                              final AssetEntity? asset =
                                  await _createAssetFromFile(newFile);
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
                  top: 10.rsh(context),
                  bottom: 90.rsh(context),
                  left: 8.rs(context),
                  right: 8.rs(context),
                ),
                color: AppColors.background,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1.rsh(context), color: AppColors.divider),

                    SizedBox(height: 10.rsh(context)),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          _bottomIcon(
                            Icons.image_outlined,
                            context.l10n.postLibrary,
                            onTap: () => _onSelectImage(context),
                          ),
                          _bottomIcon(
                            Icons.person_add_alt_1,
                            context.l10n.postTag,
                            onTap: _openTagFriends,
                          ),
                          _bottomIcon(
                            Icons.emoji_emotions_outlined,
                            context.l10n.postFeeling,
                          ),
                          _bottomIcon(
                            Icons.location_on_outlined,
                            context.l10n.postLocation,
                          ),
                          _bottomIcon(
                            CupertinoIcons.ellipsis,
                            context.l10n.postMore,
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
        ),
      ),
    );
  }

  Widget _bottomIcon(IconData icon, String text, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(minWidth: 90.rs(context)),
        margin: EdgeInsets.only(right: 8.rs(context)),
        padding: EdgeInsets.symmetric(
          vertical: 8.rsh(context),
          horizontal: 12.rs(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.textSecondary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12.rsr(context)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 24.rsp(context)),
            SizedBox(height: 4.rsh(context)),
            Text(
              text,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 12.rsp(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
