import 'package:flutter/material.dart';

class ProfileHighlights extends StatelessWidget {
  const ProfileHighlights({super.key});

  Widget _buildHighlight(String title, IconData icon) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 40, color: Colors.blue),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 13)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildHighlight('Bạn bè', Icons.people),
          _buildHighlight('Ảnh', Icons.photo_library),
          _buildHighlight('Reels', Icons.video_library),
        ],
      ),
    );
  }
}
