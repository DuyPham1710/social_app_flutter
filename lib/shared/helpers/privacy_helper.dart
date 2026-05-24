import 'package:flutter/cupertino.dart';

IconData getIcon(String label) {
  switch (label) {
    case 'Công khai':
      return CupertinoIcons.globe;
    case 'Bạn bè':
      return CupertinoIcons.person_2_fill;
    case 'Bạn bè ngoại trừ...':
      return CupertinoIcons.person_crop_circle_badge_minus;
    case 'Bạn bè cụ thể':
      return CupertinoIcons.person_crop_circle_badge_checkmark;
    case 'Chỉ mình tôi':
      return CupertinoIcons.lock_fill;
    default:
      return CupertinoIcons.person;
  }
}