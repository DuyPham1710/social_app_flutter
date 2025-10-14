import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            label: const Text(
              'Thêm vào tin',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {},
            icon: const Icon(Icons.edit_outlined, color: Colors.black),
            label: const Text(
              'Chỉnh sửa thông tin',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
