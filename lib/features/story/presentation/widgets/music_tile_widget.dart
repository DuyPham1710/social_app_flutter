import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/data/models/deezer_music_model.dart';

class MusicTileWidget extends StatefulWidget {
  final DeezerMusicModel item;
  final bool isPlaying;
  final double? progress; // 0.0 - 1.0, null nếu không phát
  final VoidCallback onPlay;
  final VoidCallback onTap;

  const MusicTileWidget({
    super.key,
    required this.item,
    required this.isPlaying,
    this.progress,
    required this.onPlay,
    required this.onTap,
  });

  @override
  State<MusicTileWidget> createState() => _MusicTileWidgetState();
}

class _MusicTileWidgetState extends State<MusicTileWidget> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: widget.onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          widget.item.album.cover,
          width: 54.w,
          height: 54.w,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 54.w,
            height: 54.w,
            color: Colors.grey[800],
            child: const Icon(Icons.music_note, color: Colors.white),
          ),
        ),
      ),
      title: Text(
        widget.item.title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.item.artist.name,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 13.sp,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.more_horiz, color: Colors.white70),
            onPressed: () {},
          ),
          SizedBox(width: 4.w),
          GestureDetector(
            onTap: widget.onPlay,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: Colors.white10,
                  child: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
                if (widget.isPlaying && widget.progress != null)
                  SizedBox(
                    width: 40.r,
                    height: 40.r,
                    child: CustomPaint(
                      painter: _RotatingDotPainter(
                        progress: widget.progress!,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RotatingDotPainter extends CustomPainter {
  final double progress;

  _RotatingDotPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;
    final dotRadius = 4.0;
    final strokeWidth = 2.0;

    // Vẽ đường tròn nền (màu xám nhạt)
    final backgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Vẽ đường tròn progress (màu xanh)
    final progressPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = progress * 2 * math.pi;
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -math.pi / 2, // Bắt đầu từ trên cùng
      sweepAngle,
      false,
      progressPaint,
    );

    // Tính toán vị trí chấm xanh dựa trên progress (0-1)
    final angle = -math.pi / 2 + (progress * 2 * math.pi); // Bắt đầu từ trên cùng
    final dotX = center.dx + radius * math.cos(angle);
    final dotY = center.dy + radius * math.sin(angle);

    // Vẽ chấm xanh
    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(dotX, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(_RotatingDotPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
