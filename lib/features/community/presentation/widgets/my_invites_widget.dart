import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/features/community/presentation/widgets/my_invites_item.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class MyInvitesWidget extends StatefulWidget {
  const MyInvitesWidget({super.key});

  @override
  State<MyInvitesWidget> createState() => _MyInvitesWidgetState();
}

class _MyInvitesWidgetState extends State<MyInvitesWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CommunityListBloc>().add(const MyInvitesFetched());
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
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mark_email_unread_outlined,
                        size: 54,
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                      const SizedBox(height: 12),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: state.invites.length,
              itemBuilder: (context, index) {
                final invite = state.invites[index];
                return _AnimatedIn(
                  index: index,
                  child: MyInvitesItem(invite: invite),
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const _InviteSkeletonCard(),
    );
  }
}

class _InviteSkeletonCard extends StatelessWidget {
  const _InviteSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: const Row(
        children: [
          _SkeletonBlock(height: 48, width: 48, radius: 999),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBlock(height: 14, width: 150),
                SizedBox(height: 8),
                _SkeletonBlock(height: 12, width: 170),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: _SkeletonBlock(height: 34, radius: 10)),
                    SizedBox(width: 8),
                    Expanded(child: _SkeletonBlock(height: 34, radius: 10)),
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
