import 'package:flutter/material.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  Widget _buildInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfo(Icons.home, 'Sống tại TP Hồ Chí Minh'),
          _buildInfo(Icons.location_on, 'Đến từ Hà Nội'),
          _buildInfo(Icons.favorite, 'Độc thân'),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {},
            child: const Text('Xem thông tin giới thiệu', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
