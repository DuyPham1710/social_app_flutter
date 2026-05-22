import 'package:flutter/material.dart';
import 'package:flutter_mentions/flutter_mentions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class MentionEditableField extends StatefulWidget {
  final GlobalKey<FlutterMentionsState> mentionKey;
  final List<Map<String, dynamic>> suggestionList;
  final String? initialMarkup;
  final String hintText;

  const MentionEditableField({
    super.key,
    required this.mentionKey,
    required this.suggestionList,
    this.initialMarkup,
    required this.hintText,
  });

  @override
  State<MentionEditableField> createState() => _MentionEditableFieldState();
}

class _MentionEditableFieldState extends State<MentionEditableField> {
  late Mention _mentionConfig;

  @override
  void initState() {
    super.initState();

    // Cấu hình Mention
    _mentionConfig = Mention(
      trigger: '@',
      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      data: widget.suggestionList,
      matchAll: false,
      markupBuilder: (trigger, value, display) {
        return '@[$display]($value)';
      },
      suggestionBuilder: (data) {
        return Material(
          color: AppColors.background,
          child: InkWell(
            onTap: () {
              widget.mentionKey.currentState!.addMention(data);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18.r,
                    backgroundColor: AppColors.secondBackground,
                    backgroundImage: NetworkImage(
                      data['photo'] ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['display'],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                        Text(
                          '@${data['full_name']}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initFromMarkup();
    });
  }

  void _initFromMarkup() {
    if (widget.initialMarkup == null || widget.initialMarkup!.isEmpty) return;

    final state = widget.mentionKey.currentState;
    if (state == null) return;

    final controller = state.controller!;
    controller.clear();

    // Regex chuẩn cho dữ liệu: @[Name](ID)
    final regex = RegExp(r'@\[([^\]]+)\]\(([^)]+)\)');
    final matches = regex.allMatches(widget.initialMarkup!);

    int lastIndex = 0;

    for (final match in matches) {
      // 1. Thêm text thường nằm trước mention
      if (match.start > lastIndex) {
        controller.text += widget.initialMarkup!.substring(
          lastIndex,
          match.start,
        );
      }

      // Thêm thủ công dấu '@' để thư viện có cái mà replace
      controller.text += '@';

      // Cập nhật con trỏ về ngay sau dấu '@'
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );

      // Gọi addMention (Thư viện sẽ tìm dấu '@' trước con trỏ và thay thế nó)
      state.addMention({
        'id': match.group(2) ?? '', // ID
        'display': match.group(1) ?? '', // Name
        'full_name': match.group(1) ?? '',
        'photo': '',
      }, _mentionConfig);

      lastIndex = match.end;
    }

    if (lastIndex < widget.initialMarkup!.length) {
      controller.text += widget.initialMarkup!.substring(lastIndex);
    }

    // Đưa con trỏ về cuối
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.divider),
      ),
      child: FlutterMentions(
        key: widget.mentionKey,
        suggestionPosition: SuggestionPosition.Bottom,
        maxLines: 10,
        minLines: 1,
        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
        cursorColor: AppColors.primary,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(12.w),
        ),
        mentions: [_mentionConfig],
      ),
    );
  }
}
