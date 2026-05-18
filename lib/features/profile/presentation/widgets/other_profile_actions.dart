import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';

class OtherProfileActions extends StatelessWidget {
  final RelationshipStatusEntity? relationship;
  final VoidCallback? onSendRequest;
  final VoidCallback? onCancelRequest;
  final VoidCallback? onAcceptRequest;
  final VoidCallback? onRejectRequest;
  final VoidCallback? onUnfriend;
  final VoidCallback? onMessage;

  const OtherProfileActions({
    super.key,
    required this.relationship,
    this.onSendRequest,
    this.onCancelRequest,
    this.onAcceptRequest,
    this.onRejectRequest,
    this.onUnfriend,
    this.onMessage,
  });

  void _confirmUnfriend(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.background,
        title: const Text('Xác nhận hủy kết bạn'),
        content: const Text(
          'Bạn có chắc chắn muốn hủy kết bạn với người này không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Hủy',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(ctx);
              onUnfriend?.call();
            },
            child: const Text('Đồng ý', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required Widget icon,
    required String label,
    required VoidCallback? onPressed,
    required bool isElevated,
    required Size size,
  }) {
    final style = ButtonStyle(
      minimumSize: WidgetStateProperty.all(size),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      backgroundColor: isElevated
          ? WidgetStateProperty.all(AppColors.primary)
          : null,
    );

    return isElevated
        ? ElevatedButton(
            onPressed: onPressed,
            style: style,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 6),
                Text(label, style: const TextStyle(color: Colors.white)),
              ],
            ),
          )
        : OutlinedButton(
            onPressed: onPressed,
            style: style,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [icon, const SizedBox(width: 6), Text(label)],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (relationship == null) return const SizedBox.shrink();

    final status = relationship!.status;

    const double totalWidth = 330;
    const double buttonHeight = 44;

    List<Widget> buttons = [];

    switch (status) {
      case 'none':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            label: 'Thêm bạn bè',
            onPressed: onSendRequest,
            isElevated: true,
            size: const Size(totalWidth, buttonHeight),
          ),
        ];

      case 'request_sent':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.cancel),
            label: 'Hủy yêu cầu kết bạn',
            onPressed: onCancelRequest,
            isElevated: false,
            size: const Size(totalWidth, buttonHeight),
          ),
        ];

      case 'request_received':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.check, color: Colors.white),
            label: 'Chấp nhận kết bạn',
            onPressed: onAcceptRequest,
            isElevated: true,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
          _buildButton(
            icon: const Icon(Icons.clear),
            label: 'Xóa',
            onPressed: onRejectRequest,
            isElevated: false,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
        ];

      case 'friends':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.remove_circle),
            label: 'Hủy kết bạn',
            onPressed: () => _confirmUnfriend(context),
            isElevated: false,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
          _buildButton(
            icon: Icon(Icons.message, color: AppColors.background),
            label: 'Nhắn tin',
            onPressed: onMessage,
            isElevated: true,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
        ];
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < buttons.length; i++) ...[
            buttons[i],
            if (i < buttons.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}
