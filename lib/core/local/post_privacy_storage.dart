import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PostPrivacyStorage {
  static const _privacyKey = 'post_privacy';
  static const _hiddenFriendIdsKey = 'post_hidden_friend_ids';
  static const _allowedFriendIdsKey = 'post_allowed_friend_ids';

  /// Lưu quyền riêng tư đã chọn
  static Future<void> savePrivacy(String privacy) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_privacyKey, privacy);
  }

  /// Lấy quyền riêng tư đã lưu
  static Future<String?> getPrivacy() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_privacyKey);
  }

  /// Lưu danh sách ID bạn bè bị ẩn
  static Future<void> saveHiddenFriendIds(List<String> friendIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_hiddenFriendIdsKey, friendIds);
  }

  /// Lấy danh sách ID bạn bè bị ẩn
  static Future<List<String>> getHiddenFriendIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_hiddenFriendIdsKey) ?? [];
  }

  /// Lưu danh sách ID bạn bè được phép xem (Tùy chỉnh)
  static Future<void> saveAllowedFriendIds(List<String> friendIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_allowedFriendIdsKey, friendIds);
  }

  /// Lấy danh sách ID bạn bè được phép xem (Tùy chỉnh)
  static Future<List<String>> getAllowedFriendIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_allowedFriendIdsKey) ?? [];
  }

  /// Xóa tất cả cài đặt quyền riêng tư (khi logout)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_privacyKey);
    await prefs.remove(_hiddenFriendIdsKey);
    await prefs.remove(_allowedFriendIdsKey);
  }
}

