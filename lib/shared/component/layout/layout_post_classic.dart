import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LayoutPostClassic extends StatelessWidget {
  final List<dynamic> urls;

  const LayoutPostClassic({super.key, required this.urls});

  List<dynamic> get sortedUrls {
    final List<dynamic> sorted = List.from(urls);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    if (urls.isEmpty) return const SizedBox.shrink();

    final orderedUrls = sortedUrls;

    if (orderedUrls.length == 1) {
      // 1 hình: hiển thị bình thường
      return AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: Image.network(
            orderedUrls[0].url,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    } else if (orderedUrls.length == 2) {
      // 2 hình: ảnh mới đẩy ảnh cũ sang trái
      return AspectRatio(
        aspectRatio: 2.0,
        child: Row(
          children: [
            // Ảnh cũ (ảnh đầu tiên) bị đẩy sang trái
            Expanded(
              flex: 1,
              child: Image.network(orderedUrls[0].url, fit: BoxFit.cover),
            ),

            SizedBox(width: 4.w),

            // Ảnh mới (ảnh thứ hai)
            Expanded(
              flex: 1,
              child: Image.network(orderedUrls[1].url, fit: BoxFit.cover),
            ),
          ],
        ),
      );
    } else {
      // 3+ hình: xuống dòng, layout grid
      return _buildClassicGrid(orderedUrls);
    }
  }

  Widget _buildClassicGrid(List<dynamic> orderedUrls) {
    return Column(
      children: [
        // Dòng đầu: 2 ảnh đầu tiên
        AspectRatio(
          aspectRatio: 2.0,
          child: Row(
            children: [
              Expanded(
                child: Image.network(orderedUrls[0].url, fit: BoxFit.cover),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Image.network(orderedUrls[1].url, fit: BoxFit.cover),
              ),
            ],
          ),
        ),

        if (orderedUrls.length > 2) SizedBox(height: 4.h),

        // Dòng thứ 2: ảnh còn lại
        AspectRatio(
          aspectRatio: 2.0,
          child: Row(children: _buildSecondRowImages(orderedUrls)),
        ),
      ],
    );
  }

  List<Widget> _buildSecondRowImages(List<dynamic> orderedUrls) {
    List<Widget> images = [];
    final maxImagesInSecondRow = orderedUrls.length > 4
        ? 2
        : orderedUrls.length - 2;

    for (int i = 2; i < 2 + maxImagesInSecondRow; i++) {
      // khoảng cách giữa các ảnh
      if (i > 2) images.add(SizedBox(width: 4.w));

      // Nếu là ảnh cuối cùng trong dòng 2 và còn nhiều ảnh hơn => overlay
      if (i == 3 && orderedUrls.length > 4) {
        final remaining = orderedUrls.length - 4;
        images.add(
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(orderedUrls[i].url, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    //          borderRadius: BorderRadius.circular(8.r),
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
          ),
        );
      } else {
        images.add(
          Expanded(child: Image.network(orderedUrls[i].url, fit: BoxFit.cover)),
        );
      }
    }

    return images;
  }
}
