// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:social_app_fe/core/constants/app_colors.dart';
// import 'package:social_app_fe/features/chat/domain/entities/chat_entities.dart';
// import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/grid_image_item.dart';
// import 'package:social_app_fe/features/post/presentation/pages/camera_screen.dart';
// import 'package:social_app_fe/shared/helpers/camera_helper.dart';

// class InputAreaWidget extends StatefulWidget {
//   final TextEditingController messageController;
//   final FocusNode focusNode;
//   final String userId;
//   final MessageEntity? replyingMessage;
//   final MessageEntity? editMessage;
//   final VoidCallback onClearReply;
//   final VoidCallback onClearEdit;
//   final Function(String) onTextChanged;
//   final VoidCallback onSendMessage;
//   final VoidCallback onScrollToBottom;

//   const InputAreaWidget({
//     super.key,
//     required this.messageController,
//     required this.focusNode,
//     required this.userId,
//     this.replyingMessage,
//     this.editMessage,
//     required this.onClearReply,
//     required this.onClearEdit,
//     required this.onTextChanged,
//     required this.onSendMessage,
//     required this.onScrollToBottom,
//   });

//   @override
//   State<InputAreaWidget> createState() => _InputAreaWidgetState();
// }

// class _InputAreaWidgetState extends State<InputAreaWidget> {
//   // Track input expansion state
//   bool _isInputExpanded = false;

//   // Track photo picker state
//   bool _showPhotoPicker = false;
//   List<AssetEntity> _photoList = [];
//   bool _isLoadingPhotos = false;
//   bool _isLoadingMorePhotos = false;
//   int _currentPhotoPage = 0;
//   static const int _photosPerPage = 50;
//   bool _hasMorePhotos = true;

//   // Selected photos
//   List<AssetEntity> _selectedPhotos = [];

//   // Cache cho thumbnails
//   final Map<String, Uint8List> _thumbnailCache = {};

//   // Photo picker height và drag
//   double _photoPickerHeight = 0.0;
//   final ScrollController _photoPickerScrollController = ScrollController();

//   // Captured photo from camera
//   String? _capturedPhotoPath;

//   @override
//   void initState() {
//     super.initState();
//     widget.focusNode.addListener(_onFocusChanged);
//   }

//   @override
//   void dispose() {
//     widget.focusNode.removeListener(_onFocusChanged);
//     _photoPickerScrollController.dispose();
//     super.dispose();
//   }

//   void _onFocusChanged() {
//     if (!widget.focusNode.hasFocus) {
//       setState(() {
//         _isInputExpanded = false;
//       });
//     } else {
//       setState(() {
//         _showPhotoPicker = false;
//       });
//     }
//   }

//   void _toggleInputExpansion() {
//     setState(() {
//       _isInputExpanded = !_isInputExpanded;
//     });
//     if (!widget.focusNode.hasFocus) {
//       widget.focusNode.requestFocus();
//     }
//   }

//   void _collapseInput() {
//     setState(() {
//       _isInputExpanded = false;
//     });
//   }

//   double _getPhotoPickerMinHeight() {
//     return MediaQuery.of(context).size.height * 0.5;
//   }

//   double _getPhotoPickerMaxHeight() {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final safeAreaTop = MediaQuery.of(context).padding.top;
//     final safeAreaBottom = MediaQuery.of(context).padding.bottom;
//     final appBarHeight = AppBar().preferredSize.height;
//     final inputAreaHeight = 100.0;
//     return screenHeight -
//         safeAreaTop -
//         appBarHeight -
//         inputAreaHeight -
//         safeAreaBottom;
//   }

//   Future<void> _openCamera() async {
//     try {
//       final hasPermissions = await CameraHelper.requestCameraPermissions();

//       if (!hasPermissions) {
//         if (mounted) {
//           showCupertinoDialog(
//             context: context,
//             builder: (context) => CupertinoAlertDialog(
//               title: const Text('Quyền truy cập Camera'),
//               content: const Text(
//                 'Ứng dụng cần quyền truy cập camera để chụp ảnh.',
//               ),
//               actions: [
//                 CupertinoDialogAction(
//                   child: const Text('Hủy'),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//                 CupertinoDialogAction(
//                   child: const Text('Mở Cài đặt'),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     openAppSettings();
//                   },
//                 ),
//               ],
//             ),
//           );
//         }
//         return;
//       }

//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const CameraScreen()),
//       );

