import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_invites_bloc.dart';

class CommunityInvitesTabWidget extends StatefulWidget {
  const CommunityInvitesTabWidget({Key? key}) : super(key: key);

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
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is CommunityInvitesSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: BlocBuilder<CommunityInvitesBloc, CommunityInvitesState>(
          builder: (context, state) {
            if (state is CommunityInvitesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CommunityInvitesEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.mail_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Không có lời mời tham gia cộng đồng',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
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
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        _bloc.add(RefreshInvitesEvent());
                      },
                      child: const Text('Tải lại'),
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
                await Future.delayed(const Duration(seconds: 1));
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
                      : 'Cộng đồng';
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Community info
                              Row(
                                children: [
                                  // Avatar
                                  CircleAvatar(
                                    radius: 28,
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
                                            size: 28,
                                            color: Colors.grey[600],
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 12),
                                  // Community details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          communityName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        if (communityDescription != null &&
                                            communityDescription!.isNotEmpty)
                                          Text(
                                            communityDescription!,
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        Text(
                                          timeago.format(
                                            createdAt,
                                            locale: 'vi',
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
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
                                      icon: const Icon(Icons.clear, size: 18),
                                      label: const Text('Từ chối'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
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
                                      icon: const Icon(Icons.check, size: 18),
                                      label: const Text('Chấp nhận'),
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
