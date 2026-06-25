import 'dart:io';
import 'package:geocoding/geocoding.dart' as import_geo;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart' hide LatLng;
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
import 'package:social_app_fe/features/post/presentation/pages/camera_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/edit_selected_image_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/gallery_picker_screen.dart';
import 'package:social_app_fe/features/post/presentation/pages/tag_friends_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/location_picker_page.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/selected_images_display.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/location_bottom_sheet.dart';
import 'package:social_app_fe/shared/helpers/camera_helper.dart';
import 'package:social_app_fe/shared/helpers/privacy_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityCreatePostPage extends StatefulWidget {
  final String communityId;
  final String? userRole;
  final VoidCallback? onPostCreated;

  CommunityCreatePostPage({
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
  List<dynamic> _selectedAssets = [];
  final TextEditingController _captionController = TextEditingController();
  LayoutType _selectedLayout = LayoutType.classic;
  final PrivacyType _selectedPrivacy = PrivacyType.public;
  final String _selectedPrivacyLabel = PrivacyUtil.privacyTypeToLabel(
    PrivacyType.public,
  );
  bool _isCreatingPost = false;
  List<Map<String, String>> _taggedUsers = [];
  String? _selectedLocation;
  double? _selectedLat;
  double? _selectedLng;

  Future<void> _extractLocationFromAssets(List<dynamic> assets) async {
    List<Map<String, dynamic>> foundLocations = [];

    if (Platform.isAndroid) {
      await Permission.accessMediaLocation.request();
    }

    for (var asset in assets) {
      if (asset is AssetEntity) {
        final latlng = await asset.latlngAsync();
        if (latlng != null) {
          double lat = latlng.latitude;
          double lng = latlng.longitude;

          if (lat != 0.0 && lng != 0.0) {
            try {
              List<import_geo.Placemark> placemarks = await import_geo
                  .placemarkFromCoordinates(lat, lng);
              if (placemarks.isNotEmpty) {
                final placemark = placemarks.first;
                final String address = [
                  placemark.locality,
                  placemark.administrativeArea,
                  placemark.country,
                ].where((e) => e != null && e.isNotEmpty).join(', ');

                if (address.isNotEmpty) {
                  foundLocations.add({
                    'address': address,
                    'lat': lat,
                    'lng': lng,
                  });
                }
              }
            } catch (e) {
              print("Error getting location: $e");
            }
          }
        }
      }
    }

    if (foundLocations.isNotEmpty) {
      final locationCounts = <String, int>{};
      final locationData = <String, Map<String, dynamic>>{};
      
      for (var loc in foundLocations) {
        String address = loc['address'];
        locationCounts[address] = (locationCounts[address] ?? 0) + 1;
        if (!locationData.containsKey(address)) {
          locationData[address] = loc;
        }
      }

      var mostCommonLoc = foundLocations.first['address'] as String;
      var maxCount = 0;
      locationCounts.forEach((loc, count) {
        if (count > maxCount) {
          maxCount = count;
          mostCommonLoc = loc;
        }
      });

      if (!mounted) return;

      LocationBottomSheet.show(
        context,
        address: mostCommonLoc,
        onConfirm: () {
          setState(() {
            _selectedLocation = mostCommonLoc;
            _selectedLat = locationData[mostCommonLoc]!['lat'];
            _selectedLng = locationData[mostCommonLoc]!['lng'];
          });
          Navigator.pop(context);
        },
      );
    }
  }

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
      List<File> files = [];
      List<Uint8List> fileBytesList = [];
      List<String> fileNames = [];

      for (final asset in _selectedAssets) {
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

      final postEntity = CreatePostEntity(
        caption: _captionController.text.trim().isNotEmpty
            ? _captionController.text.trim()
            : null,
        location: _selectedLocation,
        latitude: _selectedLat,
        longitude: _selectedLng,
        files: files.isNotEmpty ? files : null,
        fileBytesList: fileBytesList.isNotEmpty ? fileBytesList : null,
        fileNames: fileNames.isNotEmpty ? fileNames : null,
        layout: _selectedLayout,
        privacyType: _selectedPrivacy,
        orders: files.isNotEmpty
            ? List.generate(files.length, (index) => index)
            : null,
        titles: null,
        friendsExcept: null,
        friendsDetail: null,
        taggedUserIds: _taggedUsers.isNotEmpty
            ? _taggedUsers.map((e) => e['id']!).toList()
            : null,
        communityId: widget.communityId,
      );

      if (!mounted) return;

      context.read<PostBloc>().add(CreatePostRequested(postEntity: postEntity));
    } catch (e) {
      if (!mounted) return;
      
      setState(() {
        _isCreatingPost = false;
      });

      showErrorSnackBar(
        context,
        context.l10n.postCreateGenericError(e.toString()),
      );
    }
  }

  void _onSelectImage() async {
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
      if (!mounted) return;
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
          _selectedAssets = result;
        });
        _extractLocationFromAssets(result);
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      if (!mounted) return;
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

      if (!mounted) return;
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraScreen()),
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
                onTap: () => {Navigator.pop(context), _onSelectImage()},
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
                onTap: () => _openLocationPicker(context, isFromBottomSheet: true),
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

  Future<void> _openLocationPicker(BuildContext context, {bool isFromBottomSheet = false}) async {
    if (isFromBottomSheet) {
      Navigator.pop(context); // Close the bottom sheet options
    }
    final result = await Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => LocationPickerPage(
          initialLocation: _selectedLat != null && _selectedLng != null
              ? LatLng(_selectedLat!, _selectedLng!)
              : null,
        ),
      ),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        _selectedLat = result['lat'];
        _selectedLng = result['lng'];
        _selectedLocation = result['address'];
      });
    }
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
          _captionController.clear();
          setState(() {
            _selectedAssets.clear();
          });

          // Náº¿u user khÃ´ng pháº£i admin, thÃ´ng bÃ¡o bÃ i viáº¿t chá» duyá»‡t
          if (widget.userRole != 'admin') {
            showSuccessSnackBar(
              context,
              context.l10n.communityPostPendingApproval,
            );
          }
        }
      },
      child: Container(
        color: AppColors.background,

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
                toolbarHeight: 72.rsh(context),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_rounded),
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
                    fontSize: 18.rsp(context),
                    fontWeight: FontWeight.w600,
                    height: 1.1.rsh(context),
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
                                width: 14.rs(context),
                                height: 14.rsh(context),
                                child: CircularProgressIndicator(
                                  color: AppColors.background,
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
                physics: AlwaysScrollableScrollPhysics(),
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
                            return Center(child: CupertinoActivityIndicator());
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
                                                    GestureDetector(
                                                      onTap: _openTagFriends,
                                                      child: _buildTaggedText(),
                                                    ),
                                                  ],
                                                  if (_selectedLocation !=
                                                      null) ...[
                                                    Text(
                                                      " - ",
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
                                                    Text(
                                                      _selectedLocation!,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14.rsp(
                                                          context,
                                                        ),
                                                        color: AppColors
                                                            .textPrimary,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4.rs(context),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedLocation =
                                                              null;
                                                          _selectedLat = null;
                                                          _selectedLng = null;
                                                        });
                                                      },
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 16.rsp(context),
                                                        color: AppColors
                                                            .textSecondary,
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),

                                              SizedBox(height: 8.rsh(context)),

                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.rsh(context),
                                                  vertical: 4.rs(context),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.1),
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
                                                      color: AppColors.primary,
                                                      size: 14.rsp(context),
                                                    ),
                                                    SizedBox(
                                                      width: 4.rs(context),
                                                    ),
                                                    Text(
                                                      _selectedPrivacyLabel,
                                                      style: TextStyle(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13.rsp(
                                                          context,
                                                        ),
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
                          return SizedBox.shrink();
                        },
                      ),
                      SizedBox(height: 14.rsh(context)),
                      TextField(
                        controller: _captionController,
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
                      if (_selectedAssets.isNotEmpty) ...[
                        SelectedImagesDisplay(
                          selectedAssets: _selectedAssets,
                          onChangedLayout: (layout) {
                            setState(() {
                              _selectedLayout = layout;
                            });
                          },
                          onEdit: () => _onSelectImage(),
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
                padding: EdgeInsets.symmetric(
                  vertical: 10.rsh(context),
                  horizontal: 8.rs(context),
                ),
                color: AppColors.background,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(height: 1.rsh(context), color: AppColors.divider),
                    SizedBox(height: 10.rsh(context)),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _bottomIcon(
                            Icons.image_outlined,
                            context.l10n.postLibrary,
                            onTap: () => _onSelectImage(),
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
                            onTap: () => _openLocationPicker(context),
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