//       if (result != null && result is Map<String, dynamic>) {
//         if (result['type'] == 'photo' && result['path'] != null) {
//           setState(() {
//             _capturedPhotoPath = result['path'] as String;
//           });
//         }
//       }
//     } catch (e) {
//       print('Error opening camera: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Lỗi khi mở camera: $e'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _requestPhotoPermissionAndLoad() async {
//     PermissionStatus status;

//     if (Platform.isIOS) {
//       status = await Permission.photos.request();
//     } else {
//       if (Platform.isAndroid) {
//         if (await Permission.photos.isGranted ||
//             await Permission.photos.request().isGranted) {
//           status = PermissionStatus.granted;
//         } else {
//           status = await Permission.storage.request();
//         }
//       } else {
//         status = await Permission.storage.request();
//       }
//     }

//     if (status.isGranted) {
//       widget.focusNode.unfocus();
//       await Future.delayed(const Duration(milliseconds: 300));

//       setState(() {
//         _showPhotoPicker = true;
//         _isLoadingPhotos = true;
//         _photoPickerHeight = _getPhotoPickerMinHeight();
//       });
//       await _loadPhotos();
//     } else if (status.isPermanentlyDenied) {
//       if (mounted) {
//         showCupertinoDialog(
//           context: context,
//           builder: (context) => CupertinoAlertDialog(
//             title: const Text('Quyền truy cập ảnh'),
//             content: const Text(
//               'Ứng dụng cần quyền truy cập ảnh để hiển thị ảnh từ thư viện. Vui lòng cấp quyền trong Cài đặt.',
//             ),
//             actions: [
//               CupertinoDialogAction(
//                 child: const Text('Hủy'),
//                 onPressed: () => Navigator.pop(context),
//               ),
//               CupertinoDialogAction(
//                 child: const Text('Mở Cài đặt'),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   openAppSettings();
//                 },
//               ),
//             ],
//           ),
//         );
//       }
//     } else {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Cần quyền truy cập ảnh để tiếp tục'),
//             duration: Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _loadPhotos() async {
//     try {
//       final albums = await PhotoManager.getAssetPathList(
//         type: RequestType.common,
//         onlyAll: true,
//         filterOption: FilterOptionGroup(
//           orders: [
//             OrderOption(
//               type: OrderOptionType.updateDate,
//               asc: false,
//             ),
//           ],
//         ),
//       );

//       if (albums.isEmpty) {
//         setState(() {
//           _isLoadingPhotos = false;
//           _hasMorePhotos = false;
//         });
//         return;
//       }

//       final recent = albums.first;
//       final media = await recent.getAssetListPaged(
//         page: _currentPhotoPage,
//         size: _photosPerPage,
//       );

//       setState(() {
//         _photoList = media;
//         _isLoadingPhotos = false;
//         _currentPhotoPage = 0;
//         _hasMorePhotos = media.length == _photosPerPage;
//         _selectedPhotos.clear();
//       });
//     } catch (e) {
//       print('Error loading photos: $e');
//       if (mounted) {
//         setState(() {
//           _isLoadingPhotos = false;
//           _hasMorePhotos = false;
//         });
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Lỗi khi tải ảnh: $e'),
//             duration: const Duration(seconds: 2),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _loadMorePhotos() async {
//     if (_isLoadingMorePhotos || !_hasMorePhotos) return;

//     setState(() {
//       _isLoadingMorePhotos = true;
//     });

//     try {
//       final albums = await PhotoManager.getAssetPathList(
//         type: RequestType.image,
//         onlyAll: true,
//         filterOption: FilterOptionGroup(
//           orders: [
//             OrderOption(
//               type: OrderOptionType.updateDate,
//               asc: false,
//             ),
//           ],
//         ),
//       );

//       if (albums.isEmpty) {
//         setState(() {
//           _isLoadingMorePhotos = false;
//           _hasMorePhotos = false;
//         });
//         return;
//       }

//       final recent = albums.first;
//       final nextPage = _currentPhotoPage + 1;
//       final media = await recent.getAssetListPaged(
//         page: nextPage,
//         size: _photosPerPage,
//       );

//       if (mounted) {
//         setState(() {
//           _photoList.addAll(media);
//           _currentPhotoPage = nextPage;
//           _isLoadingMorePhotos = false;
//           _hasMorePhotos = media.length == _photosPerPage;
//         });
//       }
//     } catch (e) {
//       print('Error loading more photos: $e');
//       if (mounted) {
//         setState(() {
//           _isLoadingMorePhotos = false;
//           _hasMorePhotos = false;
//         });
//       }
//     }
//   }

