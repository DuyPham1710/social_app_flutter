import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/video_util.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';

class EditSelectedImagePage extends StatefulWidget {
  final List<dynamic> imageFiles;
  final int initialIndex;
  final VoidCallback? onAdd;
  final Function(int index)? onRemoveAtIndex;
  final Function(int index, File newFile)? onImageEdited;

  const EditSelectedImagePage({
    super.key,
    required this.imageFiles,
    required this.initialIndex,
    this.onAdd,
    this.onRemoveAtIndex,
    this.onImageEdited,
  });

  @override
  State<EditSelectedImagePage> createState() => _EditSelectedImagePageState();
}

class _EditSelectedImagePageState extends State<EditSelectedImagePage> {
  late ItemScrollController _scrollController = ItemScrollController();
  List<TextEditingController> _captionControllers = [];

  @override
  void initState() {
    super.initState();
    _captionControllers = List.generate(
      widget.imageFiles.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in _captionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showVideoPlayer(dynamic videoFile) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(videoData: videoFile),
      ),
    );
  }

  Widget _buildMediaWidget(dynamic file) {
    if (VideoUtil.isVideo(file)) {
      if (file is File) {
        return buildVideoThumbnail(file.path);
      } else if (file is PlatformFile) {
        try {
          return buildVideoThumbnail(file.name, videoBytes: file.bytes);
        } catch (e) {
          return buildVideoThumbnail(file.name);
        }
      }
    } else {
      if (file is File) {
        return Image.file(
          file,
          fit: BoxFit.cover,
          width: double.infinity,
          key: ValueKey('_'),
        );
      } else if (file is PlatformFile) {
        try {
          return Image.memory(
            file.bytes!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 300,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.broken_image, color: Colors.grey[600]),
                ),
              );
            },
          );
        } catch (e) {
          // Ignore
        }
      }
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    final initialIndex = widget.initialIndex;

    return Container(
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

              leading: IconButton(
                icon: Icon(
                  CupertinoIcons.back,
                  color: AppColors.textPrimary,
                  size: 24.rsp(context),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),

              title: Text(
                context.l10n.postEdit,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
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
                          borderRadius: BorderRadius.circular(12.rsr(context)),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        // Return danh sách files đã được edit
                        Navigator.pop(context, widget.imageFiles);
                      },
                      child: Text(
                        context.l10n.commonDone,
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

            body: ScrollablePositionedList.builder(
              itemScrollController: _scrollController,
              initialScrollIndex: initialIndex,
              itemCount: widget.imageFiles.length + 1,
              itemBuilder: (context, index) {
                if (index == widget.imageFiles.length) {
                  return _buildButtonAddImage();
                }

                return Column(
                  children: [
                    Divider(color: AppColors.divider),

                    Padding(
                      padding: EdgeInsets.only(bottom: 6.rsh(context)),
                      child: GestureDetector(
                        onTap: () {
                          // Check if it's a video or image and handle accordingly
                          if (VideoUtil.isVideo(widget.imageFiles[index])) {
                            _showVideoPlayer(widget.imageFiles[index]);
                          } else {
                            // mở ảnh toàn màn hình khi nhấn
                            //    _showFullScreenImage(context, imageIndex);
                          }
                        },
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                // Check if it's video or image and display accordingly
                                _buildMediaWidget(widget.imageFiles[index]),
                              ],
                            ),

                            Positioned(
                              top: 10.rsh(context),
                              left: 10.rs(context),
                              child: VideoUtil.isVideo(widget.imageFiles[index])
                                  ? Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 10.rs(context),
                                        vertical: 6.rsh(context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.background.withOpacity(
                                          0.8,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.rsr(context),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.videocam,
                                            color: AppColors.textSecondary,
                                            size: 16.rsp(context),
                                          ),
                                          SizedBox(width: 4.rs(context)),
                                          Text(
                                            context.l10n.postVideo,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                              fontSize: 14.rsp(context),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : (kIsWeb
                                        ? const SizedBox.shrink()
                                        : GestureDetector(
                                            onTap: () async {
                                              try {
                                                // Đọc dữ liệu byte từ ảnh gốc
                                                final imageBytes = await widget
                                                    .imageFiles[index]
                                                    .readAsBytes();

                                                // Mở trình chỉnh sửa ảnh
                                                final editedImage =
                                                    await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            ImageEditor(
                                                              image: imageBytes,
                                                            ),
                                                      ),
                                                    );

                                                // Nếu người dùng đã chỉnh sửa xong và quay lại
                                                if (editedImage != null &&
                                                    editedImage is Uint8List) {
                                                  // Tạo tên file mới với timestamp để tránh cache
                                                  final timestamp = DateTime.now()
                                                      .millisecondsSinceEpoch;
                                                  final directory = widget
                                                      .imageFiles[index]
                                                      .parent;
                                                  final fileName = widget
                                                      .imageFiles[index]
                                                      .path
                                                      .split('/')
                                                      .last;
                                                  final nameWithoutExt =
                                                      fileName.split('.').first;
                                                  final extension = fileName
                                                      .split('.')
                                                      .last;
                                                  final newPath =
                                                      '${directory.path}/${nameWithoutExt}_edited_$timestamp.$extension';

                                                  final newFile = File(newPath);

                                                  // Ghi ảnh đã chỉnh sửa vào file mới
                                                  await newFile.writeAsBytes(
                                                    editedImage,
                                                  );

                                                  // Clear image cache để force reload
                                                  imageCache.clear();
                                                  imageCache.clearLiveImages();

                                                  setState(() {
                                                    // Cập nhật với file mới
                                                    widget.imageFiles[index] =
                                                        newFile;
                                                  });
                                                  widget.onImageEdited?.call(
                                                    index,
                                                    newFile,
                                                  );
                                                }
                                              } catch (e) {
                                                print(
                                                  "Lỗi khi chỉnh sửa ảnh: $e",
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.rs(context),
                                                vertical: 6.rsh(context),
                                              ),
                                              decoration: BoxDecoration(
                                                color: AppColors.background
                                                    .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      12.rsr(context),
                                                    ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color:
                                                        AppColors.textPrimary,
                                                    size: 16.rsp(context),
                                                  ),
                                                  SizedBox(
                                                    width: 4.rs(context),
                                                  ),
                                                  Text(
                                                    context.l10n.postEdit,
                                                    style: TextStyle(
                                                      color:
                                                          AppColors.textPrimary,
                                                      fontSize: 14.rsp(context),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                            ),

                            Positioned(
                              top: 10.rsh(context),
                              right: 10.rs(context),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.imageFiles.removeAt(index);
                                    if (index < _captionControllers.length) {
                                      _captionControllers[index].dispose();
                                      _captionControllers.removeAt(index);
                                    }
                                  });
                                  widget.onRemoveAtIndex?.call(index);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(6.rs(context)),
                                  decoration: BoxDecoration(
                                    color: AppColors.background.withOpacity(
                                      0.8,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.textPrimary,
                                    size: 18.rsp(context),
                                  ),
                                ),
                              ),
                            ),

                            /// Số thứ tự ảnh
                            Positioned(
                              right: 8.rs(context),
                              bottom: 8.rsh(context),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.rs(context),
                                  vertical: 4.rsh(context),
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.background.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(
                                    12.rsr(context),
                                  ),
                                ),
                                child: Text(
                                  '${index + 1}/${widget.imageFiles.length}',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 12.rsp(context),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    _buildCaptionInput(index),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Padding _buildButtonAddImage() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        12.rs(context),
        8.rsh(context),
        12.rs(context),
        24.rsh(context),
      ),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.background,
          padding: EdgeInsets.symmetric(vertical: 14.rsh(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.rsr(context)),
            side: BorderSide(color: AppColors.primary, width: 2),
          ),
          elevation: 0,
        ),
        onPressed: widget.onAdd,
        icon: Icon(
          CupertinoIcons.photo_on_rectangle,
          color: AppColors.primary,
          size: 22.rsp(context),
        ),
        label: Text(
          context.l10n.postAddPhotoVideo,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.rsp(context),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildCaptionInput(int index) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 2.rsh(context),
      ),
      child: TextField(
        controller: _captionControllers[index],
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15.rsp(context),
        ),
        decoration: InputDecoration(
          hintText: context.l10n.postAddCaptionHint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13.rsp(context),
          ),
          filled: true,
          fillColor: AppColors.background.withOpacity(0.5),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.rs(context),
            vertical: 10.rsh(context),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.rsr(context)),
            borderSide: BorderSide.none,
          ),
        ),
        maxLines: null,
      ),
    );
  }
}
