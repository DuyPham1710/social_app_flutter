import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';

class RecentSearchService {
  static const String _recentSearchKey = 'recent_search_friends';
 // static const int _maxRecentSearches = 10; // Giới hạn tối đa 10 tìm kiếm gần đây

  /// Lưu một friend vào danh sách tìm kiếm gần đây
  Future<void> saveRecentSearch(FriendEntity friend) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recentSearches = await getRecentSearches();
      
      // Tạo map từ friend entity
      final friendMap = {
        'userId': friend.userId,
        'fullName': friend.fullName,
        'username': friend.username,
        'avatarUrl': friend.avatarUrl,
      };
      
      // Xóa friend này nếu đã tồn tại (để đưa lên đầu)
      recentSearches.removeWhere((item) => item['userId'] == friend.userId);
      
      // Thêm vào đầu danh sách
      recentSearches.insert(0, friendMap);
      
      // Giới hạn số lượng
      // if (recentSearches.length > _maxRecentSearches) {
      //   recentSearches.removeRange(_maxRecentSearches, recentSearches.length);
      // }
      
      // Lưu vào SharedPreferences
      final jsonString = jsonEncode(recentSearches);
      await prefs.setString(_recentSearchKey, jsonString);
    } catch (e) {
      print('Error saving recent search: $e');
    }
  }

  /// Lấy danh sách tìm kiếm gần đây
  Future<List<Map<String, dynamic>>> getRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_recentSearchKey);
      
      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }
      
      final List<dynamic> decoded = jsonDecode(jsonString);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error loading recent searches: $e');
      return [];
    }
  }

  /// Xóa tất cả tìm kiếm gần đây
  Future<void> clearRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_recentSearchKey);
    } catch (e) {
      print('Error clearing recent searches: $e');
    }
  }

  /// Xóa một tìm kiếm cụ thể
  Future<void> removeRecentSearch(String userId) async {
    try {
      final recentSearches = await getRecentSearches();
      recentSearches.removeWhere((item) => item['userId'] == userId);
      
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(recentSearches);
      await prefs.setString(_recentSearchKey, jsonString);
    } catch (e) {
      print('Error removing recent search: $e');
    }
  }
}
