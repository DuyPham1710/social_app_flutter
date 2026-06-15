import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_invites_bloc.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class CommunityInvitesTabWidget extends StatefulWidget {
  CommunityInvitesTabWidget({super.key});

  @override
  State<CommunityInvitesTabWidget> createState() =>
      _CommunityInvitesTabWidgetState();
}

class _CommunityInvitesTabWidgetState extends State<CommunityInvitesTabWidget> {
  late CommunityInvitesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = s1<CommunityInvitesBloc>();
    _bloc.add(FetchCommunityInvitesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CommunityInvitesBloc>.value(
      value: _bloc,
      child: BlocListener<CommunityInvitesBloc, CommunityInvitesState>(
        listener: (context, state) {
          if (state is CommunityInvitesError) {
            showErrorSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          } else if (state is CommunityInvitesSuccess) {
            showSuccessSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          }
        },
        child: BlocBuilder<CommunityInvitesBloc, CommunityInvitesState>(
          builder: (context, state) {
            if (state is CommunityInvitesLoading) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is CommunityInvitesEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.mail_outline,
                      size: 64.rsp(context),
                      color: AppColors.textSecondary.withValues(alpha: 0.75),
                    ),
                    SizedBox(height: 16.rsh(context)),
                    Text(
                      context.l10n.communityNoCommunityInvites,
                      style: TextStyle(
                        fontSize: 16.rsp(context),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is CommunityInvitesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64.rsp(context),
                      color: Colors.red[300],
                    ),
                    SizedBox(height: 16.rsh(context)),
                    Text(
                      localizedCommunityMessage(context.l10n, state.message),
                      style: TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 24.rsh(context)),
                    ElevatedButton(
                      onPressed: () {
                        _bloc.add(RefreshInvitesEvent());
                      },
                      child: Text(context.l10n.commonRefresh),
                    ),
                  ],
                ),
              );
            }

            // Get invites from state
            List<dynamic> invites = [];
            if (state is CommunityInvitesLoaded) {
              invites = state.invites;
            } else if (state is CommunityInvitesSuccess) {
              invites = state.invites;
            }

            return RefreshIndicator(
              onRefresh: () async {
                _bloc.add(RefreshInvitesEvent());
                await Future.delayed(Duration(seconds: 1));
              },
              child: ListView.builder(
                itemCount: invites.length,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  final invite = invites[index];

                  // Safely extract data from dynamic invite object
                  final requestId = _extractString(invite, ['_id', 'id']);
                  final communityData = invite is Map
                      ? invite['communityId']
                      : null;
                  final communityId = communityData is Map
                      ? _extractString(communityData, ['_id', 'id'])
                      : '';
                  final communityName = communityData is Map
                      ? _extractString(communityData, ['name'])
                      : context.l10n.menuCommunity;
                  final communityAvatar = communityData is Map
                      ? _extractString(communityData, ['avatar'])
                      : null;
                  final communityDescription = communityData is Map
                      ? _extractString(communityData, ['description'])
                      : null;

                  final createdAt = invite is Map
                      ? _extractDateTime(invite, ['createdAt'])
                      : DateTime.now();

                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.rs(context),
                      vertical: 8.rsh(context),
                    ),
                    child: Material(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.rsr(context)),
                      shadowColor: AppColors.textSecondary.withValues(
                        alpha: 0.08,
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12.rsr(context)),
                        child: Padding(
                          padding: EdgeInsets.all(12.rs(context)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Community info
                              Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28.rsr(context),
                                    backgroundImage:
                                        communityAvatar != null &&
                                            communityAvatar.isNotEmpty
                                        ? NetworkImage(communityAvatar)
                                        : null,
                                    child:
                                        communityAvatar == null ||
                                            communityAvatar.isEmpty
                                        ? Icon(
                                            Icons.groups,
                                            size: 28.rsp(context),
                                            color: AppColors.textSecondary,
                                          )
                                        : null,
                                  ),
                                  SizedBox(width: 12.rs(context)),
                                  // Community details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          communityName,
                                          style: TextStyle(
                                            fontSize: 15.rsp(context),
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (communityDescription != null &&
                                            communityDescription.isNotEmpty)
                                          Text(
                                            communityDescription,
                                            style: TextStyle(
                                              fontSize: 13.rsp(context),
                                              color: AppColors.textSecondary,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          localizedCommunityTimeAgo(
                                            context.l10n,
                                            createdAt,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12.rsp(context),
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.rsh(context)),
                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed:
                                          state is CommunityInvitesProcessing
                                          ? null
                                          : () {
                                              _bloc.add(
                                                RespondToInviteEvent(
                                                  communityId: communityId,
                                                  requestId: requestId,
                                                  action: 'reject',
                                                ),
                                              );
                                            },
                                      icon: Icon(
                                        Icons.clear,
                                        size: 18.rsp(context),
                                      ),
                                      label: Text(context.l10n.friendReject),
                                    ),
                                  ),
                                  SizedBox(width: 12.rs(context)),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed:
                                          state is CommunityInvitesProcessing
                                          ? null
                                          : () {
                                              _bloc.add(
                                                RespondToInviteEvent(
                                                  communityId: communityId,
                                                  requestId: requestId,
                                                  action: 'approve',
                                                ),
                                              );
                                            },
                                      icon: Icon(
                                        Icons.check,
                                        size: 18.rsp(context),
                                      ),
                                      label: Text(context.l10n.friendAccept),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // Helper method to safely extract string from Map
  String _extractString(
    dynamic obj,
    List<String> keys, [
    String defaultValue = '',
  ]) {
    if (obj is! Map) return defaultValue;
    for (final key in keys) {
      if (obj.containsKey(key) && obj[key] != null) {
        return obj[key].toString();
      }
    }
    return defaultValue;
  }

  // Helper method to safely extract DateTime from Map
  DateTime _extractDateTime(dynamic obj, List<String> keys) {
    if (obj is! Map) return DateTime.now();
    for (final key in keys) {
      if (obj.containsKey(key) && obj[key] != null) {
        final value = obj[key];
        if (value is DateTime) return value;
        if (value is String) {
          try {
            return DateTime.parse(value);
          } catch (e) {
            // ignore
          }
        }
      }
    }
    return DateTime.now();
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }
}
