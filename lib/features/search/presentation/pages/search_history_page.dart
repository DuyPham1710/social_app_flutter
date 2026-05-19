import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_app_fe/features/search/presentation/widgets/search_history_item.dart';

class SearchHistoryPage extends StatelessWidget {
  const SearchHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _SearchHistoryPageContent();
  }
}

class _SearchHistoryPageContent extends StatefulWidget {
  const _SearchHistoryPageContent();

  @override
  State<_SearchHistoryPageContent> createState() =>
      _SearchHistoryPageContentState();
}

class _SearchHistoryPageContentState extends State<_SearchHistoryPageContent> {
  @override
  void initState() {
    super.initState();
    // Load toàn bộ lịch sử khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchBloc>().add(const LoadSearchHistory(limit: 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header với back button, title và "Xóa tất cả"
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  // Back button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      CupertinoIcons.back,
                      color: AppColors.iconPrimary,
                      size: 23.r,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: 8.w),
                  // Title
                  Expanded(
                    child: Text(
                      'Lịch sử',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  // Xóa tất cả button
                  BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      final hasHistory =
                          state is SearchInitial &&
                          state.history != null &&
                          state.history!.isNotEmpty;

                      if (!hasHistory) {
                        return const SizedBox.shrink();
                      }

                      // Lưu SearchBloc từ context cha
                      final searchBloc = context.read<SearchBloc>();

                      return TextButton(
                        onPressed: () {
                          _showClearAllDialog(context, searchBloc);
                        },
                        child: Text(
                          'Xóa tất cả',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Danh sách lịch sử
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    if (state.history != null && state.history!.isNotEmpty) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<SearchBloc>().add(
                            const LoadSearchHistory(limit: 100),
                          );
                        },
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: state.history!.length,
                          itemBuilder: (context, index) {
                            final historyItem = state.history![index];
                            return SearchHistoryItem(
                              history: historyItem,
                              showDeleteIcon: true,
                            );
                          },
                        ),
                      );
                    } else {
                      return _buildEmptyState();
                    }
                  } else if (state is SearchLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    return _buildEmptyState();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 64.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 16.h),
          Text(
            'Chưa có lịch sử tìm kiếm',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, SearchBloc searchBloc) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Xóa tất cả lịch sử',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa tất cả lịch sử tìm kiếm?',
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Hủy',
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Gọi event xóa tất cả
              searchBloc.add(const ClearAllSearchHistory());
            },
            child: Text(
              'Xóa',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
