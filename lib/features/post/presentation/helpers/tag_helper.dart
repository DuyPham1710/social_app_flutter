import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class TagHelper {
  /// Hiển thị toàn bộ dòng: [Tên chủ bài] cùng với [Tên bạn bè]...
  static Widget buildTitleWithTags({
    required String ownerName,
    required List<String> taggedNames,
    TextStyle? boldStyle,
    TextStyle? normalStyle,
  }) {
    final bStyle =
        boldStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        );

    final nStyle =
        normalStyle ??
        TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        );

    final int count = taggedNames.length;

    if (count == 0) {
      return Text(ownerName, style: bStyle);
    }

    if (count == 1) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: ownerName, style: bStyle),
            TextSpan(text: ' cùng với ', style: nStyle),
            TextSpan(text: taggedNames[0], style: bStyle),
          ],
        ),
      );
    }

    if (count == 2) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: ownerName, style: bStyle),
            TextSpan(text: ' cùng với ', style: nStyle),
            TextSpan(text: taggedNames[0], style: bStyle),
            TextSpan(text: ' và ', style: nStyle),
            TextSpan(text: taggedNames[1], style: bStyle),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: ownerName, style: bStyle),
          TextSpan(text: ' cùng với ', style: nStyle),
          TextSpan(text: taggedNames[0], style: bStyle),
          TextSpan(text: ' và ', style: nStyle),
          TextSpan(text: '${count - 1} người khác', style: bStyle),
        ],
      ),
    );
  }

  /// Chỉ hiển thị phần thẻ: [Tên bạn bè 1] và [n người khác]
  static Widget buildTagsOnly({
    required List<String> taggedNames,
    TextStyle? boldStyle,
    TextStyle? normalStyle,
  }) {
    final int count = taggedNames.length;
    if (count == 0) return const SizedBox.shrink();

    final bStyle =
        boldStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
          color: AppColors.textPrimary,
        );

    final nStyle =
        normalStyle ??
        TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        );

    if (count == 1) {
      return Text(taggedNames[0], style: bStyle);
    }

    if (count == 2) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: taggedNames[0], style: bStyle),
            TextSpan(text: ' và ', style: nStyle),
            TextSpan(text: taggedNames[1], style: bStyle),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: taggedNames[0], style: bStyle),
          TextSpan(text: ' và ', style: nStyle),
          TextSpan(text: '${count - 1} người khác', style: bStyle),
        ],
      ),
    );
  }
}
