import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/local/story_privacy_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_friend_selection_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class StoryPrivacySettingsPage extends StatefulWidget {
  final String? storyId;

  const StoryPrivacySettingsPage({super.key, this.storyId});

  @override
  State<StoryPrivacySettingsPage> createState() =>
      _StoryPrivacySettingsPageState();
}

class _StoryPrivacySettingsPageState extends State<StoryPrivacySettingsPage> {
  static const _privacyPublic = 'public';
  static const _privacyFriends = 'friends';
  static const _privacyFriendsExcept = 'friendsExcept';
  static const _privacyFriendsDetail = 'friendsDetail';

  String _selectedPrivacy = _privacyFriends;
  List<String> _hiddenFriendIds = [];
  List<String> _allowedFriendIds = [];
  bool _isLoading = true;
  bool _isSaving = false;
  final StoryRepository _storyRepository = s1<StoryRepository>();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final savedPrivacy = await StoryPrivacyStorage.getPrivacy();
    final savedHiddenIds = await StoryPrivacyStorage.getHiddenFriendIds();
    final savedAllowedIds = await StoryPrivacyStorage.getAllowedFriendIds();

    if (mounted) {
      setState(() {
        if (savedPrivacy != null) {
          _selectedPrivacy = _normalizePrivacy(savedPrivacy);
        }
        _hiddenFriendIds = savedHiddenIds;
        _allowedFriendIds = savedAllowedIds;
        _isLoading = false;
      });
    }
  }

  Future<void> _savePrivacy(String privacy) async {
    await StoryPrivacyStorage.savePrivacy(privacy);

    // Nếu có storyId, gọi API để cập nhật privacy
    if (widget.storyId != null) {
      await _updateStoryPrivacy(privacy);
    }
  }

  Future<void> _saveHiddenFriendIds(List<String> friendIds) async {
    await StoryPrivacyStorage.saveHiddenFriendIds(friendIds);

    if (widget.storyId != null && _selectedPrivacy == _privacyFriendsExcept) {
      await _updateStoryPrivacy(_selectedPrivacy);
    }
  }

  Future<void> _saveAllowedFriendIds(List<String> friendIds) async {
    await StoryPrivacyStorage.saveAllowedFriendIds(friendIds);

    if (widget.storyId != null && _selectedPrivacy == _privacyFriendsDetail) {
      await _updateStoryPrivacy(_selectedPrivacy);
    }
  }

  Future<void> _updateStoryPrivacy(String privacy) async {
    if (widget.storyId == null || _isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      // Map từ UI privacy type sang PrivacyType enum
      PrivacyType privacyType;
      List<String>? friendsExcept;
      List<String>? friendsDetail;

      switch (privacy) {
        case _privacyPublic:
          privacyType = PrivacyType.public;
        case _privacyFriends:
          privacyType = PrivacyType.friends;
        case _privacyFriendsExcept:
          privacyType = PrivacyType.friendsExcept;
          friendsExcept = _hiddenFriendIds.isNotEmpty ? _hiddenFriendIds : null;
        case _privacyFriendsDetail:
          privacyType = PrivacyType.friendsDetail;
          friendsDetail = _allowedFriendIds.isNotEmpty
              ? _allowedFriendIds
              : null;
        default:
          privacyType = PrivacyType.friends;
      }

      final result = await _storyRepository.updateStoryPrivacy(
        storyId: widget.storyId!,
        privacyType: privacyType,
        friendsExcept: friendsExcept,
        friendsDetail: friendsDetail,
      );

      if (result is DataStateSuccess) {
        if (mounted) {
          showSuccessSnackBar(context, context.l10n.storyPrivacyUpdated);
        }
      } else if (result is DataStateError) {
        if (mounted) {
          showErrorSnackBar(
            context,
            context.l10n.commonErrorWithMessage(
              result.error?.message ?? context.l10n.storyPrivacyUpdateFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, context.l10n.commonErrorWithMessage('$e'));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  String _normalizePrivacy(String value) {
    switch (value) {
      case 'Công khai':
      case _privacyPublic:
        return _privacyPublic;
      case 'Ẩn tin với':
      case _privacyFriendsExcept:
        return _privacyFriendsExcept;
      case 'Tùy chỉnh':
      case _privacyFriendsDetail:
        return _privacyFriendsDetail;
      case 'Bạn bè':
      case _privacyFriends:
      default:
        return _privacyFriends;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: AppColors.background,

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: ResponsiveHelper.feedMaxWidth,
            ),
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          ),
        ),
      );
    }
    return Container(
      color: AppColors.background,

      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.iconPrimary),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              title: Text(
                context.l10n.storyPrivacyTitle,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.rsh(context)),
                    // Who can see your story section
                    _buildWhoCanSeeSection(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWhoCanSeeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.storyPrivacyQuestion,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.rsp(context),
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.rsh(context)),
        Text(
          context.l10n.storyPrivacyVisibleFor24h,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
        ),
        SizedBox(height: 20.rsh(context)),
        _buildPrivacyOption(
          icon: Icons.public,
          title: context.l10n.storyPrivacyPublic,
          description: context.l10n.storyPrivacyPublicDescription,
          value: _privacyPublic,
        ),
        SizedBox(height: 16.rsh(context)),
        _buildPrivacyOption(
          icon: Icons.people,
          title: context.l10n.storyPrivacyFriends,
          description: context.l10n.storyPrivacyFriendsDescription,
          value: _privacyFriends,
        ),
        SizedBox(height: 16.rsh(context)),
        _buildHideStoryOption(),
        SizedBox(height: 16.rsh(context)),
        _buildCustomPrivacyOption(),
      ],
    );
  }

  Widget _buildPrivacyOption({
    required IconData icon,
    required String title,
    required String description,
    required String value,
  }) {
    final isSelected = _selectedPrivacy == value;
    return GestureDetector(
      onTap: () async {
        setState(() {
          _selectedPrivacy = value;
        });
        await _savePrivacy(value);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 12.rsh(context),
          horizontal: 12.rs(context),
        ),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(12.rsr(context)),
        ),
        child: Row(
          children: [
            Container(
              width: 40.rs(context),
              height: 40.rs(context),
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.iconPrimary,
                size: 20.rsp(context),
              ),
            ),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.rsh(context)),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.rsp(context),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.rs(context),
              height: 24.rs(context),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.divider,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 14.rs(context),
                        height: 14.rs(context),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHideStoryOption() {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        // Get friend names from selected IDs
        String displayText = context.l10n.storyPrivacyNoOneSelected;
        if (state is FriendLoaded && _hiddenFriendIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _hiddenFriendIds.contains(f.userId))
              .toList();

          if (selectedFriends.isEmpty) {
            displayText = context.l10n.storyPrivacyNoOneSelected;
          } else if (selectedFriends.length == 1) {
            displayText =
                selectedFriends.first.fullName ??
                selectedFriends.first.username ??
                context.l10n.storyPrivacyOnePerson;
          } else if (selectedFriends.length <= 3) {
            final names = selectedFriends
                .map((f) => f.fullName ?? f.username ?? context.l10n.commonUser)
                .join(", ");
            displayText = names;
          } else {
            final firstNames = selectedFriends
                .take(2)
                .map((f) => f.fullName ?? f.username ?? context.l10n.commonUser)
                .join(", ");
            final remaining = selectedFriends.length - 2;
            displayText = context.l10n.storyPrivacyAndOthers(
              firstNames,
              remaining,
            );
          }
        } else if (_hiddenFriendIds.isEmpty) {
          displayText = context.l10n.storyPrivacyNoOneSelected;
        }

        return GestureDetector(
          onTap: () async {
            // Set privacy type to "Ẩn tin với" first
            setState(() {
              _selectedPrivacy = _privacyFriendsExcept;
            });
            await _savePrivacy(_privacyFriendsExcept);
            if (!context.mounted) return;

            final selectedIds = await Navigator.of(context).push<List<String>>(
              MaterialPageRoute(
                builder: (_) => StoryFriendSelectionPage(
                  initialSelectedIds: _hiddenFriendIds,
                ),
              ),
            );

            if (selectedIds != null) {
              setState(() {
                _hiddenFriendIds = selectedIds;
              });
              await _saveHiddenFriendIds(selectedIds);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.rsh(context),
              horizontal: 12.rs(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.rsr(context)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.storyPrivacyHideFrom,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.rsh(context)),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.rsp(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                  size: 24.rsp(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomPrivacyOption() {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        // Get friend names from selected IDs
        String displayText = context.l10n.storyPrivacyNoOneSelected;
        if (state is FriendLoaded && _allowedFriendIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _allowedFriendIds.contains(f.userId))
              .toList();

          if (selectedFriends.isEmpty) {
            displayText = context.l10n.storyPrivacyNoOneSelected;
          } else if (selectedFriends.length == 1) {
            displayText =
                selectedFriends.first.fullName ??
                selectedFriends.first.username ??
                context.l10n.storyPrivacyOnePerson;
          } else if (selectedFriends.length <= 3) {
            final names = selectedFriends
                .map((f) => f.fullName ?? f.username ?? context.l10n.commonUser)
                .join(", ");
            displayText = names;
          } else {
            final firstNames = selectedFriends
                .take(2)
                .map((f) => f.fullName ?? f.username ?? context.l10n.commonUser)
                .join(", ");
            final remaining = selectedFriends.length - 2;
            displayText = context.l10n.storyPrivacyAndOthers(
              firstNames,
              remaining,
            );
          }
        } else if (_allowedFriendIds.isEmpty) {
          displayText = context.l10n.storyPrivacyNoOneSelected;
        }

        final isSelected = _selectedPrivacy == _privacyFriendsDetail;

        return GestureDetector(
          onTap: () async {
            // First select "Tùy chỉnh" option
            setState(() {
              _selectedPrivacy = _privacyFriendsDetail;
            });
            await _savePrivacy(_privacyFriendsDetail);
            if (!context.mounted) return;

            // Then navigate to friend selection page
            final selectedIds = await Navigator.of(context).push<List<String>>(
              MaterialPageRoute(
                builder: (_) => StoryFriendSelectionPage(
                  initialSelectedIds: _allowedFriendIds,
                  title: context.l10n.storySelectPeopleToShare,
                  allowEmptySelection: false,
                ),
              ),
            );

            if (selectedIds != null) {
              setState(() {
                _allowedFriendIds = selectedIds;
              });
              await _saveAllowedFriendIds(selectedIds);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12.rsh(context),
              horizontal: 12.rs(context),
            ),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.rsr(context)),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.rs(context),
                  height: 40.rs(context),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.iconPrimary,
                    size: 20.rsp(context),
                  ),
                ),
                SizedBox(width: 12.rs(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.storyPrivacyCustom,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.rsh(context)),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.rsp(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24.rs(context),
                  height: 24.rs(context),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 14.rs(context),
                            height: 14.rs(context),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
