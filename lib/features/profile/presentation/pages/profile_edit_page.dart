import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
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
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

class ProfileEditPage extends StatefulWidget {
  final UserEntity? user;

  const ProfileEditPage({super.key, this.user});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  Widget _buildEditContent({
    required BuildContext context,
    required String title,
    required TextEditingController controller,
    required int maxLength,
    required int maxLines,
    required VoidCallback onSaved,
  }) {
    final l10n = context.l10n;
    return Column(
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
            hintText: l10n.profileEnterField(title),
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
            onPressed: onSaved,
            child: Text(
              l10n.commonSave,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

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

    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (dialogContext) {
          return Dialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 450),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: _buildEditContent(
                  context: dialogContext,
                  title: title,
                  controller: controller,
                  maxLength: maxLength,
                  maxLines: maxLines,
                  onSaved: () {
                    onSave(controller.text.trim());
                    Navigator.pop(dialogContext);
                  },
                ),
              ),
            ),
          );
        },
      );
    } else {
      showModalBottomSheet(
        backgroundColor: AppColors.background,
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (BuildContext sheetContext) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
            ),
            child: _buildEditContent(
              context: sheetContext,
              title: title,
              controller: controller,
              maxLength: maxLength,
              maxLines: maxLines,
              onSaved: () {
                onSave(controller.text.trim());
                Navigator.pop(sheetContext);
              },
            ),
          );
        },
      );
    }
  }

  // Điều hướng sang trang chọn ảnh
  void _navigateToImagePicker(bool isAvatar) async {
    if (kIsWeb) {
      final result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (!mounted) return;

        // Kiểm tra extension có phải ảnh không
        final ext = file.extension?.toLowerCase();
        final imageExts = ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic'];
        if (ext == null || !imageExts.contains(ext)) {
          showErrorSnackBar(context, context.l10n.commonImageOnlySupport);
          return;
        }

        final updateEntity = isAvatar
            ? UpdateUserEntity(avatarBytes: file.bytes, avatarName: file.name)
            : UpdateUserEntity(coverBytes: file.bytes, coverName: file.name);
        context.read<ProfileBloc>().add(UpdateUserProfileEvent(updateEntity));
      }
      return;
    }

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
    final l10n = context.l10n;
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
            showErrorSnackBar(context, context.l10n.profileUpdateFailed);
          }
        }
      },
      child: Container(
        color: AppColors.background,

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveHelper.feedMaxWidth,
            ),

            child: Scaffold(
              appBar: AppBar(
                surfaceTintColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(l10n.profileEditProfileTitle),
                centerTitle: true,
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const SizedBox(height: 24),

                  // --- TÊN NGƯỜI DÙNG ---
                  SectionHeader(
                    title: l10n.profileUsername,
                    onEditTap: () => _showEditBottomSheet(
                      context: context,
                      title: l10n.profileEditName,
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
                  EditableTextRow(
                    text: widget.user?.fullName ?? l10n.commonUser,
                  ),
                  const SizedBox(height: 24),

                  // --- ẢNH ĐẠI DIỆN ---
                  SectionHeader(
                    title: l10n.profileAvatar,
                    onEditTap: () =>
                        _navigateToImagePicker(true), // isAvatar = true
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
                    title: l10n.profileCover,
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
                    title: l10n.profileBio,
                    onEditTap: () => _showEditBottomSheet(
                      context: context,
                      title: l10n.profileEditBio,
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
                  EditableTextRow(
                    text: widget.user?.bio ?? l10n.profileNoBioPlaceholder,
                  ),

                  const SizedBox(height: 24),

                  // --- CHI TIẾT ---
                  SectionHeader(
                    title: l10n.profileDetails,
                    onEditTap: _navigateToDetailEdit, // Mở trang sửa chi tiết
                  ),
                  ProfileDetailInfoWidget(user: widget.user),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
