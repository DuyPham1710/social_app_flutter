import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/local/app_preferences.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class PostLoadingPage extends StatelessWidget {
  const PostLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = s1<AppPreferences>().isDarkMode;
    final double textLineWidth = ResponsiveHelper.isWebOrDesktop
        ? (ResponsiveHelper.feedMaxWidth * 0.7)
        : (MediaQuery.of(context).size.width * 0.7);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveHelper.feedMaxWidth,
            ),
            child: Shimmer.fromColors(
              baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor: isDarkMode
                  ? Colors.grey[700]!
                  : Colors.grey[100]!,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Top Bar giả (Khớp với nút back và tên tiêu đề)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.rs(context),
                      vertical: 10.rsh(context),
                    ),
                    child: Row(
                      children: [
                        // Giả lập nút Back
                        _buildBox(
                          context,
                          width: 30.rs(context),
                          height: 30.rsh(context),
                          radius: 8.rsr(context),
                        ),
                        SizedBox(
                          width: 60.rs(context),
                        ), // Khoảng cách tới title
                        // Giả lập Title chính giữa/phía sau
                        _buildBox(
                          context,
                          width: 150.rs(context),
                          height: 24.rsh(context),
                          radius: 8.rsr(context),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.white,
                  ), // Đường kẻ mờ

                  Padding(
                    padding: EdgeInsets.all(16.rs(context)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 2. Header: Avatar + Tên người đăng
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25.rsr(context),
                              backgroundColor: Colors.white,
                            ),
                            SizedBox(width: 12.rs(context)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildBox(
                                  context,
                                  width: 160.rs(context),
                                  height: 16.rsh(context),
                                  radius: 10.rsr(context),
                                ),
                                SizedBox(height: 8.rsh(context)),
                                _buildBox(
                                  context,
                                  width: 100.rs(context),
                                  height: 12.rsh(context),
                                  radius: 10.rsr(context),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20.rsh(context)),

                        // 3. Text lines (Nội dung ngắn)
                        _buildBox(
                          context,
                          width: double.infinity,
                          height: 14.rsh(context),
                          radius: 10.rsr(context),
                        ),
                        SizedBox(height: 8.rsh(context)),
                        _buildBox(
                          context,
                          width: textLineWidth,
                          height: 14.rsh(context),
                          radius: 10.rsr(context),
                        ),
                        SizedBox(height: 16.rsh(context)),

                        // 4. Post Body (Khung ảnh)
                        _buildBox(
                          context,
                          width: double.infinity,
                          height: 250.rsh(context),
                          radius: 15.rsr(context),
                        ),
                        SizedBox(height: 20.rsh(context)),

                        // 5. Action Buttons (Like, Comment, Share)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBox(
                              context,
                              width: 85.rs(context),
                              height: 35.rsh(context),
                              radius: 20.rsr(context),
                            ),
                            _buildBox(
                              context,
                              width: 85.rs(context),
                              height: 35.rsh(context),
                              radius: 20.rsr(context),
                            ),
                            _buildBox(
                              context,
                              width: 85.rs(context),
                              height: 35.rsh(context),
                              radius: 20.rsr(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBox(
    BuildContext context, {
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
