import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
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
      contentPadding: EdgeInsets.symmetric(vertical: 4.rsh(context), horizontal: 4.rs(context)),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8.rsr(context)),
        child: Image.network(
          kIsWeb
              ? 'https://images.weserv.nl/?url=${Uri.encodeComponent(widget.item.album.cover)}'
              : widget.item.album.cover,
          width: 54.rs(context),
          height: 54.rs(context),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 54.rs(context),
            height: 54.rs(context),
            color: AppColors.secondBackground,
            child: Icon(Icons.music_note, color: AppColors.iconPrimary),
          ),
        ),
      ),
      title: Text(
        widget.item.title,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15.rsp(context),
          fontWeight: FontWeight.w700,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        widget.item.artist.name,
        style: TextStyle(color: AppColors.textSecondary, fontSize: 13.rsp(context)),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppColors.iconPrimary),
            onPressed: () {},
          ),
          SizedBox(width: 4.rs(context)),
          GestureDetector(
            onTap: widget.onPlay,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircleAvatar(
                  radius: 18.rsr(context),
                  backgroundColor: AppColors.secondBackground,
                  child: Icon(
                    widget.isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppColors.iconPrimary,
                    size: 22.rsp(context),
                  ),
                ),
                if (widget.isPlaying && widget.progress != null)
                  SizedBox(
                    width: 40.rsr(context),
                    height: 40.rsr(context),
                    child: CustomPaint(
                      painter: _RotatingDotPainter(progress: widget.progress!),
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
      ..color = AppColors.divider
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
    final angle =
        -math.pi / 2 + (progress * 2 * math.pi); // Bắt đầu từ trên cùng
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
