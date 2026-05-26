import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_create_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class ProfileActions extends StatelessWidget {
  final VoidCallback? onTapEdit;
  const ProfileActions({super.key, this.onTapEdit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return StoryCreatePage();
                    },
                  ),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: Text(
                context.l10n.profileAddToStory,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.divider),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onTapEdit,
              icon: Icon(Icons.edit_outlined, color: AppColors.textPrimary),
              label: Text(
                context.l10n.profileEditInfo,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
