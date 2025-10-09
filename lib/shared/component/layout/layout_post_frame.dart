import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutPostFrame extends StatelessWidget {
  final List<dynamic> urls;

  const LayoutPostFrame({super.key, required this.urls});

  List<dynamic> get sortedUrls {
    final List<dynamic> sorted = List.from(urls);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  // Bộ màu pastel dễ nhìn cho background
  static final List<Color> _frameColors = [
    Color(0xFFFFE5E5), // Pastel Pink
    Color(0xFFE5F3FF), // Pastel Blue
    Color(0xFFE5FFE5), // Pastel Green
    Color(0xFFFFF5E5), // Pastel Orange
    Color(0xFFF5E5FF), // Pastel Purple
    Color(0xFFFFFFE5), // Pastel Yellow
    Color(0xFFFFE5F5), // Pastel Rose
    Color(0xFFE5FFFF), // Pastel Cyan
    Color(0xFFFFF0E5), // Pastel Peach
    Color(0xFFE5F0FF), // Pastel Sky
  ];

  Color get randomFrameColor {
    // Sử dụng hash của URLs để đảm bảo cùng 1 post luôn có cùng màu
    final seed = urls.map((e) => e.url).join().hashCode;
    final index = seed.abs() % _frameColors.length;
    return _frameColors[index];
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    final orderedUrls = sortedUrls;

    return _buildFrameLayout(orderedUrls);
  }

  Widget _buildFrameLayout(List<dynamic> orderedUrls) {
    final frameColor = randomFrameColor;

    if (orderedUrls.length == 1) {
      // 1 ảnh: hiển thị đơn giản với frame
      return Container(
        color: frameColor,
        padding: EdgeInsets.all(12.w),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(orderedUrls[0].url, fit: BoxFit.cover),
          ),
        ),
      );
    } else if (orderedUrls.length == 2) {
      // 2 ảnh: layout dọc như column
      return SizedBox(
        height: 280.h,
        child: Container(
          color: frameColor,

          padding: EdgeInsets.all(12.w),
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 250.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      orderedUrls[0].url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 10.h),

              Expanded(
                child: SizedBox(
                  height: 250.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      orderedUrls[1].url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 3+ ảnh: 2 cột với hiệu ứng dịch chuyển
      return Container(
        color: frameColor,

        padding: EdgeInsets.all(12.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cột 1: dịch lên trên
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 0),
                child: _buildColumn1(orderedUrls),
              ),
            ),

            SizedBox(width: 10.w),
            // Cột 2: dịch xuống dưới
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: _buildColumn2(orderedUrls),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildColumn1(List<dynamic> orderedUrls) {
    return Column(
      children: [
        SizedBox(
          height: 250.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              orderedUrls[0].url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),

        SizedBox(height: 10.h),

        SizedBox(
          height: 250.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.network(
              orderedUrls[1].url,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColumn2(List<dynamic> orderedUrls) {
    final maxImages = orderedUrls.length > 5 ? 5 : orderedUrls.length;

    return Column(
      children: [
        if (orderedUrls.length == 3)
          SizedBox(
            height: 300.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                orderedUrls[2].url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          )
        else if (maxImages >= 3)
          SizedBox(
            height: 180.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                orderedUrls[2].url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        if (maxImages >= 4) ...[
          SizedBox(height: 10.h),
          SizedBox(
            height: 180.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                orderedUrls[3].url,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ],
        if (maxImages >= 5) ...[
          SizedBox(height: 10.h),
          orderedUrls.length > 5
              ? _buildOverlayImage(orderedUrls[4].url, orderedUrls.length - 5)
              : SizedBox(
                  height: 180.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Image.network(
                      orderedUrls[4].url,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
        ],
      ],
    );
  }

  Widget _buildOverlayImage(String imageUrl, int remaining) {
    return SizedBox(
      height: 180.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          SizedBox(
            height: 180.h,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
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
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
