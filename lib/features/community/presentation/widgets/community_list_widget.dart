import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_item_card.dart';

enum _CommunityFilter { all, publicOnly, privateOnly }

class CommunityListWidget extends StatefulWidget {
  const CommunityListWidget({super.key});

  @override
  State<CommunityListWidget> createState() => _CommunityListWidgetState();
}

class _CommunityListWidgetState extends State<CommunityListWidget> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _searchDebounce;
  _CommunityFilter _activeFilter = _CommunityFilter.all;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 350), () {
      if (!mounted) {
        return;
      }
      context.read<CommunityListBloc>().add(
        CommunityListSearched(value.trim()),
      );
    });
  }

  List<dynamic> _applyFilter(List<dynamic> communities) {
    switch (_activeFilter) {
      case _CommunityFilter.publicOnly:
        return communities
            .where(
              (community) => (community.status ?? '').toString() == 'public',
            )
            .toList();
      case _CommunityFilter.privateOnly:
        return communities
            .where(
              (community) => (community.status ?? '').toString() == 'private',
            )
            .toList();
      case _CommunityFilter.all:
        return communities;
    }
  }

  Widget _buildStickyHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5EAF0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D0F172A),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Tìm cộng đồng...',
                  prefixIcon: Icon(Icons.search_rounded, size: 18),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: PopupMenuButton<_CommunityFilter>(
              initialValue: _activeFilter,
              color: Colors.white,
              padding: EdgeInsets.zero,
              onSelected: (value) {
                setState(() {
                  _activeFilter = value;
                });
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: _CommunityFilter.all,
                  height: 34,
                  child: Text(
                    'Tất cả',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                PopupMenuItem(
                  value: _CommunityFilter.publicOnly,
                  height: 34,
                  child: Text(
                    'Công khai',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                PopupMenuItem(
                  value: _CommunityFilter.privateOnly,
                  height: 34,
                  child: Text(
                    'Riêng tư',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE5EAF0)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D0F172A),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      size: 16,
                      color: _activeFilter == _CommunityFilter.all
                          ? const Color(0xFF344054)
                          : AppColors.primary,
                    ),
                    if (_activeFilter != _CommunityFilter.all)
                      const Positioned(
                        right: 8,
                        top: 8,
                        child: SizedBox(
                          width: 5,
                          height: 5,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommunityListBloc, CommunityListState>(
      builder: (context, state) {
        if (state is CommunityListLoading) {
          return const _CommunityListSkeleton();
        }

        if (state is CommunityListLoaded) {
          final filteredCommunities = _applyFilter(state.communities);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildStickyHeader()),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
              if (filteredCommunities.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_2_outlined,
                            size: 54,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            state.searchQuery != null
                                ? 'Không tìm thấy cộng đồng phù hợp'
                                : 'Chưa có cộng đồng nào',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final community = filteredCommunities[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _AnimatedIn(
                          index: index,
                          child: CommunityItem(community: community),
                        ),
                      );
                    }, childCount: filteredCommunities.length),
                  ),
                ),
            ],
          );
        }

        if (state is CommunityListError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                state.message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFFB42318)),
              ),
            ),
          );
        }

        return const Center(child: Text(''));
      },
    );
  }
}

class _AnimatedIn extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedIn({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final delayMs = (index * 45).clamp(0, 500);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 280 + delayMs),
      curve: Curves.easeOutCubic,
      builder: (context, value, builtChild) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: builtChild,
          ),
        );
      },
      child: child,
    );
  }
}

class _CommunityListSkeleton extends StatelessWidget {
  const _CommunityListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
      children: const [
        _SkeletonBlock(height: 52, radius: 18),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _SkeletonBlock(height: 32, radius: 999)),
            SizedBox(width: 8),
            Expanded(child: _SkeletonBlock(height: 32, radius: 999)),
            SizedBox(width: 8),
            Expanded(child: _SkeletonBlock(height: 32, radius: 999)),
          ],
        ),
        SizedBox(height: 14),
        _SkeletonCommunityCard(),
        SizedBox(height: 12),
        _SkeletonCommunityCard(),
        SizedBox(height: 12),
        _SkeletonCommunityCard(),
      ],
    );
  }
}

class _SkeletonCommunityCard extends StatelessWidget {
  const _SkeletonCommunityCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5EAF0)),
        ),
        child: const Row(
          children: [
            _SkeletonCircle(size: 60),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBlock(height: 14, width: 140),
                  SizedBox(height: 6),
                  _SkeletonBlock(height: 12, width: 100),
                  SizedBox(height: 6),
                  _SkeletonBlock(height: 12, width: 180),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonCircle extends StatelessWidget {
  final double size;

  const _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return _SkeletonBlock(height: size, width: size, radius: 999);
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const _SkeletonBlock({required this.height, this.width, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 0.8),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: const Color(0xFFE4E7EC),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }
}
