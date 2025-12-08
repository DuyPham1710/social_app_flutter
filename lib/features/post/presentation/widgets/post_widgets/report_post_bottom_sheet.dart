import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/error_utils.dart';
import 'package:social_app_fe/core/di/injection.dart' as di;
import 'package:social_app_fe/features/post/domain/usecases/report_post_usecase.dart';

class ReportPostBottomSheet extends StatefulWidget {
  final String postId;
  final String? ownerUserId;

  const ReportPostBottomSheet({
    super.key,
    required this.postId,
    this.ownerUserId,
  });

  static Future<void> show(
    BuildContext context, {
    required String postId,
    String? ownerUserId,
  }) async {
    final userData = await TokenStorage.getUserData();
    final currentUserId = userData?['id'];

    // Không cho phép báo cáo bài viết của chính mình
    if (currentUserId != null &&
        ownerUserId != null &&
        ownerUserId == currentUserId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bạn không thể báo cáo bài viết của chính mình.'),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: 16.h,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16.h,
          ),
          child: ReportPostBottomSheet(
            postId: postId,
            ownerUserId: ownerUserId,
          ),
        );
      },
    );
  }

  @override
  State<ReportPostBottomSheet> createState() => _ReportPostBottomSheetState();
}

class _ReportPostBottomSheetState extends State<ReportPostBottomSheet> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _quickReasons = const [
    'Nội dung phản cảm',
    'Bạo lực / thù hằn',
    'Lừa đảo / spam',
    'Thông tin sai lệch',
    'Quấy rối / xúc phạm',
  ];

  String? _selectedReason;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reasonController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    final reasonText = _reasonController.text.trim();
    final descriptionText = _descriptionController.text.trim();
    final finalReason = reasonText.isNotEmpty ? reasonText : _selectedReason;

    if (finalReason == null || finalReason.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng chọn hoặc nhập lý do báo cáo'),
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final usecase = di.s1<ReportPostUseCase>();
    final result = await usecase(
      params: ReportPostParams(
        postId: widget.postId,
        reason: finalReason,
        description: descriptionText.isEmpty ? null : descriptionText,
      ),
    );

    setState(() {
      _isSubmitting = false;
    });

    if (result is DataStateSuccess) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Đã gửi báo cáo. Cảm ơn bạn đã đóng góp!',
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Gửi báo cáo thất bại. Vui lòng thử lại.'
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.flag_outlined,
                color: Colors.red,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Báo cáo bài viết',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Hãy cho chúng tôi biết vấn đề của bài viết này để cải thiện trải nghiệm cộng đồng.',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          'Lý do nhanh',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: _quickReasons.map((reason) {
            final isSelected = _selectedReason == reason;
            return ChoiceChip(
              label: Text(
                reason,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              selectedColor: Colors.redAccent,
              backgroundColor: Colors.grey[200],
              onSelected: (selected) {
                setState(() {
                  _selectedReason = selected ? reason : null;
                  if (selected && _reasonController.text.isEmpty) {
                    // Gợi ý lý do vào textfield nếu đang trống
                    _reasonController.text = reason;
                  }
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 16.h),
        Text(
          'Lý do chi tiết',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _reasonController,
          decoration: const InputDecoration(
            hintText: 'Nhập lý do báo cáo...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Mô tả thêm (không bắt buộc)',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: _descriptionController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Bạn có thể cung cấp thêm chi tiết để chúng tôi hiểu rõ hơn...',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        Navigator.of(context).pop();
                      },
                child: const Text('Hủy'),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _handleSubmit,
                child: _isSubmitting
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Gửi báo cáo'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
