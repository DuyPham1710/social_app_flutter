enum EmojiType {
  like('671fdc000000000000000001', 'Thích', '👍🏻'),
  love('671fdc000000000000000002', 'Yêu thích', '❤️'),
  haha('671fdc000000000000000003', 'Haha', '😆'),
  wow('671fdc000000000000000004', 'Wow', '😮'),
  sad('671fdc000000000000000005', 'Buồn', '😢'),
  angry('671fdc000000000000000006', 'Phẫn nộ', '😡');

  final String id;
  final String label;
  final String icon;

  const EmojiType(this.id, this.label, this.icon);

  static EmojiType fromLabel(String label) {
    return EmojiType.values.firstWhere(
      (e) => e.label == label,
      orElse: () => EmojiType.like,
    );
  }

  String get lottieAsset {
    switch (this) {
      case EmojiType.like:
        return 'animations/emoji/like_animation.json';
      case EmojiType.love:
        return 'animations/emoji/love_animation.json';
      case EmojiType.haha:
        return 'animations/emoji/haha_animation.json';
      case EmojiType.wow:
        return 'animations/emoji/wow_animation.json';
      case EmojiType.sad:
        return 'animations/emoji/cry_animation.json';
      case EmojiType.angry:
        return 'animations/emoji/angry_animation.json';
    }
  }
}
