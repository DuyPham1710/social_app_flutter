import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/utils/profile_localization.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileDetailEditPage extends StatefulWidget {
  final UserEntity? user;

  const ProfileDetailEditPage({super.key, this.user});

  @override
  State<ProfileDetailEditPage> createState() => _ProfileDetailEditPageState();
}

class _ProfileDetailEditPageState extends State<ProfileDetailEditPage> {
  late TextEditingController _schoolController;
  late TextEditingController _currentCityController;
  late TextEditingController _hometownController;
  late TextEditingController _workplaceController;
  String? _selectedRelationshipStatus;

  // Danh sách các tùy chọn
  final List<String> _relationshipOptions = [
    'Độc thân',
    'Hẹn hò', // Đã sửa từ "Đang hẹn hò" thành "Hẹn hò" để khớp dữ liệu của bạn
    'Đang hẹn hò', // Giữ cả 2 để an toàn nếu cần
    'Đã kết hôn',
    'Phức tạp',
    'Mối quan hệ mở',
    'Ly hôn',
  ];

  @override
  void initState() {
    super.initState();
    _schoolController = TextEditingController(text: widget.user?.school ?? "");
    _currentCityController = TextEditingController(
      text: widget.user?.currentCity ?? "",
    );
    _hometownController = TextEditingController(
      text: widget.user?.hometown ?? "",
    );
    _workplaceController = TextEditingController(
      text: widget.user?.workplace ?? "",
    );

    // LOGIC SỬA LỖI DROPDOWN:
    // Kiểm tra xem dữ liệu user có nằm trong danh sách không.
    // Nếu có thì gán, nếu không (hoặc null) thì để null để tránh crash app.
    String? statusFromUser = widget.user?.relationshipStatus;
    if (statusFromUser != null &&
        _relationshipOptions.contains(statusFromUser)) {
      _selectedRelationshipStatus = statusFromUser;
    } else {
      _selectedRelationshipStatus = null; // Reset về null nếu dữ liệu lạ
    }
  }

  @override
  void dispose() {
    _schoolController.dispose();
    _currentCityController.dispose();
    _hometownController.dispose();
    _workplaceController.dispose();
    super.dispose();
  }

  void _onSave() {
    context.read<ProfileBloc>().add(
      UpdateUserProfileEvent(
        UpdateUserEntity(
          school: _schoolController.text.trim(),
          currentCity: _currentCityController.text.trim(),
          hometown: _hometownController.text.trim(),
          workplace: _workplaceController.text.trim(),
          relationshipStatus: _selectedRelationshipStatus,
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),

          child: Scaffold(
            appBar: AppBar(
              title: Text(l10n.profileEditDetailsTitle),
              actions: [
                TextButton(
                  onPressed: _onSave,
                  child: Text(
                    l10n.commonSave,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildTextField(
                  l10n.profileSchool,
                  _schoolController,
                  Icons.school,
                ),
                _buildTextField(
                  l10n.profileCurrentCity,
                  _currentCityController,
                  Icons.location_city,
                ),
                _buildTextField(
                  l10n.profileHometown,
                  _hometownController,
                  Icons.home,
                ),
                _buildTextField(
                  l10n.profileWorkplace,
                  _workplaceController,
                  Icons.work,
                ),
                _buildRelationshipDropdown(),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            cursorColor: AppColors.primary,
            controller: controller,
            style: TextStyle(color: AppColors.textPrimary),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.secondBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              hintText: context.l10n.profileEnterField(label),
              hintStyle: TextStyle(color: AppColors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.profileRelationshipStatus,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.background,
            style: TextStyle(color: AppColors.textPrimary),
            value: _selectedRelationshipStatus,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.favorite, color: Colors.red),
              filled: true,
              fillColor: AppColors.secondBackground,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: Text(
              context.l10n.profileSelectRelationshipStatus,
              style: TextStyle(color: AppColors.textSecondary),
            ),
            items: _relationshipOptions.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  localizedRelationshipStatus(context.l10n, value),
                  style: TextStyle(color: AppColors.textPrimary),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedRelationshipStatus = newValue;
              });
            },
          ),
        ],
      ),
    );
  }
}
