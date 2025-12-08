import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
// Import các widget cũ của bạn
import 'package:social_app_fe/features/profile/presentation/widgets/detail_item.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/editable_image.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/section_header.dart';
// Import Bloc để gọi sự kiện update
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';

// Import widget chi tiết mới (nếu bạn đã tách như gợi ý trước)

class ProfileEditPage extends StatefulWidget {
  final UserEntity? user;

  ProfileEditPage({super.key, this.user});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  // Hàm hiển thị khung nhập Tiểu sử
  void _showEditBioBottomSheet(BuildContext context, String? currentBio) {
    final TextEditingController bioController = TextEditingController(
      text: currentBio,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Để đẩy khung lên khi bàn phím hiện
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          // Padding bottom theo viewInsets để tránh bị bàn phím che
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Chỉnh sửa tiểu sử",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              TextField(
                controller: bioController,
                maxLines: 3,
                maxLength: 100, // Giới hạn ký tự giống FB/Insta
                autofocus: true, // Tự động focus và bật bàn phím
                decoration: InputDecoration(
                  hintText: "Mô tả ngắn về bản thân bạn...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.blue),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
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
                    // 1. Lấy giá trị mới
                    final newBio = bioController.text.trim();

                    // 2. Gọi Bloc để update (Bạn cần tạo Event UpdateProfileEvent)
                    // context.read<ProfileBloc>().add(UpdateProfileEvent(widget.user.copyWith(bio: newBio)));

                    // Ví dụ (Giả lập):
                    print("Đã lưu tiểu sử mới: $newBio");

                    // 3. Đóng bottom sheet
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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

          // --- ẢNH ĐẠI DIỆN ---
          const SectionHeader(
            title: "Ảnh đại diện",
            onEditTap: null,
          ), // TODO: Handle Avatar
          const SizedBox(height: 8),
          EditableImage(
            imageUrl: widget.user?.avatarUrl ?? "https://picsum.photos/400",
            isAvatarCircle: true,
          ),

          const SizedBox(height: 24),

          // --- ẢNH BÌA ---
          const SectionHeader(
            title: "Ảnh bìa",
            onEditTap: null,
          ), // TODO: Handle Cover
          const SizedBox(height: 8),
          EditableImage(
            imageUrl: widget.user?.coverUrl ?? "https://picsum.photos/600",
            borderRadius: 12,
          ),

          const SizedBox(height: 24),

          // --- TIỂU SỬ (Xử lý phần này) ---
          SectionHeader(
            title: "Tiểu sử",
            onEditTap: () {
              // Gọi hàm hiển thị BottomSheet
              _showEditBioBottomSheet(context, widget.user?.bio);
            },
          ),
          EditableTextRow(text: widget.user?.bio ?? "Chưa có tiểu sử"),

          const SizedBox(height: 24),

          // --- CHI TIẾT ---
          SectionHeader(
            title: "Chi tiết",
            onEditTap: () {
              // Mở trang edit chi tiết riêng (như yêu cầu trước)
              //Navigator.push(...);
            },
          ),

          // Widget gom nhóm chi tiết (sử dụng User để render)

          //ProfileDetailInfoWidget(user: widget.user),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
