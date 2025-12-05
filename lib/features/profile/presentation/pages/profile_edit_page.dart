import 'package:flutter/material.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/detail_item.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/editable_image.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/editable_text_row.dart';
import 'package:social_app_fe/features/profile/presentation/widgets/section_header.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {}, // TODO
        ),
        title: const Text("Chỉnh sửa trang cá nhân"),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 24),
          // ẢNH ĐẠI DIỆN
          const SectionHeader(title: "Ảnh đại diện", onEditTap: null),
          const SizedBox(height: 8),
          const EditableImage(
            imageUrl: "https://picsum.photos/400",
            isAvatarCircle: true,
          ),

          const SizedBox(height: 24),

          // Ảnh bìa
          const SectionHeader(title: "Ảnh bìa", onEditTap: null),
          const SizedBox(height: 8),
          const EditableImage(
            imageUrl: "https://picsum.photos/600",
            borderRadius: 12,
          ),

          const SizedBox(height: 24),

          // Tiểu sử
          const SectionHeader(title: "Tiểu sử", onEditTap: null),
          const EditableTextRow(
            text:
                "A great love isn’t one who loves many,\nbut one who loves one woman for life…",
          ),

          const SizedBox(height: 24),

          // Chi tiết (work - living - hometown…)
          const SectionHeader(title: "Chi tiết", onEditTap: null),

          const DetailItem(
            icon: Icons.school_outlined,
            text: "Đã học tại THPT Lý Tự Trọng, Thạch Hà, Hà Tĩnh",
          ),
          const DetailItem(
            icon: Icons.home_outlined,
            text: "Sống tại Thạch Hà",
          ),
          const DetailItem(
            icon: Icons.location_on_outlined,
            text: "Đến từ Thạch Hà",
          ),

          const DetailItem(
            icon: Icons.work_outline,
            text: "Nơi làm việc",
            isDisabled: true,
          ),
          const DetailItem(
            icon: Icons.favorite_outline,
            text: "Tình trạng mối quan hệ",
            isDisabled: true,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
