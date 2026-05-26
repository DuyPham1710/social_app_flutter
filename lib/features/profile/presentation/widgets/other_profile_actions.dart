import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/friend/domain/entities/relationship_status_entity.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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
        title: Text(
          context.l10n.profileConfirmUnfriendTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          context.l10n.profileConfirmUnfriendMessage,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              context.l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              onUnfriend?.call();
            },
            child: Text(context.l10n.profileAgree),
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
    final style = ElevatedButton.styleFrom(
      backgroundColor: isElevated
          ? AppColors.primary
          : AppColors.secondBackground,
      foregroundColor: isElevated ? Colors.white : AppColors.textPrimary,
      minimumSize: size,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );

    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconTheme(
            data: IconThemeData(
              color: isElevated ? Colors.white : AppColors.textPrimary,
            ),
            child: icon,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isElevated ? Colors.white : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
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
            icon: const Icon(Icons.person_add),
            label: context.l10n.profileAddFriend,
            onPressed: onSendRequest,
            isElevated: true,
            size: const Size(totalWidth, buttonHeight),
          ),
        ];

      case 'request_sent':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.cancel),
            label: context.l10n.profileCancelFriendRequest,
            onPressed: onCancelRequest,
            isElevated: false,
            size: const Size(totalWidth, buttonHeight),
          ),
        ];

      case 'request_received':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.check),
            label: context.l10n.profileAcceptFriend,
            onPressed: onAcceptRequest,
            isElevated: true,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
          _buildButton(
            icon: const Icon(Icons.clear),
            label: context.l10n.profileRejectFriend,
            onPressed: onRejectRequest,
            isElevated: false,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
        ];

      case 'friends':
        buttons = [
          _buildButton(
            icon: const Icon(Icons.remove_circle),
            label: context.l10n.profileUnfriend,
            onPressed: () => _confirmUnfriend(context),
            isElevated: false,
            size: const Size(totalWidth / 2 - 8, buttonHeight),
          ),
          _buildButton(
            icon: const Icon(Icons.message),
            label: context.l10n.profileMessage,
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
