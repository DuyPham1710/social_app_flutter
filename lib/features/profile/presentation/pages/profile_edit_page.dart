import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
// Thay đổi đường dẫn theo dự án của bạn
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_state.dart'; // Cần để dùng BlocListener
import 'package:social_app_fe/features/profile/presentation/pages/profile_detail_edit_page.dart';
import 'package:social_app_fe/features/profile/presentation/pages/single_image_picker_page.dart';
// Import các widget cũ của bạn
import 'package:social_app_fe/features/profile/presentation/widgets/editable_image.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/editable_text_row.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/profile_detail_info_widget.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/section_header.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class ProfileEditPage extends StatefulWidget {
  final UserEntity? user;

  const ProfileEditPage({super.key, this.user});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // --- BottomSheet dùng chung cho Tên và Tiểu sử ---
  void _showEditBottomSheet({
    required BuildContext context,
    required String title,
    required String? initialValue,
    required Function(String) onSave,
    int maxLength = 100,
    int maxLines = 1,
  }) {
    final TextEditingController controller = TextEditingController(
      text: initialValue,
    );

    showModalBottomSheet(
      backgroundColor: AppColors.background,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: AppColors.iconPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                cursorColor: AppColors.primary,
                maxLines: maxLines,
                maxLength: maxLength,
                autofocus: true,
                style: TextStyle(color: AppColors.textPrimary),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.divider),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                  filled: true,
                  fillColor: AppColors.secondBackground,
                  hintText: "Nhập $title...",
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  counterStyle: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    onSave(controller.text.trim());
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Lưu",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Điều hướng sang trang chọn ảnh
  void _navigateToImagePicker(bool isAvatar) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            // Cần truyền ProfileBloc sang trang con để trang con có thể gọi event update
            SingleImagePickerPage(
              isAvatar: isAvatar,
              profileBloc: context.read<ProfileBloc>(),
            ),
      ),
    );
  }

  // Điều hướng sang trang sửa chi tiết
  void _navigateToDetailEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          // Cung cấp lại Bloc cho trang con
          value: context.read<ProfileBloc>(),
          child: ProfileDetailEditPage(user: widget.user),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // BlocListener để lắng nghe kết quả Update (Thành công/Thất bại)
    return BlocListener<ProfileBloc, ProfileState>(
      // Lắng nghe trạng thái cập nhật (updateSuccess)
      listener: (context, state) {
        if (state is ProfileLoaded) {
          if (state.updateSuccess) {
            // Sau khi cập nhật thành công, quay lại trang ProfilePage
            Navigator.pop(context);
            // Trang ProfilePage cha sẽ tự động tải lại dữ liệu (như đã thiết lập ở file trước)
          } else if (state.updateError != null) {
            showErrorSnackBar(context, 'Cập nhật thất bại');
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text("Chỉnh sửa trang cá nhân"),
          centerTitle: true,
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            const SizedBox(height: 24),

            // --- TÊN NGƯỜI DÙNG ---
            SectionHeader(
              title: "Tên người dùng",
              onEditTap: () => _showEditBottomSheet(
                context: context,
                title: "Chỉnh sửa tên",
                initialValue: widget.user?.fullName,
                maxLength: 50,
                onSave: (newName) {
                  if (newName.isNotEmpty) {
                    context.read<ProfileBloc>().add(
                      UpdateUserProfileEvent(
                        UpdateUserEntity(fullName: newName),
                      ),
                    );
                  }
                },
              ),
            ),
            EditableTextRow(text: widget.user?.fullName ?? "Người dùng"),
            const SizedBox(height: 24),

            // --- ẢNH ĐẠI DIỆN ---
            SectionHeader(
              title: "Ảnh đại diện",
              onEditTap: () => _navigateToImagePicker(true), // isAvatar = true
            ),
            const SizedBox(height: 8),
            Center(
              child: EditableImage(
                imageUrl:
                    (widget.user?.avatarUrl != null &&
                        widget.user!.avatarUrl!.isNotEmpty)
                    ? widget.user!.avatarUrl!
                    : "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
                isAvatarCircle: true,
                onEditTap: () => _navigateToImagePicker(true),
              ),
            ),

            const SizedBox(height: 24),

            // --- ẢNH BÌA ---
            SectionHeader(
              title: "Ảnh bìa",
              onEditTap: () =>
                  _navigateToImagePicker(false), // isAvatar = false
            ),
            const SizedBox(height: 8),
            EditableImage(
              imageUrl:
                  (widget.user?.coverUrl != null &&
                      widget.user!.coverUrl!.isNotEmpty)
                  ? widget.user!.coverUrl!
                  : "https://res.cloudinary.com/dk7ypst5k/image/upload/v1744336768/samples/balloons.jpg",
              borderRadius: 12,
              onEditTap: () => _navigateToImagePicker(false),
            ),

            const SizedBox(height: 24),

            // --- TIỂU SỬ ---
            SectionHeader(
              title: "Tiểu sử",
              onEditTap: () => _showEditBottomSheet(
                context: context,
                title: "Chỉnh sửa tiểu sử",
                initialValue: widget.user?.bio,
                maxLines: 3,
                maxLength: 100,
                onSave: (newBio) {
                  context.read<ProfileBloc>().add(
                    UpdateUserProfileEvent(UpdateUserEntity(bio: newBio)),
                  );
                },
              ),
            ),
            EditableTextRow(text: widget.user?.bio ?? "Chưa có tiểu sử"),

            const SizedBox(height: 24),

            // --- CHI TIẾT ---
            SectionHeader(
              title: "Chi tiết",
              onEditTap: _navigateToDetailEdit, // Mở trang sửa chi tiết
            ),
            ProfileDetailInfoWidget(user: widget.user),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
