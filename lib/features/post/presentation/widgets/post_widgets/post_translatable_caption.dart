import 'package:flutter/gestures.dart';
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
  static const int _collapsedCaptionMaxLines = 2;

  bool _isLoading = false;
  bool _showTranslated = false;
  bool _isCaptionExpanded = false;
  late final TapGestureRecognizer _seeMoreRecognizer;
  PostTranslationEntity? _translation;
  String? _error;

  /// null: đang kiểm tra; true: ẩn nút dịch; false: hiện nút.
  bool? _hideTranslateAction;
  bool _eligibilityChecked = false;

  String get _appTargetLang => appTranslationTargetLang(context);

  @override
  void initState() {
    super.initState();
    _seeMoreRecognizer = TapGestureRecognizer()..onTap = _expandCaption;
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkEligibility());
  }

  @override
  void dispose() {
    _seeMoreRecognizer.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PostTranslatableCaption oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.postId != widget.postId ||
        oldWidget.caption != widget.caption) {
      _isCaptionExpanded = false;
    }
  }

  void _expandCaption() {
    if (_isCaptionExpanded) return;
    setState(() {
      _isCaptionExpanded = true;
    });
  }

  void _collapseCaption() {
    if (!_isCaptionExpanded) return;
    setState(() {
      _isCaptionExpanded = false;
    });
  }

  Future<void> _checkEligibility() async {
    if (!mounted) return;

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

  bool _captionExceedsCollapsedLines({
    required String text,
    required TextStyle style,
    required double maxWidth,
    required TextDirection textDirection,
    required TextScaler textScaler,
  }) {
    if (!maxWidth.isFinite || text.trim().isEmpty) return false;

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: _collapsedCaptionMaxLines,
      textDirection: textDirection,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);

    final didExceedMaxLines = textPainter.didExceedMaxLines;
    textPainter.dispose();

    return didExceedMaxLines;
  }

  String _truncateCaptionForInlineAction({
    required String text,
    required TextStyle textStyle,
    required TextStyle actionStyle,
    required String actionText,
    required double maxWidth,
    required TextDirection textDirection,
    required TextScaler textScaler,
  }) {
    final textRunes = text.runes.toList();
    const ellipsis = '... ';

    bool fits(int runeCount) {
      final candidateCaption = String.fromCharCodes(
        textRunes.take(runeCount),
      ).trimRight();
      final textPainter = TextPainter(
        text: TextSpan(
          text: candidateCaption,
          style: textStyle,
          children: [
            const TextSpan(text: ellipsis),
            TextSpan(text: actionText, style: actionStyle),
          ],
        ),
        maxLines: _collapsedCaptionMaxLines,
        textDirection: textDirection,
        textScaler: textScaler,
      )..layout(maxWidth: maxWidth);

      final doesFit = !textPainter.didExceedMaxLines;
      textPainter.dispose();

      return doesFit;
    }

    var low = 0;
    var high = textRunes.length;

    while (low < high) {
      final mid = (low + high + 1) >> 1;
      if (fits(mid)) {
        low = mid;
      } else {
        high = mid - 1;
      }
    }

    return String.fromCharCodes(textRunes.take(low)).trimRight();
  }

  @override
  Widget build(BuildContext context) {
    final captionToShow = _showTranslated && _translation != null
        ? _translation!.translatedCaption
        : widget.caption;

    final style = DefaultTextStyle.of(
      context,
    ).style.merge(widget.textStyle ?? TextStyle(fontSize: 13.rsp(context)));

    final showTranslateRow =
        _eligibilityChecked && _hideTranslateAction == false;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxCaptionWidth = constraints.hasBoundedWidth
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final textDirection = Directionality.of(context);
        final textScaler = MediaQuery.textScalerOf(context);
        final actionStyle = style.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        );
        final captionIsCollapsible = _captionExceedsCollapsedLines(
          text: captionToShow,
          style: style,
          maxWidth: maxCaptionWidth,
          textDirection: textDirection,
          textScaler: textScaler,
        );
        final showSeeMore = !_isCaptionExpanded && captionIsCollapsible;
        final showSeeLess = _isCaptionExpanded && captionIsCollapsible;
        final collapsedCaption = showSeeMore
            ? _truncateCaptionForInlineAction(
                text: captionToShow,
                textStyle: style,
                actionStyle: actionStyle,
                actionText: context.l10n.commonSeeMore,
                maxWidth: maxCaptionWidth,
                textDirection: textDirection,
                textScaler: textScaler,
              )
            : captionToShow;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showSeeMore)
              RichText(
                maxLines: _collapsedCaptionMaxLines,
                overflow: TextOverflow.clip,
                textDirection: textDirection,
                textScaler: textScaler,
                text: TextSpan(
                  text: collapsedCaption,
                  style: style,
                  children: [
                    const TextSpan(text: '... '),
                    TextSpan(
                      text: context.l10n.commonSeeMore,
                      style: actionStyle,
                      recognizer: _seeMoreRecognizer,
                    ),
                  ],
                ),
              )
            else
              Text(captionToShow, style: style),
            if (showSeeLess)
              Padding(
                padding: EdgeInsets.only(top: 2.rsh(context)),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: _collapseCaption,
                  child: Text(context.l10n.commonSeeLess, style: actionStyle),
                ),
              ),
            // if (showTranslateRow) ...[
            //   SizedBox(height: 4.rsh(context)),
            //   Row(
            //     children: [
            //       if (_isLoading)
            //         SizedBox(
            //           width: 14.rs(context),
            //           height: 14.rs(context),
            //           child: CircularProgressIndicator(
            //             strokeWidth: 1.5,
            //             color: AppColors.primary,
            //           ),
            //         ),
            //       if (_isLoading) SizedBox(width: 6.rs(context)),
            //       TextButton(
            //         style: TextButton.styleFrom(
            //           padding: EdgeInsets.zero,
            //           minimumSize: Size(0, 0),
            //           tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //         ),
            //         onPressed: _isLoading ? null : _toggleTranslation,
            //         child: Text(
            //           _translation == null
            //               ? context.l10n.postSeeTranslation
            //               : (_showTranslated
            //                     ? context.l10n.postSeeOriginal
            //                     : context.l10n.postSeeTranslation),
            //           style: TextStyle(
            //             fontSize: 12.rsp(context),
            //             color: AppColors.primary,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ],
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
      },
    );
  }
}
