import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_items_page.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class SavePostBottomSheet extends StatefulWidget {
  final PostEntity post;
  final Function(String savedId) onSaved;

  const SavePostBottomSheet({
    super.key,
    required this.post,
    required this.onSaved,
  });

  @override
  State<SavePostBottomSheet> createState() => _SavePostBottomSheetState();

  static void show(
    BuildContext context, {
    required PostEntity post,
    required Function(String savedId) onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SavePostBottomSheet(post: post, onSaved: onSaved);
      },
    );
  }
}

class _SavePostBottomSheetState extends State<SavePostBottomSheet> {
  final SaveRepository _saveRepository = s1<SaveRepository>();
  bool _isLoading = true;
  bool _isSaving = false;
  List<Map<String, dynamic>> _collections = []; // name, image

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      final result = await _saveRepository.getSavedByUser(
        type: 'post',
        limit: 50,
      );
      if (result is DataStateSuccess && result.data != null) {
        // Group by collection name
        final Map<String, String?> collectionMap = {};
        for (var item in result.data!.data) {
          if (!collectionMap.containsKey(item.collection)) {
            // Find a thumbnail from the post content if available (for simplified demo we use content or null)
            collectionMap[item.collection] = item.content.isNotEmpty
                ? item.content
                : null;
          }
        }

        final collections = collectionMap.entries
            .map((e) => {'name': e.key, 'image': e.value})
            .toList();
        if (!collectionMap.containsKey('default')) {
          collections.insert(0, {'name': 'default', 'image': null});
        }

        setState(() {
          _collections = collections;
          _isLoading = false;
        });
      } else {
        setState(() {
          _collections = [
            {'name': 'default', 'image': null},
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _collections = [
          {'name': 'default', 'image': null},
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToCollection(String collectionName) async {
    setState(() {
      _isSaving = true;
    });

    try {
      String? contentPreview;
      if (widget.post.urls.isNotEmpty) {
        contentPreview = widget.post.urls.first.url;
      }

      final result = await _saveRepository.savePost(
        targetId: widget.post.id,
        type: 'post',
        collection: collectionName,
        content: contentPreview,
      );

      if (mounted) {
        Navigator.pop(context); // Close bottom sheet

        if (result is DataStateSuccess && result.data != null) {
          widget.onSaved(result.data!.id);
          showSuccessSnackBar(
            context,
            "Đã lưu bài viết vào bộ sưu tập '$collectionName'",
          );
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            'Lỗi: ${result.error?.message ?? "Không thể lưu bài viết"}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context, 'Lỗi: $e');
      }
    }
  }

  Future<void> _showCreateCollectionDialog() async {
    final TextEditingController controller = TextEditingController();

    final collectionName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          title: Text(
            'Tạo bộ sưu tập mới',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: 'Tên bộ sưu tập',
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              fillColor: AppColors.secondBackground,
              filled: true,
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Hủy',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: Text('Tạo', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        );
      },
    );

    if (collectionName != null && collectionName.isNotEmpty) {
      _saveToCollection(collectionName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),

            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SavedItemsPage(),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Row(
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: AppColors.secondBackground,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.bookmark, color: AppColors.textPrimary),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đã lưu',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(
                                Icons.lock,
                                size: 12.sp,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Chỉ mình tôi',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Divider(height: 1, color: AppColors.divider),
            ),

            // Collection list header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thêm vào bộ sưu tập',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: _showCreateCollectionDialog,
                    child: Text(
                      'Tạo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Collection List
            if (_isLoading)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (_isSaving)
              Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: _collections.length,
                  itemBuilder: (context, index) {
                    final item = _collections[index];
                    return _buildCollectionItem(
                      context,
                      item['name'],
                      item['image'],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItem(
    BuildContext context,
    String title,
    String? imageUrl,
  ) {
    return InkWell(
      onTap: () => _saveToCollection(title),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: AppColors.secondBackground,
                borderRadius: BorderRadius.circular(8.r),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null || imageUrl.isEmpty
                  ? Icon(Icons.bookmark_border, color: AppColors.unselectedIcon)
                  : null,
            ),
            SizedBox(width: 12.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Chỉ mình tôi',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add icon
            Container(
              width: 30.w,
              height: 30.w,
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textSecondary, width: 1.5),
              ),
              child: Icon(
                Icons.add,
                size: 20.sp,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
