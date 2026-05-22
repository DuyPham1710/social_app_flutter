import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/chat/data/services/recent_search_service.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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

  Future<void> _removeRecentSearch(String userId) async {
    await _recentSearchService.removeRecentSearch(userId);
    await _loadRecentSearches();
  }

  Future<void> _clearAllRecentSearches() async {
    // Show confirmation dialog
    final shouldClear = await showCupertinoDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          context.l10n.searchClearAllHistoryTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(context.l10n.searchClearAllHistoryConfirm),
        actions: [
          TextButton(
            child: Text(
              context.l10n.commonCancel,
              style: TextStyle(color: AppColors.textPrimary),
            ),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(context.l10n.searchClearAll),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (shouldClear == true) {
      await _recentSearchService.clearRecentSearches();
      await _loadRecentSearches();
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
          context.l10n.searchEditHistory,
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
              context.l10n.searchHistoryLocalOnlyDescription,
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
                  context.l10n.searchRecent,
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
                      context.l10n.searchClearAllUppercase,
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
                ? Center(
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
                          context.l10n.searchNoHistory,
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16.sp,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          context.l10n.searchHistoryWillAppear,
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
                          context.l10n.commonUnknown;
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
                            context.l10n.chatConnected,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                            ),
                          ),
                          trailing: GestureDetector(
                            onTap: () => _removeRecentSearch(userId),
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
