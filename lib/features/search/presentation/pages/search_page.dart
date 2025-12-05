import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/search/presentation/bloc/search_bloc.dart';
import 'package:social_app_fe/features/search/presentation/widgets/search_bar.dart' as search_widget;
import 'package:social_app_fe/features/search/presentation/widgets/search_result_item.dart';

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
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            automaticallyImplyLeading: false,
            title: const Text('Tìm kiếm'),
          ),
          body: SafeArea(
            child: Column(
              children: [
                // Search Bar
                search_widget.SearchBar(
                  onSearch: (query) {
                    if (query.trim().isEmpty) {
                      blocContext.read<SearchBloc>().add(const ClearSearch());
                    } else {
                      blocContext.read<SearchBloc>().add(SearchUsers(query: query));
                    }
                  },
                  hintText: 'Tìm kiếm theo tên hoặc username...',
                ),
                SizedBox(height: 8.h),
                // Results
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (context, state) {
                      if (state is SearchInitial) {
                        return _buildEmptyState(
                          icon: CupertinoIcons.search,
                          message: 'Nhập từ khóa để tìm kiếm',
                        );
                      } else if (state is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                    } else if (state is SearchError) {
                      return _buildErrorState(state.message, blocContext);
                    } else if (state is SearchLoaded) {
                        if (state.results.userResponseDtos.isEmpty) {
                          return _buildEmptyState(
                            icon: CupertinoIcons.person_circle,
                            message: 'Không tìm thấy kết quả nào',
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
          ));
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
        itemCount: state.results.userResponseDtos.length +
            (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.results.userResponseDtos.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }
          return SearchResultItem(
            user: state.results.userResponseDtos[index],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64.r,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.grey[600],
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
              color: Colors.grey[700],
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
                  blocContext.read<SearchBloc>().add(SearchUsers(query: state.query));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Thử lại'),
            ),
          ],
        ],
      ),
    );
  }
}

