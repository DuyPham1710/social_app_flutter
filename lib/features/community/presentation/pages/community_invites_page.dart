import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_invites_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_invites_tab_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CommunityInvitesPage extends StatefulWidget {
  const CommunityInvitesPage({Key? key}) : super(key: key);

  @override
  State<CommunityInvitesPage> createState() => _CommunityInvitesPageState();
}

class _CommunityInvitesPageState extends State<CommunityInvitesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.communityInvitesTitle),
        centerTitle: false,
        elevation: 0.5,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1C1E21),
      ),
      backgroundColor: const Color(0xFFF0F2F5),
      body: BlocProvider(
        create: (_) => s1<CommunityInvitesBloc>(),
        child: const CommunityInvitesTabWidget(),
      ),
    );
  }
}
