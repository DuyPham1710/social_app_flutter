import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/data/services/recent_search_service.dart';

class RecentSearchManagementPage extends StatefulWidget {
  const RecentSearchManagementPage({super.key});

  @override
  State<RecentSearchManagementPage> createState() =>
      _RecentSearchManagementPageState();
}

class _RecentSearchManagementPageState
    extends State<RecentSearchManagementPage> {
  late RecentSearchService _recentSearchService;
  List<Map<String, dynamic>> _recentSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _recentSearchService = s1<RecentSearchService>();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    setState(() {
      _isLoading = true;
    });

    final recentSearches = await _recentSearchService.getRecentSearches();
    if (mounted) {
      setState(() {
        _recentSearches = recentSearches;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeRecentSearch(String userId, String name) async {
    await _recentSearchService.removeRecentSearch(userId);
    await _loadRecentSearches();

    // if (mounted) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text('Đã xóa $name khỏi lịch sử tìm kiếm'),
    //       duration: const Duration(seconds: 2),
    //     ),
    //   );
    // }
  }

  Future<void> _clearAllRecentSearches() async {
    // Show confirmation dialog
    final shouldClear = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Xóa tất cả lịch sử tìm kiếm',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm? Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            child: Text('Hủy', style: TextStyle(color: AppColors.textPrimary)),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Xóa tất cả'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await _recentSearchService.clearRecentSearches();
      await _loadRecentSearches();

      // if (mounted) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //       content: Text('Đã xóa tất cả lịch sử tìm kiếm'),
      //       duration: Duration(seconds: 2),
      //     ),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Chỉnh sửa lịch sử tìm kiếm',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            child: Text(
              'Các chi tiết thay đổi sẽ chỉ áp dụng cho danh sách tìm kiếm gần đây, thuộc phần lịch sử trên thiết bị này.',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ),

          // Recent searches header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tìm kiếm gần đây',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_recentSearches.isNotEmpty)
                  GestureDetector(
                    onTap: _clearAllRecentSearches,
                    child: Text(
                      'XÓA TẤT CẢ',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Recent searches list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : _recentSearches.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CupertinoIcons.search,
                          size: 64.sp,
                          color: AppColors.textSecondary.withOpacity(0.5),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Chưa có lịch sử tìm kiếm',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Các tìm kiếm gần đây sẽ xuất hiện ở đây',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: _recentSearches.length,
                    itemBuilder: (context, index) {
                      final searchData = _recentSearches[index];
                      final name =
                          searchData['fullName'] ??
                          searchData['username'] ??
                          'Unknown';
                      final avatarUrl = searchData['avatarUrl'];
                      final userId = searchData['userId'] ?? '';

                      return Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          leading: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                                avatarUrl != null && avatarUrl.isNotEmpty
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: avatarUrl == null || avatarUrl.isEmpty
                                ? Text(
                                    name.isNotEmpty
                                        ? name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  )
                                : null,
                          ),
                          title: Text(
                            name,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            'Đã kết nối',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => _removeRecentSearch(userId, name),
                            child: Container(
                              padding: EdgeInsets.all(8.w),
                              child: Icon(
                                CupertinoIcons.clear,
                                color: AppColors.textSecondary,
                                size: 24.sp,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
