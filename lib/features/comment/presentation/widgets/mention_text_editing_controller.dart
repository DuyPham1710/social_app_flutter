import 'package:flutter/material.dart';

/// Một TextEditingController tùy chỉnh để style các "mention" (ví dụ: @JohnDoe)
/// một cách khác biệt so với văn bản thông thường.
class MentionTextEditingController extends TextEditingController {
  final TextStyle mentionStyle;

  MentionTextEditingController({required this.mentionStyle});

  /// Regex để tìm các mention.
  /// Mẫu này tìm một ký tự "@" theo sau là một hoặc nhiều chữ cái,
  /// số, dấu gạch dưới, hoặc dấu cách, kết thúc tại một ranh giới từ.
  /// (ví dụ: "@John Doe" hoặc "@username")
  // DÒNG MỚI (ĐÃ SỬA):
  // DÒNG CŨ (BỊ LỖI):
  static final RegExp _mentionRegex = RegExp(
    r"(@[a-zA-Z0-9\s_]+)\b",
    unicode: true,
  );

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final List<TextSpan> children = [];
    final matches = _mentionRegex.allMatches(text);

    int lastMatchEnd = 0;

    for (final Match match in matches) {
      //Thêm văn bản thông thường NẰM TRƯỚC mention
      if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style, // Dùng style mặc định
          ),
        );
      }

      // Thêm văn bản mention VỚI STYLE ĐẶC BIỆT
      children.add(
        TextSpan(
          text: text.substring(match.start, match.end),
          style: style?.merge(
            mentionStyle,
          ), // Trộn style mặc định với style mention
        ),
      );

      lastMatchEnd = match.end;
    }

    // Thêm bất kỳ văn bản thông thường nào CÒN LẠI sau mention cuối cùng
    if (lastMatchEnd < text.length) {
      children.add(TextSpan(text: text.substring(lastMatchEnd), style: style));
    }

    // Trả về một TextSpan duy nhất chứa tất cả các phần
    return TextSpan(style: style, children: children);
  }
}
