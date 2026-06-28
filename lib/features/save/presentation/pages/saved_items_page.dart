import 'package:flutter/material.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/domain/usecases/get_post_detail_usecase.dart';
import 'package:social_app_fe/features/post/presentation/pages/post_detail_page.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_bloc.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_event.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_state.dart';
import 'package:social_app_fe/features/save/presentation/pages/widgets/saved_item_card.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_archived_stories_page.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({super.key});

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final GetPostDetailUsecase _getPostDetailUsecase = s1<GetPostDetailUsecase>();

  static const List<String> _fallbackCategories = ['Tất cả'];

  String _selectedCategory = 'Tất cả';
  List<String> _currentCategories = _fallbackCategories;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _openSavedItem(
    BuildContext context,
    String type,
    String id,
  ) async {
    if (type != 'post') {
      showErrorSnackBar(
        context,
        context.l10n.savedItemsOnlySupportPost,
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
          Center(child: CircularProgressIndicator(color: AppColors.primary)),
    );

    final result = await _getPostDetailUsecase(
      params: GetPostDetailParams(postId: id),
    );

    if (!context.mounted) return;
    Navigator.of(context).pop();

    if (result is DataStateSuccess<PostEntity> && result.data != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PostDetailPage(post: result.data!)),
      );
    } else {
      showErrorSnackBar(context, context.l10n.savedItemsCannotOpenPost);
    }
  }

  Future<void> _confirmRemoveSavedItem(
    BuildContext context,
    String savedId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          context.l10n.savedItemsUnsaveDialogTitle,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          context.l10n.savedItemsUnsaveDialogContent,
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              context.l10n.commonCancel,
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: Text(context.l10n.savedItemsUnsave),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<SavedItemsBloc>().add(RemoveSavedItem(savedId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<SavedItemsBloc>()..add(const LoadSavedItems()),
      child: Container(
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
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.iconPrimary,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                title: Text(
                  context.l10n.savedItemsPageTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.iconPrimary,
                    ),
                    onPressed: () {
                      // TODO: Handle search within saved items
                    },
                  ),
                ],
              ),
              body: Column(
                children: [
                  _buildArchivedStoriesTile(context),
                  _buildCategoryTabs(),
                  Expanded(
                    child: BlocConsumer<SavedItemsBloc, SavedItemsState>(
                      buildWhen: (previous, current) =>
                          current is! SavedItemsActionSuccess,
                      listener: (context, state) {
                        if (state is SavedItemsLoaded) {
                          _refreshController.refreshCompleted();
                          if (state.hasReachedMax) {
                            _refreshController.loadNoData();
                          } else {
                            _refreshController.loadComplete();
                          }
                        } else if (state is SavedItemsError) {
                          _refreshController.refreshFailed();
                          _refreshController.loadFailed();
                          showErrorSnackBar(context, state.message);
                        } else if (state is SavedItemsActionSuccess) {
                          showSuccessSnackBar(context, context.l10n.savedItemsUnsaveSuccess);
                        }
                      },
                      builder: (context, state) {
                        return _buildContent(context, state);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArchivedStoriesTile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        8.rsh(context),
        16.rs(context),
        8.rsh(context),
      ),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.rsr(context)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const SavedArchivedStoriesPage(),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 14.rs(context),
              vertical: 12.rsh(context),
            ),
            child: Row(
              children: [
                Container(
                  width: 44.rs(context),
                  height: 44.rs(context),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.rsr(context)),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: AppColors.primary,
                    size: 24.rsp(context),
                  ),
                ),
                SizedBox(width: 12.rs(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.savedItemsArchivedStoriesTitle,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        context.l10n.savedItemsArchivedStoriesSubtitle,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.textSecondary,
                  size: 24.rsp(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SavedItemsState state) {
    if (state is SavedItemsInitial || state is SavedItemsLoading) {
      return _buildLoadingGrid(key: const ValueKey('saved-loading'));
    }

    if (state is SavedItemsError) {
      return _buildInfoState(
        key: const ValueKey('saved-error'),
        icon: Icons.wifi_tethering_error_rounded,
        title: context.l10n.savedItemsLoadErrorTitle,
        message: context.l10n.savedItemsLoadErrorMessage,
        actionLabel: context.l10n.commonRetry,
        onAction: () {
          context.read<SavedItemsBloc>().add(
            const LoadSavedItems(isRefresh: true),
          );
        },
      );
    }

    if (state is SavedItemsLoaded) {
      if (state.items.isEmpty) {
        return _buildInfoState(
          key: ValueKey('saved-empty-${state.currentCategory}'),
          icon: Icons.bookmark_border_rounded,
          title: context.l10n.savedItemsEmptyTitle,
          message: state.currentCategory == 'Tất cả'
              ? context.l10n.savedItemsEmptyAllMessage
              : context.l10n.savedItemsEmptyFilterMessage,
        );
      }

      return SmartRefresher(
        key: ValueKey(
          'saved-list-${state.currentCategory}-${state.items.length}',
        ),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: !state.hasReachedMax,
        header: WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
        footer: ClassicFooter(
          loadingText: context.l10n.savedItemsLoadingMore,
          idleText: context.l10n.savedItemsPullToLoad,
          noDataText: context.l10n.savedItemsNoMoreData,
          failedText: context.l10n.savedItemsLoadFailed,
          canLoadingText: context.l10n.savedItemsReleaseToLoad,
        ),
        onRefresh: () {
          context.read<SavedItemsBloc>().add(
            const LoadSavedItems(isRefresh: true),
          );
        },
        onLoading: () {
          context.read<SavedItemsBloc>().add(const LoadSavedItems());
        },
        child: MasonryGridView.count(
          padding: EdgeInsets.fromLTRB(
            12.rs(context),
            8.rsh(context),
            12.rs(context),
            18.rsh(context),
          ),
          crossAxisCount: 2,
          mainAxisSpacing: 12.rs(context),
          crossAxisSpacing: 12.rs(context),
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            final item = state.items[index];
            return SavedItemCard(
              item: item,
              onTap: () => _openSavedItem(context, item.type, item.targetId),
              onRemove: () => _confirmRemoveSavedItem(context, item.id),
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadingGrid({Key? key}) {
    return MasonryGridView.count(
      key: key,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        12.rs(context),
        8.rsh(context),
        12.rs(context),
        18.rsh(context),
      ),
      crossAxisCount: 2,
      mainAxisSpacing: 12.rs(context),
      crossAxisSpacing: 12.rs(context),
      itemCount: 8,
      itemBuilder: (context, index) {
        final height = index % 3 == 0 ? 190.rsh(context) : 142.rsh(context);
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.secondBackground,
            borderRadius: BorderRadius.circular(16.rsr(context)),
            border: Border.all(color: AppColors.divider),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.rs(context)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.background
                          : const Color(0xFFE9EEF5),
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                    ),
                  ),
                ),
                SizedBox(height: 10.rsh(context)),
                _SkeletonLine(width: 100.rs(context)),
                SizedBox(height: 7.rsh(context)),
                _SkeletonLine(width: 72.rs(context)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoState({
    Key? key,
    required IconData icon,
    required String title,
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Center(
      key: key,
      child: Padding(
        padding: EdgeInsets.all(28.rs(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.rs(context),
              height: 64.rs(context),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 32.rsp(context),
              ),
            ),
            SizedBox(height: 14.rsh(context)),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.rsp(context),
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.rsh(context)),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.rsp(context),
                height: 1.35,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 16.rsh(context)),
              FilledButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return BlocBuilder<SavedItemsBloc, SavedItemsState>(
      builder: (context, state) {
        if (state is SavedItemsLoaded) {
          _selectedCategory = state.currentCategory;
          _currentCategories = state.categories;
        }

        return SizedBox(
          height: 54.rsh(context),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(
              16.rs(context),
              8.rsh(context),
              16.rs(context),
              10.rsh(context),
            ),
            itemCount: _currentCategories.length,
            itemBuilder: (context, index) {
              final category = _currentCategories[index];
              final isSelected = category == _selectedCategory;
              final isCollection = category.startsWith('BST: ');
              String label = isCollection
                  ? category.replaceFirst('BST: ', '')
                  : category;

              if (!isCollection) {
                switch (label) {
                  case 'Tất cả':
                    label = context.l10n.savedItemsCategoryAll;
                    break;
                  case 'Bài viết':
                    label = context.l10n.savedItemsCategoryPost;
                    break;
                  case 'Thước phim':
                    label = context.l10n.savedItemsCategoryReel;
                    break;
                  case 'Bình luận':
                    label = context.l10n.savedItemsCategoryComment;
                    break;
                }
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  context.read<SavedItemsBloc>().add(
                    ChangeCategoryTab(category),
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  margin: EdgeInsets.only(right: 12.rs(context)),
                  padding: EdgeInsets.symmetric(horizontal: 14.rs(context)),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.secondBackground,
                    borderRadius: BorderRadius.circular(999.rsr(context)),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                    ),
                    boxShadow:
                        isSelected &&
                            Theme.of(context).brightness != Brightness.dark
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.20),
                              blurRadius: 10,
                              offset: Offset(0, 4.rsh(context)),
                            ),
                          ]
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isCollection) ...[
                        Icon(
                          Icons.collections_bookmark_outlined,
                          size: 15.rsp(context),
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.rs(context)),
                      ],
                      Text(
                        label,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: isSelected
                              ? FontWeight.w800
                              : FontWeight.w600,
                          fontSize: 13.rsp(context),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 10.rsh(context),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
