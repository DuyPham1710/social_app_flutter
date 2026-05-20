import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/voice_effect/voice_effect_bloc.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/voice_effect/voice_effect_event.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/voice_effect/voice_effect_state.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class VoiceEffectBottomSheet extends StatefulWidget {
  final String filePath;
  final Function(String newFilePath) onVoiceChanged;

  const VoiceEffectBottomSheet({
    super.key,
    required this.filePath,
    required this.onVoiceChanged,
  });

  @override
  State<VoiceEffectBottomSheet> createState() => _VoiceEffectBottomSheetState();
}

class _VoiceEffectBottomSheetState extends State<VoiceEffectBottomSheet> {
  String? _selectedChip;

  void _applyVoiceEffect(BuildContext context, String selectedVoice) {
    setState(() {
      _selectedChip = selectedVoice;
    });

    // Nếu chọn "Gốc" → không cần gọi API, trả về file gốc
    if (selectedVoice == 'Gốc') {
      Navigator.pop(context);
      widget.onVoiceChanged(widget.filePath);
      return;
    }

    // Gọi event cho bloc
    context.read<VoiceEffectBloc>().add(
      ApplyVoiceEffectEvent(
        filePath: widget.filePath,
        voicePreset: selectedVoice,
      ),
    );
  }

  Widget _buildVoiceChip(BuildContext context, String label, bool isLoading) {
    final isSelected = _selectedChip == label;
    return GestureDetector(
      onTap: isLoading ? null : () => _applyVoiceEffect(context, label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.2)
              : AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.primary.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 13.sp,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<VoiceEffectBloc>(),
      child: BlocConsumer<VoiceEffectBloc, VoiceEffectState>(
        listener: (context, state) {
          if (state is VoiceEffectSuccess) {
            Navigator.pop(context);
            widget.onVoiceChanged(state.newFilePath);
            showSuccessSnackBar(
              context,
              'Đã áp dụng giọng: ${_selectedChip ?? ""}',
            );
          } else if (state is VoiceEffectError) {
            showErrorSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          final isLoading = state is VoiceEffectLoading;

          return Container(
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            ),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 24.h,
              top: 16.h,
              left: 20.w,
              right: 20.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  'Chỉnh sửa giọng nói',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                // Loading message
                if (isLoading)
                  Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14.sp,
                          height: 14.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.primary.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Đang chuyển giọng, vui lòng đợi...',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 20.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 12.h,
                  children: [
                    _buildVoiceChip(context, 'Gốc', isLoading),
                    _buildVoiceChip(context, 'Con gái', isLoading),
                    _buildVoiceChip(context, 'Trầm', isLoading),
                    _buildVoiceChip(context, 'Em bé', isLoading),
                    _buildVoiceChip(context, 'Robot', isLoading),
                    _buildVoiceChip(context, 'Ác quỷ', isLoading),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
