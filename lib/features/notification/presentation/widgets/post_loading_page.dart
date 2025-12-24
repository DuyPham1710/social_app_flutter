import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostLoadingPage extends StatelessWidget {
  const PostLoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Bar giả (Khớp với nút back và tên tiêu đề)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // Giả lập nút Back
                    _buildBox(width: 30, height: 30, radius: 8),
                    const SizedBox(width: 60), // Khoảng cách tới title
                    // Giả lập Title chính giữa/phía sau
                    _buildBox(width: 150, height: 24, radius: 8),
                  ],
                ),
              ),
              const Divider(thickness: 1, color: Colors.white), // Đường kẻ mờ

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 2. Header: Avatar + Tên người đăng
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBox(width: 160, height: 16, radius: 10),
                            const SizedBox(height: 8),
                            _buildBox(width: 100, height: 12, radius: 10),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // 3. Text lines (Nội dung ngắn)
                    _buildBox(width: double.infinity, height: 14, radius: 10),
                    const SizedBox(height: 8),
                    _buildBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: 14,
                      radius: 10,
                    ),
                    const SizedBox(height: 16),

                    // 4. Post Body (Khung ảnh)
                    _buildBox(width: double.infinity, height: 250, radius: 15),
                    const SizedBox(height: 20),

                    // 5. Action Buttons (Like, Comment, Share)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildBox(width: 85, height: 35, radius: 20),
                        _buildBox(width: 85, height: 35, radius: 20),
                        _buildBox(width: 85, height: 35, radius: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ],
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
