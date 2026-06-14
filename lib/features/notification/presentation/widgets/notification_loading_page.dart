import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class NotificationLoadingPage extends StatelessWidget {
  const NotificationLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = s1<AppPreferences>().isDarkMode;
    return Container(
      color: AppColors.background,

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: Shimmer.fromColors(
              baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDarkMode
                  ? Colors.grey[700]!
                  : Colors.grey[100]!,
              child: ListView.builder(
                itemCount: 8, // Show 8 skeleton items
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name line
                              _buildBox(
                                width: double.infinity,
                                height: 16,
                                radius: 8,
                              ),
                              const SizedBox(height: 8),
                              // Message line 1
                              _buildBox(
                                width: double.infinity,
                                height: 14,
                                radius: 8,
                              ),
                              const SizedBox(height: 6),
                              // Message line 2
                              _buildBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                height: 14,
                                radius: 8,
                              ),
                              const SizedBox(height: 8),
                              // Time
                              _buildBox(width: 80, height: 12, radius: 8),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Icon overlay placeholder
                        _buildBox(width: 24, height: 24, radius: 12),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required double width,
    required double height,
    required double radius,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
