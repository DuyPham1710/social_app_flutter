import 'package:flutter/material.dart';

class StoryNavArrowButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const StoryNavArrowButton({required this.icon, required this.onTap});

  @override
  State<StoryNavArrowButton> createState() => _StoryNavArrowButtonState();
}

class _StoryNavArrowButtonState extends State<StoryNavArrowButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _isHovered
                ? Colors.white.withValues(alpha: 0.25)
                : Colors.white.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon,
            color: _isHovered
                ? Colors.white
                : Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
        ),
      ),
    );
  }
}
