import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_invites_bloc.dart';
import 'package:social_app_fe/features/community/presentation/widgets/community_invites_tab_widget.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';

class CommunityInvitesPage extends StatefulWidget {
  CommunityInvitesPage({super.key});

  @override
  State<CommunityInvitesPage> createState() => _CommunityInvitesPageState();
}

class _CommunityInvitesPageState extends State<CommunityInvitesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: ResponsiveHelper.feedMaxWidth,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text(context.l10n.communityInvitesTitle),
              centerTitle: false,
              elevation: 0.5,
              backgroundColor: AppColors.background,
              foregroundColor: AppColors.iconPrimary,
              surfaceTintColor: Colors.transparent,
            ),
            backgroundColor: AppColors.secondBackground,
            body: BlocProvider(
              create: (_) => s1<CommunityInvitesBloc>(),
              child: CommunityInvitesTabWidget(),
            ),
          ),
        ),
      ),
    );
  }
}
