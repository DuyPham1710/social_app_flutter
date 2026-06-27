import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_event.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/features/community/presentation/pages/community_roadmap_page.dart';

class CommunityRoadmapWidget extends StatelessWidget {
  final String communityId;

  const CommunityRoadmapWidget({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<CommunityRoadmapBloc>()
        ..add(GetRoadmapPointsRequested(communityId: communityId, limit: 10)),
      child: BlocBuilder<CommunityRoadmapBloc, CommunityRoadmapState>(
        builder: (context, state) {
          if (state is CommunityRoadmapLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is CommunityRoadmapLoaded) {
            final points = state.points;
            // Calculate center point or use default point
            final centerPoint = points.isNotEmpty
                ? LatLng(
                    points.first.latitude,
                    points.first.longitude,
                  )
                : const LatLng(10.762622, 106.660172);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.communityRoadmap,
                        style: TextStyle(
                          fontSize: 18.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (_) => CommunityRoadmapPage(
                                communityId: communityId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          context.l10n.communityRoadmapViewFull,
                          style: TextStyle(
                            fontSize: 14.rsp(context),
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.rsh(context)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.rsr(context)),
                    child: SizedBox(
                      height: 180.rsh(context),
                      width: double.infinity,
                      child: Stack(
                        children: [
                          FlutterMap(
                            options: MapOptions(
                              initialCenter: centerPoint,
                              initialZoom: 12.0,
                              interactionOptions: const InteractionOptions(
                                flags: InteractiveFlag.none, // Disable interaction in preview
                              ),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.social_app.app',
                              ),
                              MarkerLayer(
                                markers: points.map((p) {
                                  return Marker(
                                    point: LatLng(
                                      p.latitude,
                                      p.longitude,
                                    ),
                                    width: 40.rs(context),
                                    height: 40.rs(context),
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.redAccent,
                                      size: 32.rsp(context),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                          // Overlay to make the whole map tappable
                          Positioned.fill(
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => CommunityRoadmapPage(
                                        communityId: communityId,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
