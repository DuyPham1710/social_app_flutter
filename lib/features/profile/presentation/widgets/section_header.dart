import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onEditTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onEditTap,
          child: const Text(
            "Chỉnh sửa",
            style: TextStyle(color: Colors.blue, fontSize: 16),
          ),
        )
      ],
    );
  }
}
