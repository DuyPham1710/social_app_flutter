import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/widgets/my_invites_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MyInvitesWidget extends StatefulWidget {
  MyInvitesWidget({super.key});

  @override
  State<MyInvitesWidget> createState() => _MyInvitesWidgetState();
}

class _MyInvitesWidgetState extends State<MyInvitesWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CommunityListBloc>().add(MyInvitesFetched());
      },
      child: BlocBuilder<CommunityListBloc, CommunityListState>(
        builder: (context, state) {
          if (state is CommunityListLoading) {
            return const _MyInvitesSkeleton();
          }

          if (state is MyInvitesLoaded) {
            if (state.invites.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.rs(context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        size: 54.rsp(context),
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                      SizedBox(height: 12.rsh(context)),
                      Text(
                        context.l10n.communityNoInvites,
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
              itemCount: state.invites.length,
              itemBuilder: (context, index) {
                final invite = state.invites[index];
                return _AnimatedIn(
                  index: index,
                  child: MyInvitesItem(invite: invite),
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
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 16),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _MyInvitesSkeleton extends StatelessWidget {
  const _MyInvitesSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        16.rs(context),
        12.rsh(context),
        16.rs(context),
        24.rsh(context),
      ),
      itemCount: 3,
      separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
      itemBuilder: (_, __) => const _InviteSkeletonCard(),
    );
  }
}

class _InviteSkeletonCard extends StatelessWidget {
  const _InviteSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.rs(context)),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18.rsr(context)),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          _SkeletonBlock(
            height: 48.rsh(context),
            width: 48.rs(context),
            radius: 999.rsr(context),
          ),
          SizedBox(width: 12.rs(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(height: 14.rsh(context), width: 150.rs(context)),
                SizedBox(height: 8.rsh(context)),
                _SkeletonBlock(height: 12.rsh(context), width: 170.rs(context)),
                SizedBox(height: 10.rsh(context)),
                Row(
                  children: [
                    Expanded(
                      child: _SkeletonBlock(
                        height: 34.rsh(context),
                        radius: 10.rsr(context),
                      ),
                    ),
                    SizedBox(width: 8.rs(context)),
                    Expanded(
                      child: _SkeletonBlock(
                        height: 34.rsh(context),
                        radius: 10.rsr(context),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;

  const _SkeletonBlock({required this.height, this.width, this.radius = 10});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
