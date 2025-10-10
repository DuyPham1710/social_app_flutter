import 'package:social_app_fe/core/enums/privacy_type.dart';

class PrivacyBase {
  final PrivacyType privacyType;
  final List<String> friendsExcept;
  final List<String> friendsDetail;

  const PrivacyBase({
    this.privacyType = PrivacyType.public,
    this.friendsExcept = const [],
    this.friendsDetail = const [],
  });
}