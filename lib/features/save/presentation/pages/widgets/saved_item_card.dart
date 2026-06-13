import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/save/domain/entities/saved_entity.dart';

class SavedItemCard extends StatelessWidget {
  final SavedEntity item;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  const SavedItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final bool isImage =
        item.content.startsWith('http') &&
        (item.content.contains('.jpg') ||
            item.content.contains('.png') ||
            item.content.contains('.jpeg') ||
            item.content.contains('cloudinary'));

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: AppColors.secondBackground,
      borderRadius: BorderRadius.circular(12.rsr(context)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.rsr(context)),
            border: Border.all(color: AppColors.divider),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isImage)
                    AspectRatio(
                      aspectRatio: 1,
                      child: Image.network(
                        item.content,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: AppColors.background,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.background,
                            child: Icon(
                              Icons.error,
                              color: AppColors.textSecondary,
                            ),
                          );
                        },
                      ),
                    )
                  else if (item.content.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.all(12.rs(context)),
                      child: Text(
                        item.content,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.rsp(context),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.all(12.rs(context)),
                      child: Text(
                        'Không có nội dung',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  if (item.authorName != null) ...[
                    Divider(height: 1, thickness: 1, color: AppColors.divider),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.rs(context),
                        vertical: 8.rsh(context),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12.rsr(context),
                            backgroundImage:
                                item.authorAvatar != null &&
                                    item.authorAvatar!.isNotEmpty
                                ? NetworkImage(item.authorAvatar!)
                                : const AssetImage(
                                        'assets/images/default_avatar.png',
                                      )
                                      as ImageProvider,
                          ),
                          SizedBox(width: 8.rs(context)),
                          Expanded(
                            child: Text(
                              item.authorName ?? 'Không xác định',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.rsp(context),
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              Positioned(
                top: 6.rsh(context),
                right: 6.rs(context),
                child: PopupMenuButton<String>(
                  tooltip: 'Tùy chọn',
                  color: AppColors.background,
                  onSelected: (value) {
                    if (value == 'open') {
                      onTap?.call();
                    } else if (value == 'remove') {
                      onRemove?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'open',
                      child: Row(
                        children: [
                          Icon(
                            Icons.open_in_new_rounded,
                            size: 18,
                            color: AppColors.iconPrimary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Xem chi tiết',
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(
                            Icons.bookmark_remove_outlined,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(width: 8),
                          Text('Bỏ lưu', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                  child: Container(
                    padding: EdgeInsets.all(5.rs(context)),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.42),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.more_horiz_rounded,
                      size: 18.rsp(context),
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