//   Future<Uint8List?> _getCachedThumbnail(
//     AssetEntity asset,
//     ThumbnailSize size,
//   ) async {
//     final cacheKey = '${asset.id}_${size.width}_${size.height}';

//     if (_thumbnailCache.containsKey(cacheKey)) {
//       return _thumbnailCache[cacheKey];
//     }

//     final thumbnail = await asset.thumbnailDataWithSize(size);
//     if (thumbnail != null) {
//       _thumbnailCache[cacheKey] = thumbnail;
//     }
//     return thumbnail;
//   }

//   void _togglePhotoSelection(AssetEntity asset) {
//     setState(() {
//       if (_selectedPhotos.contains(asset)) {
//         _selectedPhotos.remove(asset);
//       } else {
//         _selectedPhotos.add(asset);
//       }
//     });
//   }

//   int _getPhotoIndex(AssetEntity asset) {
//     return _selectedPhotos.indexOf(asset) + 1;
//   }

//   bool _isPhotoSelected(AssetEntity asset) {
//     return _selectedPhotos.contains(asset);
//   }

//   void _onPhotoPickerScroll(ScrollController scrollController) {
//     if (scrollController.position.pixels >=
//         scrollController.position.maxScrollExtent * 0.8) {
//       if (!_isLoadingMorePhotos && _hasMorePhotos) {
//         _loadMorePhotos();
//       }
//     }
//   }

//   // Getters to expose selected photos and captured photo
//   List<AssetEntity> get selectedPhotos => _selectedPhotos;
//   String? get capturedPhotoPath => _capturedPhotoPath;

//   void clearSelectedPhotos() {
//     setState(() {
//       _selectedPhotos.clear();
//       _showPhotoPicker = false;
//     });
//   }

//   void clearCapturedPhoto() {
//     setState(() {
//       _capturedPhotoPath = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         if (widget.replyingMessage != null) _buildReplyPreview(),
//         if (widget.editMessage != null) _buildEditPreview(),
//         if (_capturedPhotoPath != null) _buildCapturedPhotoPreview(),

//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
//           decoration: BoxDecoration(
//             color: AppColors.background,
//             border: Border(
//               top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
//             ),
//           ),
//           child: Row(
//             children: [
//               if (_isInputExpanded)
//                 IconButton(
//                   icon: Icon(
//                     CupertinoIcons.chevron_right,
//                     color: AppColors.primary,
//                     size: 24.sp,
//                   ),
//                   onPressed: _collapseInput,
//                 ),

//               if (!_isInputExpanded) ...[
//                 IconButton(
//                   icon: Icon(
//                     CupertinoIcons.plus_circle_fill,
//                     color: AppColors.primary,
//                     size: 24.sp,
//                   ),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     CupertinoIcons.camera_fill,
//                     color: AppColors.primary,
//                     size: 24.sp,
//                   ),
//                   onPressed: _openCamera,
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     CupertinoIcons.photo_fill,
//                     color: AppColors.primary,
//                     size: 24.sp,
//                   ),
//                   onPressed: () async {
//                     if (!_showPhotoPicker) {
//                       await _requestPhotoPermissionAndLoad();
//                     } else {
//                       setState(() {
//                         _showPhotoPicker = false;
//                       });
//                     }
//                   },
//                 ),
//               ],

//               Expanded(
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxHeight: _isInputExpanded ? 120.h : 50.h,
//                   ),
//                   padding: EdgeInsets.symmetric(horizontal: 12.w),
//                   decoration: BoxDecoration(
//                     color: AppColors.textSecondary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(24.r),
//                   ),
//                   child: TextField(
//                     controller: widget.messageController,
//                     focusNode: widget.focusNode,
//                     onChanged: widget.onTextChanged,
//                     onTap: () {
//                       _toggleInputExpansion();
//                       Future.delayed(const Duration(milliseconds: 350), () {
//                         if (mounted) {
//                           widget.onScrollToBottom();
//                         }
//                       });
//                     },
//                     maxLines: _isInputExpanded ? null : 1,
//                     minLines: 1,
//                     textInputAction: TextInputAction.newline,
//                     keyboardType: _isInputExpanded
//                         ? TextInputType.multiline
//                         : TextInputType.text,
//                     decoration: InputDecoration(
//                       hintText: "Nhắn tin...",
//                       hintStyle: TextStyle(
//                         fontSize: 14.sp,
//                         color: AppColors.textSecondary,
//                       ),
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: 0,
//                         vertical: 8.h,
//                       ),
//                       isDense: true,
//                     ),
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(width: 8.w),
//               IconButton(
//                 icon: Icon(CupertinoIcons.paperplane_fill, color: Colors.blue),
//                 onPressed: widget.onSendMessage,
//               ),
//             ],
//           ),
//         ),

