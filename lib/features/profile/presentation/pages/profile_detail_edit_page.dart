import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa chi tiết"),
        actions: [
          TextButton(
            onPressed: _onSave,
            child: const Text(
              "Lưu",
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
          _buildTextField("Trường học", _schoolController, Icons.school),
          _buildTextField(
            "Thành phố hiện tại",
            _currentCityController,
            Icons.location_city,
          ),
          _buildTextField("Quê quán", _hometownController, Icons.home),
          _buildTextField("Nơi làm việc", _workplaceController, Icons.work),
          _buildRelationshipDropdown(),
          const SizedBox(height: 30),
        ],
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
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Nhập $label...",
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
          const Text(
            "Tình trạng quan hệ",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            dropdownColor: AppColors.background,
            value: _selectedRelationshipStatus,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.favorite, color: Colors.red),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            hint: const Text("Chọn tình trạng quan hệ"),
            items: _relationshipOptions.map((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
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
