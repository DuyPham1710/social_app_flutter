import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_state.dart';
import 'package:social_app_fe/shared/helpers/privacy_helper.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class PrivacyPage extends StatefulWidget {
  final String selectedOption;
  const PrivacyPage({super.key, required this.selectedOption});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late String selected;
  bool isSetAsDefault = false;
  bool shouldUpdateDefault = false;

  final List<Map<String, String>> baseOptions = [
    {'label': 'Công khai', 'desc': 'Bất kỳ ai ở trên hoặc ngoài App'},
    {'label': 'Bạn bè', 'desc': 'Bạn bè của bạn trên App'},
    {'label': 'Bạn bè ngoại trừ...', 'desc': 'Ẩn bài viết khỏi một số bạn bè'},
    {'label': 'Bạn bè cụ thể', 'desc': 'Chỉ hiển thị với một vài bạn'},
    {'label': 'Chỉ mình tôi', 'desc': 'Chỉ mình tôi'},
  ];

  @override
  void initState() {
    super.initState();
    selected = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.textSecondary,
          ),
        ),

        middle: Text('Ai có thể xem bài viết của bạn?'),

        trailing: GestureDetector(
          onTap: () {
            // Nếu cần update default privacy, gọi API trước khi close
            if (shouldUpdateDefault) {
              _updateDefaultPrivacy();
            } else {
              context.read<PrivacyBloc>().add(
                PrivacySelectionChanged(selectedPrivacy: selected),
              );
              Navigator.pop(context, selected);
            }
          },
          child: Text(
            'Xong',
            style: TextStyle(
              color: CupertinoColors.activeBlue,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      child: SafeArea(
        child: Material(
          color: AppColors.background,
          child: BlocListener<PrivacyBloc, PrivacyState>(
            listener: (context, state) {
              if (state is PrivacyUpdated) {
                showSuccessSnackBar(context, state.message);
                // Sau khi update thành công, close page
                Navigator.pop(context, selected);
              } else if (state is PrivacyError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: BlocBuilder<PrivacyBloc, PrivacyState>(
              builder: (context, state) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildDescription(state),
                    SizedBox(height: 16.h),
                    _buildOptionsList(state),
                    SizedBox(height: 12.h),
                    _buildDefaultToggle(state),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(PrivacyState state) {
    String defaultPrivacy = widget.selectedOption;

    if (state is PrivacyLoaded) {
      defaultPrivacy = state.selectedPrivacy;
    }

    return Text(
      'Bài viết của bạn sẽ hiển thị trên Bảng feed, trang cá nhân và trong kết quả tìm kiếm.\n\n'
      'Tùy đối tượng mặc định là $defaultPrivacy, nhưng bạn có thể thay đổi đối tượng của riêng bài viết này.',
      style: TextStyle(color: AppColors.textSecondary, height: 1.4),
    );
  }

  Widget _buildOptionsList(PrivacyState state) {
    if (state is PrivacyLoading) {
      return Center(child: CupertinoActivityIndicator());
    }

    // Nếu có data từ backend, có thể thêm custom options từ privacyEntity
    if (state is PrivacyLoaded) {
      // Update selected value with backend data
      if (selected == widget.selectedOption) {
        selected = state.selectedPrivacy;
      }
    }

    if (state is PrivacyError) {
      return Column(
        children: [
          Text('Lỗi: ${state.message}', style: TextStyle(color: Colors.red)),
          SizedBox(height: 16.h),
          ...baseOptions.map((item) => _buildOptionTile(item)),
        ],
      );
    }

    return Column(
      children: baseOptions.map((item) => _buildOptionTile(item)).toList(),
    );
  }

  Widget _buildOptionTile(Map<String, String> item) {
    final isSelected = selected == item['label'];

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(getIcon(item['label']!), color: AppColors.textPrimary),

      title: Text(
        item['label']!,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Text(
        item['desc']!,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
      ),

      trailing: Icon(
        isSelected
            ? CupertinoIcons.check_mark_circled_solid
            : CupertinoIcons.circle,
        color: isSelected ? CupertinoColors.activeBlue : Colors.grey,
      ),

      onTap: () {
        setState(() {
          selected = item['label']!;
          // Reset shouldUpdateDefault khi đổi selection
          shouldUpdateDefault = false;
          isSetAsDefault = false;
        });
      },
    );
  }

  Widget _buildDefaultToggle(PrivacyState state) {
    // Check if current selected privacy is already the default
    bool isCurrentDefault = false;
    bool isUpdating = state is PrivacyUpdating;

    if (state is PrivacyLoaded) {
      // Convert current default privacy to label for comparison
      final currentDefaultLabel = PrivacyUtil.privacyTypeToLabel(
        state.privacyEntity.defaultPrivacy,
      );
      isCurrentDefault = selected == currentDefaultLabel;
    }

    return Row(
      children: [
        CupertinoSwitch(
          value: isCurrentDefault || isSetAsDefault,
          onChanged: isUpdating || isCurrentDefault
              ? null
              : (value) {
                  setState(() {
                    isSetAsDefault = value;
                    shouldUpdateDefault = value; // Set flag để biết cần update
                  });
                },
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            isCurrentDefault
                ? 'Đây là đối tượng mặc định hiện tại'
                : 'Đặt làm đối tượng mặc định',
            style: TextStyle(
              color: isCurrentDefault
                  ? AppColors.textSecondary.withOpacity(0.6)
                  : AppColors.textSecondary,
            ),
          ),
        ),
        if (isUpdating)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: SizedBox(
              width: 16.w,
              height: 16.h,
              child: CupertinoActivityIndicator(),
            ),
          ),
      ],
    );
  }

  void _updateDefaultPrivacy() {
    final currentState = context.read<PrivacyBloc>().state;
    if (currentState is PrivacyLoaded && shouldUpdateDefault) {
      // Create updated privacy entity with new default
      final newDefaultPrivacy = PrivacyUtil.labelToPrivacyType(selected);

      final updatedEntity = PrivacyEntity(
        defaultPrivacy: newDefaultPrivacy,
        friendsExcept: currentState
            .privacyEntity
            .friendsExcept, // giữ nguyên, sẽ chọn user và sửa sau
        friendsDetail: currentState
            .privacyEntity
            .friendsDetail, // giữ nguyên, sẽ chọn user và sửa sau
      );

      context.read<PrivacyBloc>().add(
        SetDefaultPrivacyRequested(privacyEntity: updatedEntity),
      );
    } else {
      // Không cần update
      Navigator.pop(context, selected);
    }
  }
}
