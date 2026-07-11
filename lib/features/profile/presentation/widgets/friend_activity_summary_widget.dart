import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_activity_summary_cubit.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_activity_summary_state.dart';

import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/animated_post_border.dart';
import 'package:social_app_fe/l10n/generated/app_localizations.dart';
class FriendActivitySummaryWidget extends StatefulWidget {
  final String targetUserId;
  final String targetUserName;
  const FriendActivitySummaryWidget({
    super.key,
    required this.targetUserId,
    required this.targetUserName,
  });

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
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 12.rsh(context),
          ),
          child: AnimatedPostBorder(
            borderWidth: 1.5,
            borderRadius: 16,
            glowColor: AppColors.primary,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.background.withValues(alpha: 0.5),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.background.withValues(alpha: 0.1),
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
                                  child: Icon(
                                    Icons.auto_awesome_rounded,
                                    color: AppColors.iconPrimary,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 8.rs(context)),
                                Text(
                                  AppLocalizations.of(context).aiSummaryTitle(widget.targetUserName.trim().split(' ').last),
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
                        SizedBox(height: 6.rsh(context)),
                        Text(
                          AppLocalizations.of(context).aiSummarySubtitle(widget.targetUserName.trim().split(' ').last),
                          style: TextStyle(
                            fontSize: 13.rsp(context),
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 12.rsh(context)),
                        _buildContent(context, state),
                      ],
                    ),
                  ),
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
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(
              horizontal: 24.rs(context),
              vertical: 12.rsh(context),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 4,
            shadowColor: AppColors.primary.withValues(alpha: 0.4),
          ),
          icon: const Icon(Icons.auto_awesome_rounded, size: 20),
          label: Text(
            AppLocalizations.of(context).aiSummaryStartButton,
            style: TextStyle(
              fontSize: 15.rsp(context),
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
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     _buildStatBadge(
          //       context,
          //       AppLocalizations.of(context).aiSummaryPosts(state.summary.activities.postCount),
          //     ),
          //     _buildStatBadge(
          //       context,
          //       AppLocalizations.of(context).aiSummaryComments(state.summary.activities.commentCount),
          //     ),
          //     _buildStatBadge(
          //       context,
          //       AppLocalizations.of(context).aiSummaryReacts(state.summary.activities.reactCount),
          //     ),
          //     _buildStatBadge(
          //       context,
          //       AppLocalizations.of(context).aiSummaryStories(state.summary.activities.storyCount),
          //     ),
          //   ],
          // ),
          // SizedBox(height: 12.rsh(context)),
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
                AppLocalizations.of(context).aiSummaryDateRange(_selectedOptionTitle),
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
                AppLocalizations.of(context).aiSummarySelectDateRange,
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
              title: AppLocalizations.of(context).aiSummaryPast7Days,
              icon: Icons.date_range_rounded,
              onTap: () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 7));
                _applyFilter(context, AppLocalizations.of(context).aiSummaryPast7Days, startDate, endDate);
              },
            ),
            _buildFilterOption(
              context,
              title: AppLocalizations.of(context).aiSummaryPast30Days,
              icon: Icons.calendar_month_rounded,
              onTap: () {
                final endDate = DateTime.now();
                final startDate = endDate.subtract(const Duration(days: 30));
                _applyFilter(context, AppLocalizations.of(context).aiSummaryPast30Days, startDate, endDate);
              },
            ),
            _buildFilterOption(
              context,
              title: AppLocalizations.of(context).aiSummaryAllTime,
              icon: Icons.all_inclusive_rounded,
              onTap: () {
                _applyFilter(context, AppLocalizations.of(context).aiSummaryAllTime, null, null);
              },
            ),
            _buildFilterOption(
              context,
              title: AppLocalizations.of(context).aiSummaryCustomDate,
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
                        colorScheme: ColorScheme.fromSeed(
                          seedColor: AppColors.primary,
                          brightness: Theme.of(context).brightness,
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (picked != null && context.mounted) {
                  final String title =
                      AppLocalizations.of(context).aiSummaryCustomDateRange('${picked.start.day}/${picked.start.month}/${picked.start.year}', '${picked.end.day}/${picked.end.month}/${picked.end.year}');
                  setState(() {
                    _selectedOptionTitle = title;
                  });
                  context.read<FriendActivitySummaryCubit>().loadSummary(
                    widget.targetUserId,
                    startDate: picked.start.toIso8601String(),
                    endDate: picked.end.toIso8601String(),
                    language: AppLocalizations.of(context).localeName,
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
            backgroundColor: AppColors.background,
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
        backgroundColor: AppColors.background,
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
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary),
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
      language: AppLocalizations.of(context).localeName,
    );
  }
}
