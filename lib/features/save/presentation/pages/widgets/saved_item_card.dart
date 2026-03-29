import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';

class SavedItemCard extends StatelessWidget {
  final SavedEntity item;

  const SavedItemCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isImage =
        item.content.startsWith('http') &&
        (item.content.contains('.jpg') ||
            item.content.contains('.png') ||
            item.content.contains('.jpeg') ||
            item.content.contains('cloudinary'));

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content Area
          if (isImage)
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                item.content,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.error, color: Colors.grey),
                  );
                },
              ),
            )
          else if (item.content.isNotEmpty)
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                item.content,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            )
          else
            Padding(
              padding: EdgeInsets.all(12.w),
              child: Text(
                'Không có nội dung',
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

          // Divider
          if (item.authorName != null) ...[
            Divider(height: 1, thickness: 1, color: Colors.grey[200]),
            // Author Area
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12.r,
                    backgroundImage:
                        item.authorAvatar != null &&
                            item.authorAvatar!.isNotEmpty
                        ? NetworkImage(item.authorAvatar!)
                        : const AssetImage('assets/images/default_avatar.png')
                              as ImageProvider,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.authorName ?? 'Không xác định',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
