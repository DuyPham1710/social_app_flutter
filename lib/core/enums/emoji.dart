enum EmojiType {
  like('Thích', '👍'),
  love('Yêu thích', '❤️'),
  haha('Haha', '😂'),
  wow('Wow', '😮'),
  sad('Buồn', '😢'),
  angry('Phẫn nộ', '😡');

  final String label;
  final String icon;

  const EmojiType(this.label, this.icon);

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
