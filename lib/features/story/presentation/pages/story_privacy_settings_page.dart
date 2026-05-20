import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/local/story_privacy_storage.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/story/domain/repository/story_repository.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_friend_selection_page.dart';
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
  String _selectedPrivacy = "Bạn bè"; // Default: Friends
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
          _selectedPrivacy = savedPrivacy;
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

    // Nếu có storyId và đang chọn "Ẩn tin với", gọi API
    if (widget.storyId != null && _selectedPrivacy == "Ẩn tin với") {
      await _updateStoryPrivacy(_selectedPrivacy);
    }
  }

  Future<void> _saveAllowedFriendIds(List<String> friendIds) async {
    await StoryPrivacyStorage.saveAllowedFriendIds(friendIds);

    // Nếu có storyId và đang chọn "Tùy chỉnh", gọi API
    if (widget.storyId != null && _selectedPrivacy == "Tùy chỉnh") {
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
        case "Công khai":
          privacyType = PrivacyType.public;
        case "Bạn bè":
          privacyType = PrivacyType.friends;
        case "Ẩn tin với":
          privacyType = PrivacyType.friendsExcept;
          friendsExcept = _hiddenFriendIds.isNotEmpty ? _hiddenFriendIds : null;
        case "Tùy chỉnh":
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
          showSuccessSnackBar(context, 'Đã cập nhật quyền riêng tư');
        }
      } else if (result is DataStateError) {
        if (mounted) {
          showErrorSnackBar(
            context,
            'Lỗi: ${result.error?.message ?? "Không thể cập nhật quyền riêng tư"}',
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Lỗi: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }
    return Scaffold(
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
          "Quyền riêng tư của tin",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24.h),
              // Who can see your story section
              _buildWhoCanSeeSection(),
            ],
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
          "Ai có thể xem tin của bạn?",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8.h),
        Text(
          "Tin của bạn sẽ hiển thị trong 24 giờ.",
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
        ),
        SizedBox(height: 20.h),
        _buildPrivacyOption(
          icon: Icons.public,
          title: "Công khai",
          description: "Bất kỳ ai",
          value: "Công khai",
        ),
        SizedBox(height: 16.h),
        _buildPrivacyOption(
          icon: Icons.people,
          title: "Bạn bè",
          description: "Chỉ bạn bè của bạn",
          value: "Bạn bè",
        ),
        SizedBox(height: 16.h),
        _buildHideStoryOption(),
        SizedBox(height: 16.h),
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
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.iconPrimary, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    description,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24.w,
              height: 24.w,
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
                        width: 14.w,
                        height: 14.w,
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
        String displayText = "Chưa chọn ai";
        if (state is FriendLoaded && _hiddenFriendIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _hiddenFriendIds.contains(f.userId))
              .toList();

          if (selectedFriends.isEmpty) {
            displayText = "Chưa chọn ai";
          } else if (selectedFriends.length == 1) {
            displayText =
                selectedFriends.first.fullName ??
                selectedFriends.first.username ??
                "1 người";
          } else if (selectedFriends.length <= 3) {
            final names = selectedFriends
                .map((f) => f.fullName ?? f.username ?? "Người dùng")
                .join(", ");
            displayText = names;
          } else {
            final firstNames = selectedFriends
                .take(2)
                .map((f) => f.fullName ?? f.username ?? "Người dùng")
                .join(", ");
            final remaining = selectedFriends.length - 2;
            displayText = "$firstNames và $remaining người khác";
          }
        } else if (_hiddenFriendIds.isEmpty) {
          displayText = "Chưa chọn ai";
        }

        return GestureDetector(
          onTap: () async {
            // Set privacy type to "Ẩn tin với" first
            setState(() {
              _selectedPrivacy = "Ẩn tin với";
            });
            await _savePrivacy("Ẩn tin với");

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
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ẩn tin với",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
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
                  size: 24.sp,
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
        String displayText = "Chưa chọn ai";
        if (state is FriendLoaded && _allowedFriendIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _allowedFriendIds.contains(f.userId))
              .toList();

          if (selectedFriends.isEmpty) {
            displayText = "Chưa chọn ai";
          } else if (selectedFriends.length == 1) {
            displayText =
                selectedFriends.first.fullName ??
                selectedFriends.first.username ??
                "1 người";
          } else if (selectedFriends.length <= 3) {
            final names = selectedFriends
                .map((f) => f.fullName ?? f.username ?? "Người dùng")
                .join(", ");
            displayText = names;
          } else {
            final firstNames = selectedFriends
                .take(2)
                .map((f) => f.fullName ?? f.username ?? "Người dùng")
                .join(", ");
            final remaining = selectedFriends.length - 2;
            displayText = "$firstNames và $remaining người khác";
          }
        } else if (_allowedFriendIds.isEmpty) {
          displayText = "Chưa chọn ai";
        }

        final isSelected = _selectedPrivacy == "Tùy chỉnh";

        return GestureDetector(
          onTap: () async {
            // First select "Tùy chỉnh" option
            setState(() {
              _selectedPrivacy = "Tùy chỉnh";
            });
            await _savePrivacy("Tùy chỉnh");

            // Then navigate to friend selection page
            final selectedIds = await Navigator.of(context).push<List<String>>(
              MaterialPageRoute(
                builder: (_) => StoryFriendSelectionPage(
                  initialSelectedIds: _allowedFriendIds,
                  title: "Chọn người để chia sẻ tin",
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
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.secondBackground,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    color: AppColors.iconPrimary,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tùy chỉnh",
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        displayText,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24.w,
                  height: 24.w,
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
                            width: 14.w,
                            height: 14.w,
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
