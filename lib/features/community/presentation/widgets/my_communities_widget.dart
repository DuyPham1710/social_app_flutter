import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_item_card.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MyCommunitiesWidget extends StatefulWidget {
  const MyCommunitiesWidget({super.key});

  @override
  State<MyCommunitiesWidget> createState() => _MyCommunitiesWidgetState();
}

class _MyCommunitiesWidgetState extends State<MyCommunitiesWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CommunityListBloc>().add(const MyCommunitiesFetched());
      },
      child: BlocBuilder<CommunityListBloc, CommunityListState>(
        builder: (context, state) {
          if (state is CommunityListLoading) {
            return const _MyCommunitiesSkeleton();
          }

          if (state is MyCommunitiesLoaded) {
            if (state.communities.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_off_rounded,
                        size: 54,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        context.l10n.communityNoJoinedCommunities,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.communities.length,
              itemBuilder: (context, index) {
                final community = state.communities[index];
                return _AnimatedIn(
                  index: index,
                  child: CommunityItem(community: community),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 12),
            );
          }

          if (state is CommunityListError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Text(
                  localizedCommunityMessage(context.l10n, state.message),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFB42318)),
                ),
              ),
            );
          }

          return const Center(child: Text(''));
        },
      ),
    );
  }
}

class _MyCommunitiesSkeleton extends StatelessWidget {
  const _MyCommunitiesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _AnimatedIn(index: index, child: const _CommunityItemSkeleton());
      },
      separatorBuilder: (_, __) => const SizedBox(height: 12),
    );
  }
}

class _CommunityItemSkeleton extends StatelessWidget {
  const _CommunityItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE3EA), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F0F172A),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const _SkeletonBox(width: 60, height: 60, radius: 30),
                Positioned(
                  top: -4,
                  left: -4,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9EEF5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFDDE3EA),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Expanded(child: _SkeletonBox(height: 16, radius: 8)),
                      SizedBox(width: 42),
                    ],
                  ),
                  const SizedBox(height: 9),
                  const Row(
                    children: [
                      _SkeletonBox(width: 14, height: 14, radius: 7),
                      SizedBox(width: 6),
                      _SkeletonBox(width: 108, height: 12, radius: 6),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const _SkeletonBox(
                    width: double.infinity,
                    height: 11,
                    radius: 6,
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(child: _SkeletonBox(height: 11, radius: 6)),
                      SizedBox(width: 12),
                      _SkeletonBox(width: 72, height: 30, radius: 18),
                    ],
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

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const _SkeletonBox({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9EEF5),
        borderRadius: BorderRadius.circular(radius),
      ),
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
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, (1 - value) * 30),
          child: child,
        ),
      ),
      child: child,
    );
  }
}
