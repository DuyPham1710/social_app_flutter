import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_bloc.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_event.dart';
import 'package:social_app_fe/features/home/presentation/bloc/home_state.dart';
import 'package:social_app_fe/features/home/presentation/widgets/home_header_widget.dart';
import 'package:social_app_fe/features/home/presentation/widgets/home_stories_widget.dart';
import 'package:social_app_fe/shared/component/custom_refresh_header.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    // load post lần đầu khi vào trang
    context.read<HomeBloc>().add(LoadPosts(page: 1, limit: 10));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    // TODO: call API reload posts
    //context.read<HomeBloc>().add(RefreshPosts());
    await Future.delayed(const Duration(seconds: 2));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded || state is HomeError) {
            _refreshController.refreshCompleted();
          }
        },

        builder: (context, state) {
          return SmartRefresher(
            // add RefreshStyle
            controller: _refreshController,
            enablePullDown: true,
            header: const CustomRefreshHeader(
              icon: Icon(CupertinoIcons.house_fill, color: Colors.grey),
            ),
            onRefresh: _onRefresh,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                HomeHeaderWidget(),
                HomeStoriesWidget(),

                if (state is HomeLoading)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                if (state is HomeError)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        state.errorMessage ?? "Không thể tải bài viết",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),

                if (state is HomeLoaded)
                  ListView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // tránh scroll lồng nhau
                    shrinkWrap: true, // giúp list con chiếm chiều cao vừa đủ
                    itemCount: state.posts?.length,
                    itemBuilder: (context, index) {
                      return PostItem(post: state.posts![index]);
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
