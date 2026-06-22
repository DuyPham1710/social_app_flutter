import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/generated/app_localizations.dart';

class TagHelper {
  /// Hiển thị toàn bộ dòng: [Tên chủ bài] cùng với [Tên bạn bè]...
  static Widget buildTitleWithTags({
    required AppLocalizations l10n,
    required String ownerName,
    required List<String> taggedNames,
    String? location,
    TextStyle? boldStyle,
    TextStyle? normalStyle,
  }) {
    final bStyle =
        boldStyle ??
        TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: ResponsiveHelper.isWebOrDesktop ? 14 : 14.sp,
          color: AppColors.textPrimary,
        );

    final nStyle =
        normalStyle ??
        TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: ResponsiveHelper.isWebOrDesktop ? 14 : 14.sp,
          color: AppColors.textSecondary,
        );

    final int count = taggedNames.length;
    List<TextSpan> spans = [
      TextSpan(text: ownerName, style: bStyle),
    ];

    if (count == 1) {
      spans.addAll([
        TextSpan(text: ' '),
        TextSpan(text: l10n.postWith, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: taggedNames[0], style: bStyle),
      ]);
    } else if (count == 2) {
      spans.addAll([
        TextSpan(text: ' '),
        TextSpan(text: l10n.postWith, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: taggedNames[0], style: bStyle),
        TextSpan(text: ' '),
        TextSpan(text: l10n.postAnd, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: taggedNames[1], style: bStyle),
      ]);
    } else if (count > 2) {
      spans.addAll([
        TextSpan(text: ' '),
        TextSpan(text: l10n.postWith, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: taggedNames[0], style: bStyle),
        TextSpan(text: ' '),
        TextSpan(text: l10n.postAnd, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: l10n.postOtherPeople(count - 1), style: bStyle),
      ]);
    }

    if (location != null && location.isNotEmpty) {
      spans.addAll([
        TextSpan(text: ' '),
        TextSpan(text: l10n.postAtLocation, style: nStyle),
        TextSpan(text: ' '),
        TextSpan(text: location, style: bStyle),
      ]);
    }

    return RichText(text: TextSpan(children: spans));
  }

  /// Chỉ hiển thị phần thẻ: [Tên bạn bè 1] và [n người khác]
  static Widget buildTagsOnly({
    required AppLocalizations l10n,
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
          fontSize: ResponsiveHelper.isWebOrDesktop ? 14 : 14.sp,
          color: AppColors.textPrimary,
        );

    final nStyle =
        normalStyle ??
        TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: ResponsiveHelper.isWebOrDesktop ? 14 : 14.sp,
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
            TextSpan(text: ' '),
            TextSpan(text: l10n.postAnd, style: nStyle),
            TextSpan(text: ' '),
            TextSpan(text: taggedNames[1], style: bStyle),
          ],
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(text: taggedNames[0], style: bStyle),
          TextSpan(text: ' '),
          TextSpan(text: l10n.postAnd, style: nStyle),
          TextSpan(text: ' '),
          TextSpan(text: l10n.postOtherPeople(count - 1), style: bStyle),
        ],
      ),
    );
  }
}
