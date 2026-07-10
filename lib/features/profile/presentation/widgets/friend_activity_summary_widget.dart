import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_activity_summary_cubit.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_activity_summary_state.dart';

class FriendActivitySummaryWidget extends StatefulWidget {
  final String targetUserId;

  const FriendActivitySummaryWidget({super.key, required this.targetUserId});

  @override
  State<FriendActivitySummaryWidget> createState() =>
      _FriendActivitySummaryWidgetState();
}

class _FriendActivitySummaryWidgetState
    extends State<FriendActivitySummaryWidget> {
  String _selectedOptionTitle = '';

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FriendActivitySummaryCubit, FriendActivitySummaryState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 12.rsh(context),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                const Color(0xFF6366F1).withValues(alpha: 0.15),
                const Color(0xFF8B5CF6).withValues(alpha: 0.15),
                const Color(0xFFD946EF).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Padding(
                padding: EdgeInsets.all(16.rs(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color(0xFF8B5CF6),
                                size: 20,
                              ),
                            ),
                            SizedBox(width: 8.rs(context)),
                            Text(
                              'AI Tóm Tắt Hoạt Động',
                              style: TextStyle(
                                fontSize: 16.rsp(context),
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ],
                        ),
                        if (state is! FriendActivitySummaryInitial)
                          GestureDetector(
                            onTap: () => _showFilterOptions(context),
                            child: Icon(
                              Icons.tune_rounded,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 12.rsh(context)),
                    _buildContent(context, state),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, FriendActivitySummaryState state) {
    if (state is FriendActivitySummaryInitial) {
      return Center(
        child: ElevatedButton.icon(
          onPressed: () => _showFilterOptions(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8B5CF6),
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 16.rs(context),
              vertical: 10.rsh(context),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.analytics_rounded, size: 18),
          label: Text(
            'Xem tóm tắt hoạt động',
            style: TextStyle(
              fontSize: 14.rsp(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    } else if (state is FriendActivitySummaryLoading) {
      return Shimmer.fromColors(
        baseColor: AppColors.divider.withValues(alpha: 0.5),
        highlightColor: AppColors.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 14.rsh(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 8.rsh(context)),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: 14.rsh(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            SizedBox(height: 8.rsh(context)),
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 14.rsh(context),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      );
    } else if (state is FriendActivitySummaryLoaded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatBadge(
                context,
                '${state.summary.activities.postCount} Bài viết',
              ),
              _buildStatBadge(
                context,
                '${state.summary.activities.commentCount} Bình luận',
              ),
              _buildStatBadge(
                context,
                '${state.summary.activities.reactCount} Cảm xúc',
              ),
              _buildStatBadge(
                context,
                '${state.summary.activities.storyCount} Story',
              ),
            ],
          ),
          SizedBox(height: 12.rsh(context)),
          Text(
            state.summary.summary,
            style: TextStyle(
              fontSize: 14.rsp(context),
              height: 1.5,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_selectedOptionTitle.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 8.rsh(context)),
              child: Text(
                'Khoảng thời gian: $_selectedOptionTitle',
                style: TextStyle(
                  fontSize: 12.rsp(context),
                  color: AppColors.textSecondary.withValues(alpha: 0.7),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      );
    } else if (state is FriendActivitySummaryError) {
      return Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 18,
          ),
          SizedBox(width: 6.rs(context)),
          Expanded(
            child: Text(
              state.message,
              style: TextStyle(
                fontSize: 13.rsp(context),
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildStatBadge(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.rs(context),
        vertical: 4.rsh(context),
      ),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11.rsp(context),
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  void _showFilterOptions(BuildContext context) {
    final Widget filterContent = SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.rsh(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.rs(context)),
              child: Text(
                'Chọn khoảng thời gian',
                style: TextStyle(
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            SizedBox(height: 12.rsh(context)),
            _buildFilterOption(
              context,
              title: '7 ngày qua',
              icon: Icons.date_range_rounded,
              onTap: () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 7));
                _applyFilter(context, '7 ngày qua', startDate, endDate);
              },
            ),
            _buildFilterOption(
              context,
              title: '30 ngày qua',
              icon: Icons.calendar_month_rounded,
              onTap: () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 30));
                _applyFilter(context, '30 ngày qua', startDate, endDate);
              },
            ),
            _buildFilterOption(
              context,
              title: 'Tất cả thời gian',
              icon: Icons.all_inclusive_rounded,
              onTap: () {
                _applyFilter(context, 'Tất cả thời gian', null, null);
              },
            ),
            _buildFilterOption(
              context,
              title: 'Tùy chọn ngày...',
              icon: Icons.edit_calendar_rounded,
              onTap: () async {
                Navigator.pop(context); // close modal/dialog first
                final DateTimeRange? picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: Theme.of(context).colorScheme.copyWith(
                              primary: const Color(0xFF8B5CF6),
                            ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && context.mounted) {
                  final String title =
                      'Từ ${picked.start.day}/${picked.start.month}/${picked.start.year} đến ${picked.end.day}/${picked.end.month}/${picked.end.year}';
                  setState(() {
                    _selectedOptionTitle = title;
                  });
                  context.read<FriendActivitySummaryCubit>().loadSummary(
                    widget.targetUserId,
                    startDate: picked.start.toIso8601String(),
                    endDate: picked.end.toIso8601String(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );

    if (kIsWeb) {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: filterContent,
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) => filterContent,
      );
    }
  }

  Widget _buildFilterOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF8B5CF6)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15.rsp(context),
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      onTap: onTap,
    );
  }

  void _applyFilter(
    BuildContext context,
    String title,
    DateTime? startDate,
    DateTime? endDate,
  ) {
    Navigator.pop(context);
    setState(() {
      _selectedOptionTitle = title;
    });
    context.read<FriendActivitySummaryCubit>().loadSummary(
      widget.targetUserId,
      startDate: startDate?.toIso8601String(),
      endDate: endDate?.toIso8601String(),
    );
  }
}
