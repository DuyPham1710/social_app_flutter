import 'package:flutter/material.dart';

class MenuShortcuts extends StatelessWidget {
  final List<Map<String, String>> shortcuts;

  const MenuShortcuts({super.key, required this.shortcuts});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: shortcuts.length,
        itemBuilder: (context, index) {
          final item = shortcuts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(item['avatar']!),
                  radius: 25,
                ),
                const SizedBox(height: 4),
                Text(item['name']!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
