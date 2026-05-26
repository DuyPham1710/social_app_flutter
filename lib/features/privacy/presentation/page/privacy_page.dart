import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/enums/privacy_type.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/core/utils/privacy_util.dart';
import 'package:social_app_fe/features/auth/domain/entities/user_entity.dart';
import 'package:social_app_fe/features/friend/domain/entities/friend_entity.dart';
import 'package:social_app_fe/features/friend/presentation/bloc/friend_bloc.dart';
import 'package:social_app_fe/features/post/domain/repository/post_repository.dart';
import 'package:social_app_fe/features/privacy/domain/entities/privacy_entity.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_bloc.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_event.dart';
import 'package:social_app_fe/features/privacy/presentation/bloc/privacy_state.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_friend_selection_page.dart';
import 'package:social_app_fe/shared/helpers/privacy_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class PrivacyPage extends StatefulWidget {
  final String selectedOption;
  final String? postId; // Để cập nhật privacy của post đã tồn tại
  final PrivacyType? initialPrivacyType;
  final List<String>? initialFriendsExcept;
  final List<String>? initialFriendsDetail;

  const PrivacyPage({
    super.key,
    required this.selectedOption,
    this.postId,
    this.initialPrivacyType,
    this.initialFriendsExcept,
    this.initialFriendsDetail,
  });

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  late String selected;
  bool isSetAsDefault = false;
  bool shouldUpdateDefault = false;
  bool _isUpdatingPost = false;
  List<String> _friendsExceptIds = [];
  List<String> _friendsDetailIds = [];
  PostRepository? _postRepository;

  @override
  void initState() {
    super.initState();
    selected = widget.selectedOption;

    // Initialize PostRepository nếu có postId
    if (widget.postId != null) {
      _postRepository = s1<PostRepository>();
    }

    // Load initial friends từ widget parameters nếu có (cho post đã tồn tại)
    if (widget.initialFriendsExcept != null) {
      _friendsExceptIds = List.from(widget.initialFriendsExcept!);
    }
    if (widget.initialFriendsDetail != null) {
      _friendsDetailIds = List.from(widget.initialFriendsDetail!);
    }

    // Nếu có initialPrivacyType, convert sang label
    if (widget.initialPrivacyType != null) {
      selected = _privacyTypeToLabel(widget.initialPrivacyType!);
    }
  }

  final List<String> baseOptions = [
    'Công khai',
    'Bạn bè',
    'Bạn bè ngoại trừ...',
    'Bạn bè cụ thể',
    'Chỉ mình tôi',
  ];

  String _privacyTypeToLabel(PrivacyType privacyType) {
    switch (privacyType) {
      case PrivacyType.public:
        return "Công khai";
      case PrivacyType.friends:
        return "Bạn bè";
      case PrivacyType.friendsExcept:
        return "Bạn bè ngoại trừ...";
      case PrivacyType.friendsDetail:
        return "Bạn bè cụ thể";
      case PrivacyType.private:
        return "Chỉ mình tôi";
    }
  }

  String _localizedPrivacyLabel(BuildContext context, String label) {
    switch (label) {
      case 'Công khai':
        return context.l10n.privacyPostPublic;
      case 'Bạn bè':
        return context.l10n.privacyPostFriends;
      case 'Bạn bè ngoại trừ...':
        return context.l10n.privacyPostFriendsExcept;
      case 'Bạn bè cụ thể':
        return context.l10n.privacyPostSpecificFriends;
      case 'Chỉ mình tôi':
        return context.l10n.privacyPostOnlyMe;
      default:
        return label;
    }
  }

  String _localizedPrivacyDescription(BuildContext context, String label) {
    switch (label) {
      case 'Công khai':
        return context.l10n.privacyPostPublicDescription;
      case 'Bạn bè':
        return context.l10n.privacyPostFriendsDescription;
      case 'Bạn bè ngoại trừ...':
        return context.l10n.privacyPostFriendsExceptDescription;
      case 'Bạn bè cụ thể':
        return context.l10n.privacyPostSpecificFriendsDescription;
      case 'Chỉ mình tôi':
        return context.l10n.privacyPostOnlyMeDescription;
      default:
        return '';
    }
  }

  String _fallbackUserName(BuildContext context) {
    return context.l10n.privacyPostFallbackUser;
  }

  String _selectedFriendsSummary(
    BuildContext context,
    List<FriendEntity> selectedFriends,
  ) {
    if (selectedFriends.isEmpty) {
      return context.l10n.privacyPostNoOneSelected;
    }

    if (selectedFriends.length == 1) {
      return selectedFriends.first.fullName ??
          selectedFriends.first.username ??
          context.l10n.privacyPostOnePerson;
    }

    if (selectedFriends.length <= 3) {
      return selectedFriends
          .map(
            (friend) =>
                friend.fullName ??
                friend.username ??
                _fallbackUserName(context),
          )
          .join(', ');
    }

    final firstNames = selectedFriends
        .take(2)
        .map(
          (friend) =>
              friend.fullName ?? friend.username ?? _fallbackUserName(context),
        )
        .join(', ');
    return context.l10n.privacyPostAndOthers(
      firstNames,
      selectedFriends.length - 2,
    );
  }

  void _loadInitialFriends() {
    // Chỉ load từ PrivacyBloc khi không có postId (tạo post mới)
    if (widget.postId == null) {
      try {
        final currentState = context.read<PrivacyBloc>().state;
        if (currentState is PrivacyLoaded) {
          _friendsExceptIds =
              currentState.privacyEntity.friendsExcept
                  ?.map((e) => e.userId)
                  .toList() ??
              [];
          _friendsDetailIds =
              currentState.privacyEntity.friendsDetail
                  ?.map((e) => e.userId)
                  .toList() ??
              [];
        }
      } catch (_) {
        // PrivacyBloc không có trong context, giữ giá trị mặc định
      }
    }
  }

  List<UserEntity> _convertIdsToUserEntities(List<String> ids) {
    // Tạo UserEntity từ IDs (chỉ có userId, các field khác null)
    return ids.map((id) => UserEntity(userId: id)).toList();
  }

  Widget _buildContent(PrivacyState? state) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        _buildDescription(state),
        SizedBox(height: 16.h),
        _buildOptionsList(state),
        // Chỉ hiển thị toggle "Đặt làm mặc định" khi không phải edit post
        if (widget.postId == null && state != null) ...[
          SizedBox(height: 12.h),
          _buildDefaultToggle(state),
        ],
        if (_isUpdatingPost) ...[
          SizedBox(height: 12.h),
          Center(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: const CircularProgressIndicator(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContentWithoutBloc() {
    return _buildContent(null);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: AppColors.background,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: AppColors.background,
        border: Border(
          bottom: BorderSide(color: AppColors.divider, width: 0.5),
        ),
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            CupertinoIcons.chevron_back,
            color: AppColors.textSecondary,
          ),
        ),

        middle: Text(
          context.l10n.privacyPostQuestion,
          style: TextStyle(color: AppColors.textPrimary),
        ),

        trailing: GestureDetector(
          onTap: () async {
            // Nếu có postId, cập nhật privacy của post
            if (widget.postId != null && !shouldUpdateDefault) {
              await _updatePostPrivacy();
              return;
            }

            // Nếu cần update default privacy, gọi API trước khi close
            if (shouldUpdateDefault) {
              _updateDefaultPrivacy();
            } else {
              // Nếu có PrivacyBloc trong context (khi tạo post mới), update state
              try {
                context.read<PrivacyBloc>().add(
                  PrivacySelectionChanged(selectedPrivacy: selected),
                );
              } catch (_) {
                // PrivacyBloc không có trong context (khi edit post), bỏ qua
              }
              // Return cả label và danh sách bạn bè
              Navigator.pop(context, {
                'label': selected,
                'friendsExcept': _friendsExceptIds,
                'friendsDetail': _friendsDetailIds,
              });
            }
          },
          child: Text(
            context.l10n.commonDone,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),

      child: SafeArea(
        child: Material(
          color: AppColors.background,
          child: widget.postId != null
              ? _buildContentWithoutBloc()
              : BlocListener<PrivacyBloc, PrivacyState>(
                  listener: (context, state) {
                    if (state is PrivacyUpdated) {
                      showSuccessSnackBar(context, state.message);
                      // Sau khi update thành công, close page với Map format
                      Navigator.pop(context, {
                        'label': selected,
                        'friendsExcept': _friendsExceptIds,
                        'friendsDetail': _friendsDetailIds,
                      });
                    } else if (state is PrivacyError) {
                      showErrorSnackBar(context, state.message);
                    }
                  },
                  child: BlocBuilder<PrivacyBloc, PrivacyState>(
                    builder: (context, state) {
                      // Load initial friends on first build (chỉ khi không có postId)
                      if (widget.postId == null &&
                          state is PrivacyLoaded &&
                          _friendsExceptIds.isEmpty &&
                          _friendsDetailIds.isEmpty) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _loadInitialFriends();
                        });
                      }

                      return _buildContent(state);
                    },
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildDescription(PrivacyState? state) {
    String defaultPrivacy = widget.selectedOption;

    if (state is PrivacyLoaded) {
      defaultPrivacy = state.selectedPrivacy;
    }

    final defaultPrivacyLabel = _localizedPrivacyLabel(context, defaultPrivacy);
    String description = widget.postId != null
        ? context.l10n.privacyPostEditDescription
        : context.l10n.privacyPostCreateDescription(defaultPrivacyLabel);

    return Text(
      description,
      style: TextStyle(color: AppColors.textSecondary, height: 1.4),
    );
  }

  Widget _buildOptionsList(PrivacyState? state) {
    if (state is PrivacyLoading) {
      return Center(child: CupertinoActivityIndicator());
    }

    // Nếu có data từ backend, có thể thêm custom options từ privacyEntity
    if (state is PrivacyLoaded) {
      // Update selected value with backend data
      if (selected == widget.selectedOption) {
        selected = state.selectedPrivacy;
      }
    }

    if (state is PrivacyError) {
      return Column(
        children: [
          Text(
            context.l10n.postErrorPrefix(state.message),
            style: const TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16.h),
          ...baseOptions.map((item) => _buildOptionTile(item)),
        ],
      );
    }

    return Column(
      children: baseOptions.map((item) => _buildOptionTile(item)).toList(),
    );
  }

  Widget _buildOptionTile(String label) {
    final isSelected = selected == label;

    // Xử lý đặc biệt cho "Bạn bè ngoại trừ..." và "Bạn bè cụ thể"
    if (label == 'Bạn bè ngoại trừ...') {
      return _buildFriendsExceptTile(isSelected);
    } else if (label == 'Bạn bè cụ thể') {
      return _buildFriendsDetailTile(isSelected);
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Icon(getIcon(label), color: AppColors.textPrimary),

      title: Text(
        _localizedPrivacyLabel(context, label),
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),

      subtitle: Text(
        _localizedPrivacyDescription(context, label),
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
      ),

      trailing: Icon(
        isSelected
            ? CupertinoIcons.check_mark_circled_solid
            : CupertinoIcons.circle,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),

      onTap: () {
        setState(() {
          selected = label;
          // Reset shouldUpdateDefault khi đổi selection
          shouldUpdateDefault = false;
          isSetAsDefault = false;
          // Clear cả hai list khi chọn các privacy type khác
          if (label != 'Bạn bè ngoại trừ...' && label != 'Bạn bè cụ thể') {
            _friendsExceptIds = [];
            _friendsDetailIds = [];
          }
        });
      },
    );
  }

  Widget _buildFriendsExceptTile(bool isSelected) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        String displayText = context.l10n.privacyPostNoOneSelected;
        if (state is FriendLoaded && _friendsExceptIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _friendsExceptIds.contains(f.userId))
              .toList();

          displayText = _selectedFriendsSummary(context, selectedFriends);
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(
            getIcon('Bạn bè ngoại trừ...'),
            color: AppColors.textPrimary,
          ),
          title: Text(
            context.l10n.privacyPostFriendsExcept,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            displayText,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.textSecondary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Icon(
                isSelected
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ],
          ),
          onTap: () async {
            setState(() {
              selected = 'Bạn bè ngoại trừ...';
              shouldUpdateDefault = false;
              isSetAsDefault = false;
              // Clear friends_detail khi chọn friends_except
              _friendsDetailIds = [];
            });

            final selectedIds = await Navigator.of(context).push<List<String>>(
              MaterialPageRoute(
                builder: (_) => StoryFriendSelectionPage(
                  initialSelectedIds: _friendsExceptIds,
                  title: context.l10n.privacyPostHideFromTitle,
                ),
              ),
            );

            if (selectedIds != null) {
              setState(() {
                _friendsExceptIds = selectedIds;
                // Đảm bảo friends_detail luôn rỗng khi có friends_except
                _friendsDetailIds = [];
              });
            } else {
              // Nếu user hủy, vẫn đảm bảo friends_detail rỗng
              setState(() {
                _friendsDetailIds = [];
              });
            }
          },
        );
      },
    );
  }

  Widget _buildFriendsDetailTile(bool isSelected) {
    return BlocBuilder<FriendBloc, FriendState>(
      builder: (context, state) {
        String displayText = context.l10n.privacyPostNoOneSelected;
        if (state is FriendLoaded && _friendsDetailIds.isNotEmpty) {
          final selectedFriends = state.friends
              .where((f) => _friendsDetailIds.contains(f.userId))
              .toList();

          displayText = _selectedFriendsSummary(context, selectedFriends);
        }

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
          leading: Icon(getIcon('Bạn bè cụ thể'), color: AppColors.textPrimary),
          title: Text(
            context.l10n.privacyPostSpecificFriends,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            displayText,
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.chevron_right,
                color: AppColors.textSecondary,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Icon(
                isSelected
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.circle,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
            ],
          ),
          onTap: () async {
            setState(() {
              selected = 'Bạn bè cụ thể';
              shouldUpdateDefault = false;
              isSetAsDefault = false;
              // Clear friends_except khi chọn friends_detail
              _friendsExceptIds = [];
            });

            final selectedIds = await Navigator.of(context).push<List<String>>(
              MaterialPageRoute(
                builder: (_) => StoryFriendSelectionPage(
                  initialSelectedIds: _friendsDetailIds,
                  title: context.l10n.privacyPostSelectPeopleToShare,
                  allowEmptySelection: false,
                ),
              ),
            );

            if (selectedIds != null) {
              setState(() {
                _friendsDetailIds = selectedIds;
                // Đảm bảo friends_except luôn rỗng khi có friends_detail
                _friendsExceptIds = [];
              });
            } else {
              // Nếu user hủy, vẫn đảm bảo friends_except rỗng
              setState(() {
                _friendsExceptIds = [];
              });
            }
          },
        );
      },
    );
  }

  Widget _buildDefaultToggle(PrivacyState state) {
    // Check if current selected privacy is already the default
    bool isCurrentDefault = false;
    bool isUpdating = state is PrivacyUpdating;

    if (state is PrivacyLoaded) {
      // Convert current default privacy to label for comparison
      final currentDefaultLabel = PrivacyUtil.privacyTypeToLabel(
        state.privacyEntity.defaultPrivacy,
      );
      isCurrentDefault = selected == currentDefaultLabel;
    }

    return Row(
      children: [
        CupertinoSwitch(
          activeTrackColor: AppColors.primary,
          value: isCurrentDefault || isSetAsDefault,
          onChanged: isUpdating || isCurrentDefault
              ? null
              : (value) {
                  setState(() {
                    isSetAsDefault = value;
                    shouldUpdateDefault = value; // Set flag để biết cần update
                  });
                },
        ),

        SizedBox(width: 8.w),

        Expanded(
          child: Text(
            isCurrentDefault
                ? context.l10n.privacyPostCurrentDefault
                : context.l10n.privacyPostSetAsDefault,
            style: TextStyle(
              color: isCurrentDefault
                  ? AppColors.textSecondary.withOpacity(0.6)
                  : AppColors.textSecondary,
            ),
          ),
        ),
        if (isUpdating)
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: SizedBox(
              width: 16.w,
              height: 16.h,
              child: CupertinoActivityIndicator(),
            ),
          ),
      ],
    );
  }

  Future<void> _updatePostPrivacy() async {
    if (widget.postId == null || _postRepository == null || _isUpdatingPost)
      return;

    setState(() {
      _isUpdatingPost = true;
    });

    try {
      // Map từ UI privacy type sang PrivacyType enum
      PrivacyType privacyType;
      List<String>? friendsExcept;
      List<String>? friendsDetail;

      switch (selected) {
        case "Công khai":
          privacyType = PrivacyType.public;
          friendsExcept = null;
          friendsDetail = null;
        case "Bạn bè":
          privacyType = PrivacyType.friends;
          friendsExcept = null;
          friendsDetail = null;
        case "Bạn bè ngoại trừ...":
          privacyType = PrivacyType.friendsExcept;
          friendsExcept = _friendsExceptIds.isNotEmpty
              ? _friendsExceptIds
              : null;
          friendsDetail = null; // Đảm bảo friendsDetail luôn null
        case "Bạn bè cụ thể":
          privacyType = PrivacyType.friendsDetail;
          friendsExcept = null; // Đảm bảo friendsExcept luôn null
          friendsDetail = _friendsDetailIds.isNotEmpty
              ? _friendsDetailIds
              : null;
        case "Chỉ mình tôi":
          privacyType = PrivacyType.private;
          friendsExcept = null;
          friendsDetail = null;
        default:
          privacyType = PrivacyType.friends;
          friendsExcept = null;
          friendsDetail = null;
      }

      final result = await _postRepository!.updatePostPrivacy(
        postId: widget.postId!,
        privacyType: privacyType,
        friendsExcept: friendsExcept,
        friendsDetail: friendsDetail,
      );

      if (mounted) {
        if (result is DataStateSuccess) {
          showSuccessSnackBar(context, context.l10n.privacyPostUpdated);

          Navigator.pop(context, {
            'label': selected,
            'friendsExcept': _friendsExceptIds,
            'friendsDetail': _friendsDetailIds,
          });
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            context.l10n.postErrorPrefix(
              result.error?.message ?? context.l10n.privacyPostUpdateFailed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, context.l10n.postErrorPrefix(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPost = false;
        });
      }
    }
  }

  void _updateDefaultPrivacy() {
    try {
      final currentState = context.read<PrivacyBloc>().state;
      if (currentState is PrivacyLoaded && shouldUpdateDefault) {
        // Create updated privacy entity with new default
        final newDefaultPrivacy = PrivacyUtil.labelToPrivacyType(selected);

        // Convert IDs to UserEntity list - chỉ một trong hai list có dữ liệu
        List<UserEntity>? friendsExcept;
        List<UserEntity>? friendsDetail;

        if (selected == 'Bạn bè ngoại trừ...') {
          friendsExcept = _friendsExceptIds.isNotEmpty
              ? _convertIdsToUserEntities(_friendsExceptIds)
              : null;
          friendsDetail = null; // Đảm bảo friendsDetail luôn null
        } else if (selected == 'Bạn bè cụ thể') {
          friendsExcept = null; // Đảm bảo friendsExcept luôn null
          friendsDetail = _friendsDetailIds.isNotEmpty
              ? _convertIdsToUserEntities(_friendsDetailIds)
              : null;
        } else {
          // Các privacy type khác, cả hai list đều null
          friendsExcept = null;
          friendsDetail = null;
        }

        final updatedEntity = PrivacyEntity(
          defaultPrivacy: newDefaultPrivacy,
          friendsExcept: friendsExcept,
          friendsDetail: friendsDetail,
        );

        context.read<PrivacyBloc>().add(
          SetDefaultPrivacyRequested(privacyEntity: updatedEntity),
        );
      } else {
        // Không cần update, return với Map format
        Navigator.pop(context, {
          'label': selected,
          'friendsExcept': _friendsExceptIds,
          'friendsDetail': _friendsDetailIds,
        });
      }
    } catch (_) {
      // PrivacyBloc không có trong context, return với Map format
      Navigator.pop(context, {
        'label': selected,
        'friendsExcept': _friendsExceptIds,
        'friendsDetail': _friendsDetailIds,
      });
    }
  }
}
