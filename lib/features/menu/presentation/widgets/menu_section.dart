import 'package:flutter/material.dart';
import '../../../../../shared/component/layout/icon_text_tile.dart';

class MenuSection extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> items;

  const MenuSection({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //nếu không có title thì k hiển thị
        if (title.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return IconTextTile(
              icon: item['icon'],
              label: item['label'],
              onTap: item['onTap'],
            );
          },
        ),
      ],
    );
  }
}
