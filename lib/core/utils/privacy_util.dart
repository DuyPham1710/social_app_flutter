import 'package:social_app_fe/core/enums/privacy_type.dart';

class PrivacyUtil {
  static String privacyTypeToLabel(PrivacyType privacyType) {
    switch (privacyType) {
      case PrivacyType.public:
        return 'Công khai';
      case PrivacyType.friends:
        return 'Bạn bè';
      case PrivacyType.friendsExcept:
        return 'Bạn bè ngoại trừ...';
      case PrivacyType.friendsDetail:
        return 'Bạn bè cụ thể';
      case PrivacyType.private:
        return 'Chỉ mình tôi';
    }
  }

  // Helper method để convert label thành PrivacyType
  static PrivacyType labelToPrivacyType(String label) {
    switch (label) {
      case 'Công khai':
        return PrivacyType.public;
      case 'Bạn bè':
        return PrivacyType.friends;
      case 'Bạn bè ngoại trừ...':
        return PrivacyType.friendsExcept;
      case 'Bạn bè cụ thể':
        return PrivacyType.friendsDetail;
      case 'Chỉ mình tôi':
        return PrivacyType.private;
      default:
        return PrivacyType.public;
    }
  }
}
