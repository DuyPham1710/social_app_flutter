import 'package:flutter/material.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/community/data/models/member_model.dart';
import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';

class CommunityMembersWidget extends StatefulWidget {
  final String communityId;
  final int refreshSeed;
  final bool isInBottomSheet;

  const CommunityMembersWidget({
    super.key,
    required this.communityId,
    this.refreshSeed = 0,
    this.isInBottomSheet = false,
  });

  @override
  State<CommunityMembersWidget> createState() => _CommunityMembersWidgetState();
}

class _CommunityMembersWidgetState extends State<CommunityMembersWidget> {
  late Future<List<MemberModel>> _membersFuture;
  final CommunityRepository _communityRepository = s1<CommunityRepository>();

  @override
  void initState() {
    super.initState();
    _membersFuture = _loadMembers();
  }

  @override
  void didUpdateWidget(covariant CommunityMembersWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.refreshSeed != widget.refreshSeed ||
        oldWidget.communityId != widget.communityId) {
      _membersFuture = _loadMembers();
    }
  }

  Future<List<MemberModel>> _loadMembers() async {
    final dataState = await _communityRepository.getMembers(
      communityId: widget.communityId,
      page: 1,
      limit: 50,
    );

    if (dataState is DataStateSuccess<List<MemberModel>>) {
      return dataState.data ?? const [];
    }

    if (dataState is DataStateError) {
      throw dataState.error ?? Exception('Failed to load members');
    }

    return const [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isInBottomSheet) {
      return _buildMembersContent();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E7EC)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x120F172A),
              blurRadius: 14,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: _buildMembersContent(),
      ),
    );
  }

  Widget _buildMembersContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!widget.isInBottomSheet)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              'Thành viên',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        FutureBuilder<List<MemberModel>>(
          future: _membersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Text('Không tải được thành viên: ${snapshot.error}'),
              );
            }

            final members = snapshot.data ?? const [];
            if (members.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text('Chưa có thành viên nào hiển thị'),
              );
            }

            return Column(
              children: members.map((member) {
                final user = member.user;
                final isAdmin = member.role == 'admin';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.avatarUrl != null
                          ? NetworkImage(user.avatarUrl!)
                          : null,
                      child: user.avatarUrl == null
                          ? const Icon(Icons.person)
                          : null,
                    ),
                    title: Text(
                      user.fullName ?? 'Unknown',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(isAdmin ? 'Quản trị viên' : 'Thành viên'),
                    trailing: isAdmin
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                color: Color(0xFF92400E),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          )
                        : null,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
