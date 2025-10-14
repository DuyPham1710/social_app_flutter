import 'package:flutter/material.dart';

class IconTextTile extends StatelessWidget {
  final Widget icon; // đổi từ IconData sang Widget để linh hoạt hơn
  final String label;
  final VoidCallback? onTap;

  const IconTextTile({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: icon)), // tránh tràn bằng Expanded
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 13),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
