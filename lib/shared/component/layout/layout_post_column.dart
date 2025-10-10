import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutPostColumn extends StatelessWidget {
  final List<dynamic> urls;
  final Function(int) onImageTap;

  const LayoutPostColumn({
    super.key,
    required this.urls,
    required this.onImageTap,
  });

  List<dynamic> get sortedUrls {
    final List<dynamic> sorted = List.from(urls);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    final orderedUrls = sortedUrls;

    // Layout ngang - mỗi ảnh 1 cột
    final maxImages = orderedUrls.length > 4 ? 4 : orderedUrls.length;

    if (orderedUrls.length == 1) {
      // 1 hình: hiển thị bình thường
      return GestureDetector(
        onTap: () => onImageTap(0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              orderedUrls[0].url,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 280.h, // Chiều cao cố định cho container, ảnh sẽ to hơn
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (int i = 0; i < maxImages; i++) ...[
            // Khoảng cách giữa các ảnh
            if (i > 0) SizedBox(width: 4.w),

            Expanded(child: _buildColumnImage(i, orderedUrls)),
          ],
        ],
      ),
    );
  }

  Widget _buildColumnImage(int index, List<dynamic> orderedUrls) {
    // Tạo hiệu ứng staggered từ 3 ảnh trở lên - chỉ dịch lên xuống
    double topPadding = 0;
    double bottomPadding = 0;

    if (orderedUrls.length >= 3) {
      // Tạo pattern staggered: dịch lên xuống theo index
      switch (index % 4) {
        case 0:
          topPadding = 0;
          bottomPadding = 30.h;
        case 1:
          topPadding = 10.h;
          bottomPadding = 0;
        case 2:
          topPadding = 0.h;
          bottomPadding = 30.h;
        case 3:
          topPadding = 10.h;
          bottomPadding = 0;
      }
    }

    Widget imageWidget = GestureDetector(
      onTap: () => onImageTap(index),
      child: SizedBox(
        height: 250.h, // Chiều cao cố định cho ảnh, ảnh sẽ to và có thể bị cắt
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            orderedUrls[index].url,
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
      ),
    );

    // Nếu là ảnh thứ 4 và còn nhiều hơn 4 ảnh => overlay
    if (index == 3 && orderedUrls.length > 4) {
      final remaining = orderedUrls.length - 4;
      imageWidget = GestureDetector(
        onTap: () => onImageTap(index),
        child: SizedBox(
          height: 250.h, // Giống kích thước ảnh bình thường
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.network(
                  orderedUrls[index].url,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  '+$remaining',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
      child: imageWidget,
    );
  }
}
