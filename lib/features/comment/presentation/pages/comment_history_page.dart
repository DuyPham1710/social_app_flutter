import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart'; // Import this
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/comment/domain/entities/comment-log_entity.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_bloc.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_event.dart';
import 'package:social_app_fe/features/comment/presentation/bloc/comment_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentHistoryPage extends StatefulWidget {
  final String commentId;
  final String currentContent;

  const CommentHistoryPage({
    super.key,
    required this.commentId,
    required this.currentContent,
  });

  @override
  State<CommentHistoryPage> createState() => _CommentHistoryPageState();
}

class _CommentHistoryPageState extends State<CommentHistoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommentBloc>().add(
      LoadCommentHistoryEvent(commentId: widget.commentId),
    );
  }

  // Helper method to build ParsedText for mentions
  Widget _buildParsedText(String text, {Color? textColor}) {
    return ParsedText(
      text: text,
      style: TextStyle(
        fontSize: 14.sp,
        color: textColor ?? AppColors.textPrimary,
      ),
      parse: [
        MatchText(
          // Regex: @[Name](ID)
          pattern: r"@\[([^\]]+)\]\(([^)]+)\)",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          renderText: ({required String str, required String pattern}) {
            final match = RegExp(pattern).firstMatch(str);
            return {
              'display': match?.group(2) ?? '',
              'value': match?.group(1) ?? '',
            };
          },
          onTap: (userId) {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.textPrimary,
            size: 18.sp,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          context.l10n.commentEditHistoryTitle,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<CommentBloc, CommentState>(
        builder: (context, state) {
          if (state is CommentHistoryLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is CommentHistoryError) {
            return _displayError(state, context);
          }

          if (state is CommentHistoryLoaded) {
            final history = state.commentHistory.history;

            if (history.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64.sp,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      context.l10n.commentNoEditHistory,
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Current version header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  margin: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppColors.primary,
                            size: 18.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            context.l10n.commentCurrentVersion,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      // --- USE PARSED TEXT HERE ---
                      _buildParsedText(widget.currentContent),
                    ],
                  ),
                ),

                // History list
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: history.length,
                    itemBuilder: (context, index) {
                      final historyItem = history[index];
                      return _buildHistoryItem(historyItem, index);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Center _displayError(CommentHistoryError state, BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.h),
          Text(
            context.l10n.commonErrorOccurred,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            state.message,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<CommentBloc>().add(
                LoadCommentHistoryEvent(commentId: widget.commentId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              context.l10n.commonRetry,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(CommentLogEntity historyItem, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with user info and time
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundImage: historyItem.editedBy.avatarUrl != null
                    ? NetworkImage(historyItem.editedBy.avatarUrl!)
                    : null,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: historyItem.editedBy.avatarUrl == null
                    ? Text(
                        historyItem.editedBy.fullName
                                ?.substring(0, 1)
                                .toUpperCase() ??
                            'U',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      )
                    : null,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      historyItem.editedBy.fullName ??
                          context.l10n.commonUnknown,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      context.l10n.commentEditVersion(
                        index + 1,
                        historyItem.createdAt != null
                            ? timeago.format(historyItem.createdAt!)
                            : context.l10n.postUnknownTime,
                      ),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Old content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      color: Colors.red,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      context.l10n.commentOldContent,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                // --- USE PARSED TEXT HERE ---
                _buildParsedText(historyItem.oldContent),
              ],
            ),
          ),

          SizedBox(height: 8.h),

          // New content
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                      size: 16.sp,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      context.l10n.commentNewContent,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                // --- USE PARSED TEXT HERE ---
                _buildParsedText(historyItem.newContent),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
