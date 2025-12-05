import 'package:flutter/material.dart';

class EditableImage extends StatelessWidget {
  final String imageUrl;
  final bool isAvatarCircle;
  final double borderRadius;

  const EditableImage({
    super.key,
    required this.imageUrl,
    this.isAvatarCircle = false,
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius:
            isAvatarCircle ? BorderRadius.circular(100) : BorderRadius.circular(borderRadius),
        child: Image.network(
          imageUrl,
          height: isAvatarCircle ? 160 : null,
          width: isAvatarCircle ? 160 : double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
