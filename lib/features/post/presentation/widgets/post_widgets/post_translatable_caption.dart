import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/post/domain/entities/post_translation_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/translate_caption_usecase.dart';

class PostTranslatableCaption extends StatefulWidget {
  final String postId;
  final String caption;
  final TextStyle? textStyle;

  const PostTranslatableCaption({
    super.key,
    required this.postId,
    required this.caption,
    this.textStyle,
  });

  @override
  State<PostTranslatableCaption> createState() =>
      _PostTranslatableCaptionState();
}

class _PostTranslatableCaptionState extends State<PostTranslatableCaption> {
  bool _isLoading = false;
  bool _showTranslated = false;
  PostTranslationEntity? _translation;
  String? _error;

  Future<void> _toggleTranslation() async {
    if (_isLoading) return;

    // Nếu đã có bản dịch thì chỉ toggle hiển thị
    if (_translation != null) {
      setState(() {
        _showTranslated = !_showTranslated;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final usecase = s1<TranslateCaptionUsecase>();
      final result = await usecase(
        params: TranslateCaptionParams(postId: widget.postId),
      );

      if (result is DataStateSuccess<PostTranslationEntity>) {
        setState(() {
          _translation = result.data;
          _showTranslated = true;
        });
      } else if (result is DataStateError) {
        setState(() {
          _error = result.error?.message ?? 'Không thể dịch caption';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Đã xảy ra lỗi khi dịch caption';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final captionToShow = _showTranslated && _translation != null
        ? _translation!.translatedCaption
        : widget.caption;

    final style = widget.textStyle ?? TextStyle(fontSize: 13.sp);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          captionToShow,
          style: style,
        ),
        SizedBox(height: 4.h),
        Row(
          children: [
            if (_isLoading)
              SizedBox(
                width: 14.w,
                height: 14.w,
                child: const CircularProgressIndicator(strokeWidth: 1.5),
              ),
            if (_isLoading) SizedBox(width: 6.w),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              onPressed: _isLoading ? null : _toggleTranslation,
              child: Text(
                _translation == null
                    ? 'Xem bản dịch'
                    : (_showTranslated ? 'Xem bản gốc' : 'Xem bản dịch'),
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: 2.h),
            child: Text(
              _error!,
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.red[400],
              ),
            ),
          ),
      ],
    );
  }
}

