import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_item_card.dart';
import 'package:social_app_fe/l10n/l10n.dart';

enum _CommunityFilter { all, publicOnly, privateOnly }

class CommunityListWidget extends StatefulWidget {
  CommunityListWidget({super.key});

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
    _searchDebounce = Timer(Duration(milliseconds: 400), () {
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
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        10.rsh(context),
        16.rs(context),
        8.rsh(context),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              height: 42.rsh(context),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(14.rsr(context)),
                border: Border.all(color: AppColors.divider),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textSecondary.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: context.l10n.communitySearchHint,
                  hintStyle: TextStyle(color: AppColors.textSecondary),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 18.rsp(context),
                    color: AppColors.textSecondary,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10.rsh(context),
                  ),
                ),
                style: TextStyle(color: AppColors.textPrimary),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          SizedBox(width: 10.rs(context)),
          Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
            child: PopupMenuButton<_CommunityFilter>(
              initialValue: _activeFilter,
              color: AppColors.background,
              padding: EdgeInsets.zero,
              onSelected: (value) {
                setState(() {
                  _activeFilter = value;
                });
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _CommunityFilter.all,
                  height: 34.rsh(context),
                  child: Text(
                    context.l10n.commonAll,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: _CommunityFilter.publicOnly,
                  height: 34.rsh(context),
                  child: Text(
                    context.l10n.communityPublicOnly,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: _CommunityFilter.privateOnly,
                  height: 34.rsh(context),
                  child: Text(
                    context.l10n.communityPrivateOnly,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 12.rsp(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.rsr(context)),
              ),
              child: Container(
                width: 34.rs(context),
                height: 34.rsh(context),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10.rsr(context)),
                  border: Border.all(color: AppColors.divider),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textSecondary.withValues(alpha: 0.08),
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
                      size: 16.rsp(context),
                      color: _activeFilter == _CommunityFilter.all
                          ? AppColors.textSecondary
                          : AppColors.primary,
                    ),
                    if (_activeFilter != _CommunityFilter.all)
                      Positioned(
                        right: 8.rs(context),
                        top: 8.rsh(context),
                        child: SizedBox(
                          width: 5.rs(context),
                          height: 5.rsh(context),
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
          return _CommunityListSkeleton();
        }

        if (state is CommunityListLoaded) {
          final filteredCommunities = _applyFilter(state.communities);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: _buildStickyHeader()),
              SliverToBoxAdapter(child: SizedBox(height: 8.rsh(context))),
              if (filteredCommunities.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.rs(context)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_2_outlined,
                            size: 54.rsp(context),
                            color: AppColors.textSecondary.withValues(
                              alpha: 0.75,
                            ),
                          ),
                          SizedBox(height: 12.rsh(context)),
                          Text(
                            state.searchQuery != null
                                ? context.l10n.communityNoSearchResults
                                : context.l10n.communityEmpty,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textSecondary,
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
                  padding: EdgeInsets.fromLTRB(
                    16.rs(context),
                    0,
                    16.rs(context),
                    20.rsh(context),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final community = filteredCommunities[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.rsh(context)),
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
              padding: EdgeInsets.symmetric(horizontal: 28.rs(context)),
              child: Text(
                localizedCommunityMessage(context.l10n, state.message),
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFFB42318)),
              ),
            ),
          );
        }

        return Center(child: Text(''));
      },
    );
  }
}

class _AnimatedIn extends StatelessWidget {
  final int index;
  final Widget child;

  _AnimatedIn({required this.index, required this.child});

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
  _CommunityListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        12.rsh(context),
        16.rs(context),
        20.rsh(context),
      ),
      children: [
        _SkeletonBlock(height: 52.rsh(context), radius: 18.rsr(context)),
        SizedBox(height: 10.rsh(context)),
        Row(
          children: [
            Expanded(
              child: _SkeletonBlock(
                height: 32.rsh(context),
                radius: 999.rsr(context),
              ),
            ),
            SizedBox(width: 8.rs(context)),
            Expanded(
              child: _SkeletonBlock(
                height: 32.rsh(context),
                radius: 999.rsr(context),
              ),
            ),
            SizedBox(width: 8.rs(context)),
            Expanded(
              child: _SkeletonBlock(
                height: 32.rsh(context),
                radius: 999.rsr(context),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.rsh(context)),
        _SkeletonCommunityCard(),
        SizedBox(height: 12.rsh(context)),
        _SkeletonCommunityCard(),
        SizedBox(height: 12.rsh(context)),
        _SkeletonCommunityCard(),
      ],
    );
  }
}

class _SkeletonCommunityCard extends StatelessWidget {
  _SkeletonCommunityCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 96.rsh(context),
      child: Container(
        padding: EdgeInsets.all(12.rs(context)),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12.rsr(context)),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          children: [
            _SkeletonCircle(size: 60.rsp(context)),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SkeletonBlock(
                    height: 14.rsh(context),
                    width: 140.rs(context),
                  ),
                  SizedBox(height: 6.rsh(context)),
                  _SkeletonBlock(
                    height: 12.rsh(context),
                    width: 100.rs(context),
                  ),
                  SizedBox(height: 6.rsh(context)),
                  _SkeletonBlock(
                    height: 12.rsh(context),
                    width: 180.rs(context),
                  ),
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

  _SkeletonCircle({required this.size});

  @override
  Widget build(BuildContext context) {
    return _SkeletonBlock(height: size, width: size, radius: 999.rsr(context));
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  _SkeletonBlock({required this.height, this.width, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 0.8),
      duration: Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: AppColors.textSecondary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        );
      },
      onEnd: () {},
    );
  }
}
