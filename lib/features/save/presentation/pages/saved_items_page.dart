import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        'Hiện chỉ hỗ trợ xem chi tiết bài viết đã lưu',
      );
      return;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
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
      showErrorSnackBar(context, 'Không thể mở bài viết đã lưu');
    }
  }

  Future<void> _confirmRemoveSavedItem(
    BuildContext context,
    String savedId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Bỏ lưu mục này?'),
        content: const Text('Mục này sẽ được xóa khỏi danh sách đã lưu.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Bỏ lưu'),
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
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),
        appBar: AppBar(
          backgroundColor: const Color(0xFFF7F8FA),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Đã lưu',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                Icons.search_rounded,
                color: Theme.of(context).iconTheme.color,
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
                    showSuccessSnackBar(context, state.message);
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
    );
  }

  Widget _buildArchivedStoriesTile(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      child: Material(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16.r),
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
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.history_rounded,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tin lưu trữ',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Xem lại các story đã đăng',
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
                  size: 24.sp,
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
        title: 'Không thể tải danh sách đã lưu',
        message: 'Kiểm tra kết nối rồi thử lại.',
        actionLabel: 'Thử lại',
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
          title: 'Chưa có mục nào',
          message: state.currentCategory == 'Tất cả'
              ? 'Các bài viết bạn lưu sẽ xuất hiện ở đây.'
              : 'Không có mục phù hợp với bộ lọc này.',
        );
      }

      return SmartRefresher(
        key: ValueKey(
          'saved-list-${state.currentCategory}-${state.items.length}',
        ),
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: !state.hasReachedMax,
        header: const WaterDropMaterialHeader(
          backgroundColor: AppColors.primary,
          color: Colors.white,
        ),
        footer: const ClassicFooter(
          loadingText: 'Đang tải thêm...',
          idleText: 'Kéo để tải thêm',
          noDataText: 'Đã hiển thị hết',
          failedText: 'Không tải được',
          canLoadingText: 'Thả để tải thêm',
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
          padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 18.h),
          crossAxisCount: 2,
          mainAxisSpacing: 12.w,
          crossAxisSpacing: 12.w,
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
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 18.h),
      crossAxisCount: 2,
      mainAxisSpacing: 12.w,
      crossAxisSpacing: 12.w,
      itemCount: 8,
      itemBuilder: (context, index) {
        final height = index % 3 == 0 ? 190.h : 142.h;
        return Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: const Color(0xFFE9EEF5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                _SkeletonLine(width: 100.w),
                SizedBox(height: 7.h),
                _SkeletonLine(width: 72.w),
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
        padding: EdgeInsets.all(28.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.primary, size: 32.sp),
            ),
            SizedBox(height: 14.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.35,
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 16.h),
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
          height: 54.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 10.h),
            itemCount: _currentCategories.length,
            itemBuilder: (context, index) {
              final category = _currentCategories[index];
              final isSelected = category == _selectedCategory;
              final isCollection = category.startsWith('BST: ');
              final label = isCollection
                  ? category.replaceFirst('BST: ', '')
                  : category;

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
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFFE4E7EC),
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.20),
                              blurRadius: 10,
                              offset: Offset(0, 4.h),
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
                          size: 15.sp,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                        ),
                        SizedBox(width: 6.w),
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
                          fontSize: 13.sp,
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
      height: 10.h,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
