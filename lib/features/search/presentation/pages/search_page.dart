import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_app_fe/features/search/presentation/pages/search_history_page.dart';
import 'package:social_app_fe/features/search/presentation/widgets/search_bar.dart'
    as search_widget;
import 'package:social_app_fe/features/search/presentation/widgets/search_history_item.dart';
import 'package:social_app_fe/features/search/presentation/widgets/search_result_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = ScrollController();
  BuildContext? _blocContext;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_blocContext == null) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      final state = _blocContext!.read<SearchBloc>().state;
      if (state is SearchLoaded && state.results.pagination.hasNextPage) {
        _blocContext!.read<SearchBloc>().add(const LoadMoreResults());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (_) => s1<SearchBloc>(),
      child: Builder(
        builder: (blocContext) {
          _blocContext = blocContext;
          _scrollController.removeListener(_onScroll);
          _scrollController.addListener(_onScroll);

          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    child: Row(
                      children: [
                        // Icon back
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            CupertinoIcons.back,
                            color: AppColors.iconPrimary,
                            size: 23.r,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        SizedBox(width: 4.w),
                        // Search Bar
                        Expanded(
                          child: search_widget.SearchBar(
                            onSearch: (query) {
                              // Khi nhập từng ký tự: tìm kiếm để hiển thị kết quả (không lưu lịch sử)
                              if (query.trim().isEmpty) {
                                blocContext.read<SearchBloc>().add(
                                  const ClearSearch(),
                                );
                              } else {
                                blocContext.read<SearchBloc>().add(
                                  SearchUsers(
                                    query: query,
                                    saveToHistory: false,
                                  ),
                                );
                              }
                            },
                            onSearchSubmitted: (query) {
                              // Khi nhấn Enter: tìm kiếm và lưu vào lịch sử
                              if (query.trim().isEmpty) {
                                blocContext.read<SearchBloc>().add(
                                  const ClearSearch(),
                                );
                              } else {
                                blocContext.read<SearchBloc>().add(
                                  SearchUsers(
                                    query: query,
                                    saveToHistory: true,
                                  ),
                                );
                              }
                            },
                            hintText: context.l10n.searchHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                  // Results
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchInitial) {
                          if (state.history != null &&
                              state.history!.isNotEmpty) {
                            return _buildSearchHistory(
                              state.history!,
                              blocContext,
                            );
                          }
                          return _buildEmptyState(
                            icon: CupertinoIcons.search,
                            message: context.l10n.searchEnterKeyword,
                          );
                        } else if (state is SearchLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          );
                        } else if (state is SearchError) {
                          return _buildErrorState(state.message, blocContext);
                        } else if (state is SearchLoaded) {
                          if (state.results.userResponseDtos.isEmpty) {
                            return _buildEmptyState(
                              icon: CupertinoIcons.person_circle,
                              message: context.l10n.searchNoResults,
                            );
                          }
                          return _buildResultsList(state, blocContext);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsList(SearchLoaded state, BuildContext blocContext) {
    return RefreshIndicator(
      onRefresh: () async {
        blocContext.read<SearchBloc>().add(SearchUsers(query: state.query));
      },
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount:
            state.results.userResponseDtos.length +
            (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.results.userResponseDtos.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return SearchResultItem(user: state.results.userResponseDtos[index]);
        },
      ),
    );
  }

  Widget _buildSearchHistory(List<dynamic> history, BuildContext blocContext) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.searchRecent,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (newContext) => BlocProvider<SearchBloc>.value(
                        value: blocContext.read<SearchBloc>(),
                        child: const SearchHistoryPage(),
                      ),
                    ),
                  );
                },
                child: Text(
                  context.l10n.commonViewAll,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: history.length,
            itemBuilder: (context, index) {
              return SearchHistoryItem(history: history[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64.r, color: AppColors.textSecondary),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message, [BuildContext? blocContext]) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.exclamationmark_triangle,
            size: 64.r,
            color: Colors.red[300],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          if (blocContext != null) ...[
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                final state = blocContext.read<SearchBloc>().state;
                if (state is SearchLoaded) {
                  blocContext.read<SearchBloc>().add(
                    SearchUsers(query: state.query),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: Text(context.l10n.commonRetry),
            ),
          ],
        ],
      ),
    );
  }
}
