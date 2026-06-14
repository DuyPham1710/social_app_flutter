import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/helpers/device_translation_locale.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/post/domain/entities/caption_translation_eligibility_entity.dart';
import 'package:social_app_fe/features/post/domain/entities/post_translation_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_caption_translation_eligibility_usecase.dart';
import 'package:social_app_fe/features/post/domain/usecases/translate_caption_usecase.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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

  /// null: đang kiểm tra; true: ẩn nút dịch; false: hiện nút.
  bool? _hideTranslateAction;
  bool _eligibilityChecked = false;

  String get _appTargetLang => appTranslationTargetLang(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkEligibility());
  }

  Future<void> _checkEligibility() async {
    if (widget.caption.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _hideTranslateAction = true;
          _eligibilityChecked = true;
        });
      }
      return;
    }

    final usecase = s1<GetCaptionTranslationEligibilityUsecase>();
    final result = await usecase(
      params: GetCaptionTranslationEligibilityParams(
        postId: widget.postId,
        targetLang: _appTargetLang,
      ),
    );

    if (!mounted) return;

    if (result is DataStateSuccess<CaptionTranslationEligibilityEntity>) {
      setState(() {
        _hideTranslateAction = result.data!.translationNotNeeded;
        _eligibilityChecked = true;
      });
    } else {
      setState(() {
        _hideTranslateAction = false;
        _eligibilityChecked = true;
      });
    }
  }

  Future<void> _toggleTranslation() async {
    if (_isLoading) return;

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
        params: TranslateCaptionParams(
          postId: widget.postId,
          targetLang: _appTargetLang,
        ),
      );

      if (result is DataStateSuccess<PostTranslationEntity>) {
        final data = result.data!;
        if (data.translationNotNeeded) {
          setState(() {
            _translation = null;
            _showTranslated = false;
            _hideTranslateAction = true;
          });
        } else {
          setState(() {
            _translation = data;
            _showTranslated = true;
          });
        }
      } else if (result is DataStateError) {
        setState(() {
          _error = result.error?.message ?? context.l10n.postTranslateFailed;
        });
      }
    } catch (e) {
      setState(() {
        _error = context.l10n.postTranslateError;
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

    final style = widget.textStyle ?? TextStyle(fontSize: 13.rsp(context));

    final showTranslateRow =
        _eligibilityChecked && _hideTranslateAction == false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(captionToShow, style: style),
        if (showTranslateRow) ...[
          SizedBox(height: 4.rsh(context)),
          Row(
            children: [
              if (_isLoading)
                SizedBox(
                  width: 14.rs(context),
                  height: 14.rs(context),
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary,
                  ),
                ),
              if (_isLoading) SizedBox(width: 6.rs(context)),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: _isLoading ? null : _toggleTranslation,
                child: Text(
                  _translation == null
                      ? context.l10n.postSeeTranslation
                      : (_showTranslated
                            ? context.l10n.postSeeOriginal
                            : context.l10n.postSeeTranslation),
                  style: TextStyle(
                    fontSize: 12.rsp(context),
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (_error != null)
          Padding(
            padding: EdgeInsets.only(top: 2.rsh(context)),
            child: Text(
              _error!,
              style: TextStyle(
                fontSize: 11.rsp(context),
                color: Colors.red[400],
              ),
            ),
          ),
      ],
    );
  }
}
