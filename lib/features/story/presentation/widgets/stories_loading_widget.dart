import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class StoriesLoadingWidget extends StatelessWidget {
  const StoriesLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.rs(context),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 12.rs(context),
          vertical: 8.rsh(context),
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildAddStoryLoading(context);
          }
          return _buildStoryLoadingItem(context);
        },
        separatorBuilder: (_, __) => SizedBox(width: 12.rs(context)),
        itemCount: 6, // Add story + 5 story items
      ),
    );
  }

  Widget _buildAddStoryLoading(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80.rs(context),
          height: 120.rs(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.rsr(context)),
            color: AppColors.secondBackground,
          ),
        ),
        SizedBox(height: 30.rsh(context)),
        Container(
          width: 60.rs(context),
          height: 12.rsh(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.rsr(context)),
            color: AppColors.secondBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildStoryLoadingItem(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: 80.rs(context),
              height: 120.rs(context),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.rsr(context)),
                color: AppColors.secondBackground,
              ),
            ),
            // Avatar loading
            Positioned(
              bottom: -18.rsh(context),
              child: Container(
                width: 36.rs(context),
                height: 36.rs(context),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.divider,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.rsh(context)),
        Container(
          width: 60.rs(context),
          height: 12.rsh(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.rsr(context)),
            color: AppColors.secondBackground,
          ),
        ),
      ],
    );
  }
}
