import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_list_bloc.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_detail_page.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class PendingCommunitiesWidget extends StatefulWidget {
  PendingCommunitiesWidget({super.key});

  @override
  State<PendingCommunitiesWidget> createState() =>
      _PendingCommunitiesWidgetState();
}

class _PendingCommunitiesWidgetState extends State<PendingCommunitiesWidget> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<CommunityListBloc>().add(PendingCommunitiesFetched());
      },
      child: BlocConsumer<CommunityListBloc, CommunityListState>(
        listener: (context, state) {
          if (state is CommunityListActionSuccess) {
            showSuccessSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          } else if (state is CommunityListError) {
            showErrorSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          }
        },
        builder: (context, state) {
          if (state is CommunityListLoading) {
            return const _PendingCommunitiesSkeleton();
          }

          if (state is PendingCommunitiesLoaded) {
            if (state.communities.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.rs(context)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hourglass_empty_rounded,
                        size: 54.rsp(context),
                        color: AppColors.textSecondary.withValues(alpha: 0.75),
                      ),
                      SizedBox(height: 12.rsh(context)),
                      Text(
                        context.l10n.communityNoPendingCommunities,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8.rsh(context)),
                      Text(
                        context.l10n.communityPendingCommunitiesHint,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12.rsp(context),
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
                  child: PendingCommunityItem(community: community),
                );
              },
              separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
            );
          }

          if (state is CommunityListError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28.rs(context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48.rsp(context),
                      color: Colors.red[400],
                    ),
                    SizedBox(height: 12.rsh(context)),
                    Text(
                      localizedCommunityMessage(context.l10n, state.message),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Color(0xFFB42318)),
                    ),
                    SizedBox(height: 16.rsh(context)),
                    ElevatedButton(
                      onPressed: () {
                        context.read<CommunityListBloc>().add(
                          PendingCommunitiesFetched(),
                        );
                      },
                      child: Text(context.l10n.commonRetry),
                    ),
                  ],
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

class PendingCommunityItem extends StatelessWidget {
  final dynamic community;

  PendingCommunityItem({super.key, required this.community});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = community.avatar as String?;
    final description = (community.description as String?) ?? '';
    final memberCount = (community.memberCount as int?) ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.rsr(context)),
        onTap: () {
          Navigator.of(
            context,
          ).push(CommunityDetailPage.route(communityId: community.id));
        },
        child: Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with avatar and info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.textSecondary.withValues(
                                  alpha: 0.08,
                                ),
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 28.rsr(context),
                            backgroundColor: AppColors.secondBackground,
                            backgroundImage:
                                (avatarUrl != null && avatarUrl.isNotEmpty)
                                ? NetworkImage(avatarUrl)
                                : null,
                            child: (avatarUrl == null || avatarUrl.isEmpty)
                                ? Icon(
                                    Icons.groups_rounded,
                                    color: AppColors.primary,
                                    size: 28.rsp(context),
                                  )
                                : null,
                          ),
                        ),
                        // Pending badge
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(4.rs(context)),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.background,
                                width: 1.5.rs(context),
                              ),
                            ),
                            child: Icon(
                              Icons.hourglass_bottom_outlined,
                              color: Colors.white,
                              size: 12.rsp(context),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.rs(context)),
                    // Community info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            community.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.rsp(context),
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.rsh(context)),
                          Text(
                            context.l10n.communityMembersCount(memberCount),
                            style: TextStyle(
                              fontSize: 12.rsp(context),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: 6.rsh(context)),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.rs(context),
                              vertical: 4.rsh(context),
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              border: Border.all(color: Colors.orange[200]!),
                              borderRadius: BorderRadius.circular(
                                4.rsr(context),
                              ),
                            ),
                            child: Text(
                              context.l10n.communityPendingApproval,
                              style: TextStyle(
                                fontSize: 11.rsp(context),
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFF97316),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // Description if available
                if (description.isNotEmpty) ...[
                  SizedBox(height: 10.rsh(context)),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.rsp(context),
                      color: AppColors.textSecondary,
                      height: 1.4.rsh(context),
                    ),
                  ),
                ],
                // Cancel request button
                SizedBox(height: 12.rsh(context)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondBackground,
                      foregroundColor: AppColors.textPrimary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 8.rsh(context)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.rsr(context)),
                      ),
                    ),
                    onPressed: () {
                      _showCancelConfirmDialog(context, community.id);
                    },
                    child: Text(
                      context.l10n.friendCancelRequest,
                      style: TextStyle(
                        fontSize: 13.rsp(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCancelConfirmDialog(BuildContext outerContext, String communityId) {
    showDialog(
      context: outerContext,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(outerContext.l10n.communityCancelJoinRequestTitle),
        content: Text(outerContext.l10n.communityCancelJoinRequestConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(outerContext.l10n.commonNo),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              outerContext.read<CommunityListBloc>().add(
                CancelPendingCommunityRequested(communityId),
              );
            },
            child: Text(
              outerContext.l10n.commonCancel,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _PendingCommunitiesSkeleton extends StatelessWidget {
  const _PendingCommunitiesSkeleton();

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
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.fromLTRB(
            12.rs(context),
            12.rsh(context),
            12.rs(context),
            12.rsh(context),
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12.rsr(context)),
            border: Border.all(color: AppColors.divider, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 56.rs(context),
                    height: 56.rsh(context),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.textSecondary.withValues(alpha: 0.3),
                    ),
                  ),
                  SizedBox(width: 12.rs(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150.rs(context),
                          height: 12.rsh(context),
                          color: AppColors.textSecondary.withValues(alpha: 0.3),
                        ),
                        SizedBox(height: 8.rsh(context)),
                        Container(
                          width: 100.rs(context),
                          height: 10.rsh(context),
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.rsh(context)),
              Container(
                width: double.infinity,
                height: 36.rsh(context),
                decoration: BoxDecoration(
                  color: AppColors.textSecondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6.rsr(context)),
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (_, __) => SizedBox(height: 12.rsh(context)),
    );
  }
}

class _AnimatedIn extends StatefulWidget {
  final int index;
  final Widget child;

  const _AnimatedIn({required this.index, required this.child});

  @override
  State<_AnimatedIn> createState() => _AnimatedInState();
}

class _AnimatedInState extends State<_AnimatedIn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.1),
          end: Offset.zero,
        ).animate(_animation),
        child: widget.child,
      ),
    );
  }
}