//         if (_showPhotoPicker) _buildPhotoPicker(),
//       ],
//     );
//   }

//   Widget _buildReplyPreview() {
//     final replyText = widget.replyingMessage!.text ?? '[Ảnh]';
//     final isReplyingToMe =
//         widget.replyingMessage!.sender.userId == widget.userId;

//     String name;
//     if (isReplyingToMe) {
//       name = 'chính mình';
//     } else {
//       final fullName = widget.replyingMessage!.sender.fullName ?? 'Unknown';
//       final parts = fullName.split(' ');
//       name = parts.isNotEmpty ? parts.last : 'Unknown';
//     }

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         border: Border(
//           top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 3.w,
//             height: 40.h,
//             color: AppColors.primary,
//             margin: EdgeInsets.only(right: 8.w),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Trả lời $name',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12.sp,
//                     color: AppColors.primary,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   replyText,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           if (widget.replyingMessage!.attachments.isNotEmpty)
//             Image(
//               image:
//                   NetworkImage(widget.replyingMessage!.attachments.first.url),
//               width: 30.w,
//               height: 40.h,
//               fit: BoxFit.cover,
//             ),
//           GestureDetector(
//             onTap: widget.onClearReply,
//             child: Padding(
//               padding: EdgeInsets.only(left: 8.w, top: 4.h),
//               child: Icon(
//                 CupertinoIcons.clear_circled_solid,
//                 size: 24,
//                 color: AppColors.textSecondary.withOpacity(0.5),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEditPreview() {
//     final editText = widget.editMessage!.text ?? '';

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         border: Border(
//           top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 3.w,
//             height: 40.h,
//             color: Colors.orange,
//             margin: EdgeInsets.only(right: 8.w),
//           ),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Chỉnh sửa tin nhắn',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 12.sp,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 SizedBox(height: 2.h),
//                 Text(
//                   editText,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     fontSize: 14.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: widget.onClearEdit,
//             child: Padding(
//               padding: EdgeInsets.only(left: 8.w, top: 4.h),
//               child: Icon(
//                 CupertinoIcons.clear_circled_solid,
//                 size: 24,
//                 color: AppColors.textSecondary.withOpacity(0.5),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCapturedPhotoPreview() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//       decoration: BoxDecoration(
//         color: AppColors.background,
//         border: Border(
//           top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
//         ),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(8.r),
//             child: Image.file(
//               File(_capturedPhotoPath!),
//               width: 60.w,
//               height: 60.w,
//               fit: BoxFit.cover,
//             ),
//           ),
//           SizedBox(width: 12.w),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Ảnh vừa chụp',
//                   style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14.sp,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 SizedBox(height: 4.h),
//                 Text(
//                   'Nhấn gửi để chia sẻ',
//                   style: TextStyle(
//                     fontSize: 12.sp,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               // Note: Parent needs to handle sending logic
//               widget.onSendMessage();
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(16.r),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     CupertinoIcons.paperplane_fill,
//                     color: Colors.white,
//                     size: 16.sp,
//                   ),
//                   SizedBox(width: 4.w),
//                   Text(
//                     'Gửi',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           SizedBox(width: 8.w),
//           GestureDetector(
//             onTap: () {
//               setState(() {
//                 _capturedPhotoPath = null;
//               });
//             },
//             child: Padding(
//               padding: EdgeInsets.only(left: 4.w, top: 4.h),
//               child: Icon(
//                 CupertinoIcons.clear_circled_solid,
//                 size: 24,
//                 color: AppColors.textSecondary.withOpacity(0.5),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPhotoPicker() {
//     final minHeight = _getPhotoPickerMinHeight();
//     final maxHeight = _getPhotoPickerMaxHeight();

//     return GestureDetector(
//       onVerticalDragUpdate: (details) {
//         setState(() {
//           _photoPickerHeight = (_photoPickerHeight - details.delta.dy).clamp(
//             minHeight,
//             maxHeight,
//           );
//         });
//       },
//       onVerticalDragEnd: (details) {
//         final velocity = details.primaryVelocity ?? 0;
//         setState(() {
//           if (velocity > 500) {
//             _photoPickerHeight = 0;
//             _showPhotoPicker = false;
//           } else if (velocity < -500) {
//             _photoPickerHeight = maxHeight;
//           } else {
//             if (_photoPickerHeight < (minHeight + maxHeight) / 2) {
//               _photoPickerHeight = minHeight;
//             } else {
//               _photoPickerHeight = maxHeight;
//             }
//           }
//         });
//       },
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//         height: _photoPickerHeight,
//         constraints: BoxConstraints(maxHeight: _getPhotoPickerMaxHeight()),
//         decoration: BoxDecoration(
//           color: AppColors.background,
//           border: Border(
//             top: BorderSide(color: AppColors.textSecondary.withOpacity(0.2)),
//           ),
//         ),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   final minHeight = _getPhotoPickerMinHeight();
//                   final maxHeight = _getPhotoPickerMaxHeight();
//                   if (_photoPickerHeight == minHeight) {
//                     _photoPickerHeight = maxHeight;
//                   } else {
//                     _photoPickerHeight = minHeight;
//                   }
//                 });
//               },
//               child: Container(
//                 margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
//                 width: 40.w,
//                 height: 4.h,
//                 decoration: BoxDecoration(
//                   color: AppColors.textSecondary.withOpacity(0.3),
//                   borderRadius: BorderRadius.circular(2.r),
//                 ),
//               ),
//             ),
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//               child: Row(
//                 children: [
//                   Icon(
//                     CupertinoIcons.photo_on_rectangle,
//                     color: AppColors.primary,
//                     size: 20.sp,
//                   ),
//                   SizedBox(width: 8.w),
//                   Text(
//                     'Tất cả ảnh',
//                     style: TextStyle(
//                       fontSize: 14.sp,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//                   const Spacer(),
//                   if (_selectedPhotos.isNotEmpty)
//                     GestureDetector(
//                       onTap: () {
//                         // Note: Parent needs to handle sending logic
//                         widget.onSendMessage();
//                       },
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 12.w,
//                           vertical: 6.h,
//                         ),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary,
//                           borderRadius: BorderRadius.circular(16.r),
//                         ),
//                         child: Text(
//                           'Gửi (${_selectedPhotos.length})',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 14.sp,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     )
//                   else
//                     GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _photoPickerHeight = 0;
//                           _showPhotoPicker = false;
//                         });
//                       },
//                       child: Icon(
//                         CupertinoIcons.chevron_down,
//                         color: AppColors.textSecondary,
//                         size: 16.sp,
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Flexible(
//               child: _isLoadingPhotos
//                   ? const Center(
//                       child: CircularProgressIndicator(
//                         color: AppColors.primary,
//                       ),
//                     )
//                   : _photoList.isEmpty
//                       ? Center(
//                           child: Text(
//                             'Không có ảnh nào',
//                             style: TextStyle(
//                               color: AppColors.textSecondary,
//                               fontSize: 14.sp,
//                             ),
//                           ),
//                         )
//                       : NotificationListener<ScrollNotification>(
//                           onNotification: (notification) {
//                             if (notification is ScrollUpdateNotification) {
//                               _onPhotoPickerScroll(
//                                   _photoPickerScrollController);
//                             }
//                             return false;
//                           },
//                           child: GridView.builder(
//                             controller: _photoPickerScrollController,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 8.w,
//                               vertical: 4.h,
//                             ),
//                             gridDelegate:
//                                 SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 4,
//                               crossAxisSpacing: 4.w,
//                               mainAxisSpacing: 4.h,
//                             ),
//                             itemCount: _photoList.length +
//                                 (_isLoadingMorePhotos ? 1 : 0),
//                             itemBuilder: (context, index) {
//                               if (index == _photoList.length) {
//                                 return const Center(
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     color: AppColors.primary,
//                                   ),
//                                 );
//                               }

//                               final asset = _photoList[index];
//                               return GridImageItem(
//                                 key: ValueKey(asset.id),
//                                 asset: asset,
//                                 isSelected: _isPhotoSelected(asset),
//                                 selectedIndex: _isPhotoSelected(asset)
//                                     ? _getPhotoIndex(asset)
//                                     : 0,
//                                 onTap: () => _togglePhotoSelection(asset),
//                                 getCachedThumbnail: _getCachedThumbnail,
//                               );
//                             },
//                           ),
//                         ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
