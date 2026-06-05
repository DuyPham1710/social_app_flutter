import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class PostsLoadingWidget extends StatelessWidget {
  const PostsLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => _buildPostLoadingItem(context)),
    );
  }

  Widget _buildPostLoadingItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      padding: EdgeInsets.all(16.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(
          color: AppColors.divider.withValues(alpha: 0.85),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12.rsr(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: Offset(0, 3.rsh(context)),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: Offset(0, 1.rsh(context)),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and name
          Row(
            children: [
              Container(
                width: 40.rs(context),
                height: 40.rs(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.textSecondary.withValues(alpha: 0.3),
                ),
              ),
              SizedBox(width: 12.rs(context)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 120.rs(context),
                      height: 16.rsh(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.rsr(context)),
                        color: AppColors.textSecondary.withValues(alpha: 0.3),
                      ),
                    ),
                    SizedBox(height: 4.rsh(context)),
                    Container(
                      width: 80.rs(context),
                      height: 12.rsh(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.rsr(context)),
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.rsh(context)),

          // Post content
          Container(
            width: double.infinity,
            height: 14.rsh(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.rsr(context)),
              color: AppColors.textSecondary.withValues(alpha: 0.2),
            ),
          ),
          SizedBox(height: 8.rsh(context)),
          Container(
            width: 250.rs(context),
            height: 14.rsh(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.rsr(context)),
              color: AppColors.textSecondary.withValues(alpha: 0.2),
            ),
          ),
          SizedBox(height: 12.rsh(context)),

          // Post image placeholder
          Container(
            width: double.infinity,
            height: 200.rsh(context),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.rsr(context)),
              color: AppColors.textSecondary.withValues(alpha: 0.2),
            ),
          ),
          SizedBox(height: 12.rsh(context)),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              3,
              (index) => Container(
                width: 60.rs(context),
                height: 32.rsh(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.rsr(context)),
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
