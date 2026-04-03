import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_bloc.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_event.dart';
import 'package:social_app_fe/features/save/presentation/bloc/saved_items_state.dart';
import 'package:social_app_fe/features/save/presentation/pages/widgets/saved_item_card.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_archived_stories_page.dart';

class SavedItemsPage extends StatefulWidget {
  const SavedItemsPage({Key? key}) : super(key: key);

  @override
  State<SavedItemsPage> createState() => _SavedItemsPageState();
}

class _SavedItemsPageState extends State<SavedItemsPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final List<String> _categories = [
    'Tất cả',
    'Bài viết',
    'Thước phim',
    'Bình luận',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<SavedItemsBloc>()..add(const LoadSavedItems()),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
              icon: Icon(Icons.search, color: Theme.of(context).iconTheme.color),
              onPressed: () {
                // TODO: Handle search within saved items
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: ListTile(
                tileColor: AppColors.background,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                leading: const Icon(Icons.history),
                title: const Text('Tin lưu trữ'),
                subtitle: const Text('Xem lại các story đã đăng'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SavedArchivedStoriesPage(),
                    ),
                  );
                },
              ),
            ),
            _buildCategoryTabs(),
            Expanded(
              child: BlocConsumer<SavedItemsBloc, SavedItemsState>(
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
                  }
                },
                builder: (context, state) {
                  if (state is SavedItemsInitial ||
                      (state is SavedItemsLoading &&
                          context.read<SavedItemsBloc>().state is! SavedItemsLoaded)) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is SavedItemsError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is SavedItemsLoaded) {
                    if (state.items.isEmpty) {
                      return Center(
                        child: Text(
                          'Chưa có mục nào được lưu',
                          style: TextStyle(color: Colors.grey, fontSize: 16.sp),
                        ),
                      );
                    }

                    return SmartRefresher(
                      controller: _refreshController,
                      enablePullDown: true,
                      enablePullUp: !state.hasReachedMax,
                      onRefresh: () {
                        context
                            .read<SavedItemsBloc>()
                            .add(const LoadSavedItems(isRefresh: true));
                      },
                      onLoading: () {
                        context.read<SavedItemsBloc>().add(const LoadSavedItems());
                      },
                      child: MasonryGridView.count(
                        padding: EdgeInsets.all(8.w),
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.w,
                        crossAxisSpacing: 8.w,
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          return SavedItemCard(item: state.items[index]);
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return BlocBuilder<SavedItemsBloc, SavedItemsState>(
      builder: (context, state) {
        String currentCategory = 'Tất cả';
        if (state is SavedItemsLoaded) {
          currentCategory = state.currentCategory;
        }

        return Container(
          height: 48.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = category == currentCategory;

              return GestureDetector(
                onTap: () {
                  context.read<SavedItemsBloc>().add(ChangeCategoryTab(category));
                },
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.textSecondary.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : Colors.transparent,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.primary
                          : Theme.of(context).textTheme.bodyMedium?.color,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
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
