import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_item_card.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MyCommunitiesWidget extends StatefulWidget {
  MyCommunitiesWidget({super.key});

  @override
  State<MyCommunitiesWidget> createState() => _MyCommunitiesWidgetState();
}

class _MyCommunitiesWidgetState extends State<MyCommunitiesWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CommunityListBloc>().add(MyCommunitiesFetched());
      },
      child: BlocBuilder<CommunityListBloc, CommunityListState>(
        builder: (context, state) {
          if (state is CommunityListLoading) {
            return _MyCommunitiesSkeleton();
          }

          if (state is MyCommunitiesLoaded) {
            if (state.communities.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.rs(context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.group_off_rounded,
                        size: 54.rsp(context),
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                      SizedBox(height: 12.rsh(context)),
                      Text(
                        context.l10n.communityNoJoinedCommunities,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16.rs(context),
                12.rsh(context),
                16.rs(context),
                24.rsh(context),
              ),
              itemCount: state.communities.length,
              itemBuilder: (context, index) {
                final community = state.communities[index];
                return _AnimatedIn(
                  index: index,
                  child: CommunityItem(community: community),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
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
      ),
    );
  }
}

class _MyCommunitiesSkeleton extends StatelessWidget {
  _MyCommunitiesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        12.rsh(context),
        16.rs(context),
        24.rsh(context),
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        return _AnimatedIn(index: index, child: _CommunityItemSkeleton());
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
    );
  }
}

class _CommunityItemSkeleton extends StatelessWidget {
  _CommunityItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.rsr(context)),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondary.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12.rs(context),
          12.rsh(context),
          12.rs(context),
          12.rsh(context),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                _SkeletonBox(
                  width: 60.rs(context),
                  height: 60.rsh(context),
                  radius: 30.rsr(context),
                ),
                Positioned(
                  top: -4,
                  left: -4,
                  child: Container(
                    width: 24.rs(context),
                    height: 24.rsh(context),
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.divider, width: 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.rs(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SkeletonBox(
                          height: 16.rsh(context),
                          radius: 8.rsr(context),
                        ),
                      ),
                      SizedBox(width: 42.rs(context)),
                    ],
                  ),
                  SizedBox(height: 9.rsh(context)),
                  Row(
                    children: [
                      _SkeletonBox(
                        width: 14.rs(context),
                        height: 14.rsh(context),
                        radius: 7.rsr(context),
                      ),
                      SizedBox(width: 6.rs(context)),
                      _SkeletonBox(
                        width: 108.rs(context),
                        height: 12.rsh(context),
                        radius: 6.rsr(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.rsh(context)),
                  _SkeletonBox(
                    width: double.infinity,
                    height: 11.rsh(context),
                    radius: 6.rsr(context),
                  ),
                  SizedBox(height: 6.rsh(context)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: _SkeletonBox(
                          height: 11.rsh(context),
                          radius: 6.rsr(context),
                        ),
                      ),
                      SizedBox(width: 12.rs(context)),
                      _SkeletonBox(
                        width: 72.rs(context),
                        height: 30.rsh(context),
                        radius: 18.rsr(context),
                      ),
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

  _SkeletonBox({this.width, required this.height, required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
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
