import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_items_page.dart';

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
        return SavePostBottomSheet(
          post: post,
          onSaved: onSaved,
        );
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
      final result = await _saveRepository.getSavedByUser(type: 'post', limit: 50);
      if (result is DataStateSuccess && result.data != null) {
        // Group by collection name
        final Map<String, String?> collectionMap = {};
        for (var item in result.data!.data) {
          if (!collectionMap.containsKey(item.collection)) {
            // Find a thumbnail from the post content if available (for simplified demo we use content or null)
            collectionMap[item.collection] = item.content.isNotEmpty ? item.content : null;
          }
        }
        
        setState(() {
          _collections = collectionMap.entries.map((e) => {
            'name': e.key,
            'image': e.value,
          }).toList();
          _isLoading = false;
        });
      } else {
        setState(() { _isLoading = false; });
      }
    } catch (e) {
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _saveToCollection(String collectionName) async {
    setState(() { _isSaving = true; });

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
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã lưu vào $collectionName'),
              backgroundColor: Colors.green[800],
            ),
          );
        } else if (result is DataStateError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi: ${result.error?.message ?? "Không thể lưu bài viết"}'),
              backgroundColor: Colors.red[800],
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $e'),
            backgroundColor: Colors.red[800],
          ),
        );
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
          title: const Text('Tạo bộ sưu tập mới', style: TextStyle(fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Tên bộ sưu tập',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: const Text('Tạo', style: TextStyle(color: AppColors.primary)),
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
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            
            // Header: "Đã lưu" (chỉ là giao diện hiển thị theo requirements)
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedItemsPage()),
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
                        color: Colors.grey[200],
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
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            children: [
                              Icon(Icons.lock, size: 12.sp, color: AppColors.textSecondary),
                              SizedBox(width: 4.w),
                              Text(
                                'Chỉ mình tôi',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          )
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
                    ),
                  ),
                  GestureDetector(
                    onTap: _showCreateCollectionDialog,
                    child: Text(
                      'Tạo',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Collection List
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_isSaving)
              const Padding(
                padding: EdgeInsets.all(32.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount: _collections.isEmpty ? 1 : _collections.length + 1, // +1 for layout default if not in list
                  itemBuilder: (context, index) {
                    if (index < _collections.length) {
                      final item = _collections[index];
                      return _buildCollectionItem(context, item['name'], item['image']);
                    } else if (_collections.isNotEmpty && index == _collections.length) {
                       // Add a default fallback creation item if we have other collections
                       return const SizedBox.shrink();
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionItem(BuildContext context, String title, String? imageUrl) {
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
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null || imageUrl.isEmpty
                  ? Icon(Icons.bookmark_border, color: Colors.grey[600])
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
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.lock, size: 12.sp, color: AppColors.textSecondary),
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
              child: Icon(Icons.add, size: 20.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
