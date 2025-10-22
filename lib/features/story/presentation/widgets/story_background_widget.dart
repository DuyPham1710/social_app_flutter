import 'package:flutter/material.dart';

class StoryBackgroundWidget extends StatelessWidget {
  final String? mediaUrl;
  final Offset dragOffset;

  const StoryBackgroundWidget({
    super.key,
    required this.mediaUrl,
    required this.dragOffset,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(dragOffset.dy != 0 ? 12.0 : 0.0),
        child: mediaUrl != null && mediaUrl!.isNotEmpty
            ? Image.network(mediaUrl!, fit: BoxFit.cover)
            : Container(color: Colors.grey[900]),
      ),
    );
  }
}
