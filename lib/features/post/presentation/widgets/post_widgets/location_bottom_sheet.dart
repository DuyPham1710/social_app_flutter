import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class LocationBottomSheet extends StatefulWidget {
  final String address;
  final VoidCallback onConfirm;

  const LocationBottomSheet({
    super.key,
    required this.address,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required String address,
    required VoidCallback onConfirm,
  }) async {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.rsr(context)),
        ),
      ),
      builder: (_) {
        return LocationBottomSheet(address: address, onConfirm: onConfirm);
      },
    );
  }

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
          ),
        );

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.25).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward().then((_) {
      _controller.repeat(reverse: true, min: 0.4, max: 1.0);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 24.rsh(context),
            horizontal: 16.rs(context),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.postLocationSuggestionTitle,
                style: TextStyle(
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 16.rsh(context)),
              Text(
                context.l10n.postLocationSuggestionDesc,
                style: TextStyle(
                  fontSize: 14.rsp(context),
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.rsh(context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _pulseAnimation,
                    child: Icon(
                      Icons.location_on,
                      color: Colors.redAccent,
                      size: 24.rsp(context),
                    ),
                  ),
                  SizedBox(width: 8.rs(context)),
                  Flexible(
                    child: Text(
                      widget.address,
                      style: TextStyle(
                        fontSize: 14.rsp(context),
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.rsh(context)),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: BorderSide(color: AppColors.textPrimary),
                      ),
                      child: Text(
                        context.l10n.commonCancel,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.rs(context)),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(
                        context.l10n.commonOk,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
