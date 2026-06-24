import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/community/domain/entities/roadmap_point_entity.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_event.dart';
import 'package:social_app_fe/features/community/presentation/bloc/roadmap/community_roadmap_state.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/core/di/injection.dart';

import 'package:social_app_fe/features/community/domain/repository/community_repository.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/post/presentation/widgets/post_widgets/post_item.dart';
import 'package:social_app_fe/core/resources/data_state.dart';

class CommunityRoadmapPage extends StatelessWidget {
  final String communityId;

  const CommunityRoadmapPage({
    super.key,
    required this.communityId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<CommunityRoadmapBloc>(),
      child: _CommunityRoadmapView(communityId: communityId),
    );
  }
}

class _CommunityRoadmapView extends StatefulWidget {
  final String communityId;

  const _CommunityRoadmapView({
    required this.communityId,
  });

  @override
  State<_CommunityRoadmapView> createState() => _CommunityRoadmapViewState();
}

class _CommunityRoadmapViewState extends State<_CommunityRoadmapView> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  double _radius = 5.0;

  @override
  void initState() {
    super.initState();
    // Fetch roadmap points
    context.read<CommunityRoadmapBloc>().add(
          GetRoadmapPointsRequested(communityId: widget.communityId, limit: 100),
        );
    
    // Get user location
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Move map to current location
      if (_currentLocation != null) {
        _mapController.move(_currentLocation!, 13.0);
      }
    } catch (e) {
      // Handle error gracefully
    }
  }

  List<LatLng> _generateCurvyPoints(List<RoadmapPointEntity> points) {
    if (points.isEmpty) return [];
    if (points.length == 1) return [LatLng(points.first.latitude, points.first.longitude)];

    List<LatLng> result = [];
    
    for (int i = 0; i < points.length - 1; i++) {
      LatLng p1 = LatLng(points[i].latitude, points[i].longitude);
      LatLng p2 = LatLng(points[i + 1].latitude, points[i + 1].longitude);
      
      List<LatLng> curve = _generateCurveBetween(p1, p2, isOdd: i % 2 != 0);
      result.addAll(curve.sublist(0, curve.length - 1));
    }
    result.add(LatLng(points.last.latitude, points.last.longitude));
    
    return result;
  }

  List<LatLng> _generateCurveBetween(LatLng p1, LatLng p2, {int segments = 40, bool isOdd = false}) {
    List<LatLng> result = [];
    
    double midLat = (p1.latitude + p2.latitude) / 2;
    double midLng = (p1.longitude + p2.longitude) / 2;
    
    double dx = p2.longitude - p1.longitude;
    double dy = p2.latitude - p1.latitude;
    
    double curveFactor = isOdd ? 0.2 : -0.2;
    
    double cpLat = midLat - dx * curveFactor; 
    double cpLng = midLng + dy * curveFactor;
    
    for (int i = 0; i <= segments; i++) {
      double t = i / segments;
      
      double lat = pow(1 - t, 2) * p1.latitude + 2 * (1 - t) * t * cpLat + pow(t, 2) * p2.latitude;
      double lng = pow(1 - t, 2) * p1.longitude + 2 * (1 - t) * t * cpLng + pow(t, 2) * p2.longitude;
      
      result.add(LatLng(lat, lng));
    }
    
    return result;
  }

  void _showFilterDialog(BuildContext context) {
    final bloc = context.read<CommunityRoadmapBloc>();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.rsr(context))),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.all(16.rs(context)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40.rs(context),
                      height: 4.rsh(context),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2.rsr(context)),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.rsh(context)),
                  Text(
                    context.l10n.communityRoadmapSearchNearby,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18.rsp(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.rsh(context)),
                  Text(
                    context.l10n.communityRoadmapRadius(_radius),
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16.rsp(context),
                    ),
                  ),
                  Slider(
                    value: _radius,
                    min: 1,
                    max: 50,
                    divisions: 49,
                    activeColor: AppColors.primary,
                    inactiveColor: AppColors.textSecondary.withValues(alpha: 0.2),
                    label: context.l10n.communityRoadmapRadiusLabel(_radius),
                    onChanged: (value) {
                      setModalState(() => _radius = value);
                    },
                  ),
                  SizedBox(height: 16.rsh(context)),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.rsh(context)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.rsr(context)),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        if (_currentLocation != null) {
                          bloc.add(
                            GetNearbyRoadmapPointsRequested(
                              communityId: widget.communityId,
                              lat: _currentLocation!.latitude,
                              lng: _currentLocation!.longitude,
                              radius: _radius,
                            )
                          );
                        } else {
                          _getUserLocation().then((_) {
                             if (_currentLocation != null) {
                                bloc.add(
                                  GetNearbyRoadmapPointsRequested(
                                    communityId: widget.communityId,
                                    lat: _currentLocation!.latitude,
                                    lng: _currentLocation!.longitude,
                                    radius: _radius,
                                  )
                                );
                             }
                          });
                        }
                      },
                      child: Text(
                        context.l10n.communityRoadmapApplyFilter,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showPointDetails(BuildContext context, RoadmapPointEntity point) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.rsr(context))),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.rsr(context))),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -5)),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 16.rsh(context), bottom: 16.rsh(context)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.rs(context),
                        height: 4.rsh(context),
                        decoration: BoxDecoration(
                          color: AppColors.textSecondary.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2.rsr(context)),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.rsh(context)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.rs(context)),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16.rsr(context)),
                            ),
                            child: Icon(Icons.place, color: AppColors.primary, size: 28.rsp(context)),
                          ),
                          SizedBox(width: 16.rs(context)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  point.locationName,
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 18.rsp(context),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8.rsh(context)),
                                Row(
                                  children: [
                                    Icon(Icons.history_edu, color: AppColors.textSecondary, size: 16.rsp(context)),
                                    SizedBox(width: 4.rs(context)),
                                    Text(
                                      context.l10n.communityRoadmapPostCount(point.postCount),
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 14.rsp(context)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${point.latitude},${point.longitude}');
                              try {
                                await launchUrl(url, mode: LaunchMode.externalApplication);
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể mở bản đồ')));
                                }
                              }
                            },
                            style: IconButton.styleFrom(
                              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                              padding: EdgeInsets.all(12.rs(context)),
                            ),
                            icon: Icon(Icons.directions, color: AppColors.primary, size: 24.rsp(context)),
                          ),
                        ],
                      ),
                    ),
                    if (point.firstPostedBy != null) ...[
                      SizedBox(height: 16.rsh(context)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.rs(context), vertical: 8.rsh(context)),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20.rsr(context)),
                            border: Border.all(color: AppColors.textSecondary.withValues(alpha: 0.1)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (point.firstPostedBy!.avatarUrl != null)
                                CircleAvatar(
                                  radius: 12.rsr(context),
                                  backgroundImage: NetworkImage(point.firstPostedBy!.avatarUrl!),
                                )
                              else
                                CircleAvatar(
                                  radius: 12.rsr(context),
                                  backgroundColor: AppColors.primary,
                                  child: Icon(Icons.person, color: Colors.white, size: 14.rsp(context)),
                                ),
                              SizedBox(width: 8.rs(context)),
                              Text(
                                context.l10n.communityRoadmapFirstCheckedInBy(
                                  point.firstPostedBy?.fullName ?? point.firstPostedBy?.username ?? 'Unknown',
                                ),
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 13.rsp(context), fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    SizedBox(height: 16.rsh(context)),
                    Divider(height: 1, color: AppColors.textSecondary.withValues(alpha: 0.1)),
                    SizedBox(height: 16.rsh(context)),
              Expanded(
                child: FutureBuilder<DataState<List<PostEntity>>>(
                  future: s1<CommunityRepository>().getRoadmapPointPosts(
                    communityId: widget.communityId,
                    roadmapId: point.id,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: AppColors.primary));
                    }
                    if (snapshot.hasError || snapshot.data is DataStateError) {
                      return Center(child: Text(context.l10n.communityRoadmapErrorLoadPosts, style: TextStyle(color: Colors.red)));
                    }
                    final posts = snapshot.data?.data ?? [];
                    if (posts.isEmpty) {
                      return Center(child: Text(context.l10n.communityRoadmapNoPosts, style: TextStyle(color: AppColors.textSecondary)));
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(bottom: 12.rsh(context)),
                          child: PostItem(
                            post: posts[index],
                            commentCount: 0,
                            isInCommunityDetail: true,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.communityRoadmapTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded),
            onPressed: () => _showFilterDialog(context),
            tooltip: context.l10n.communityRoadmapFilterTooltip,
          ),
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              if (_currentLocation != null) {
                _mapController.move(_currentLocation!, 13.0);
              } else {
                _getUserLocation();
              }
            },
            tooltip: context.l10n.communityRoadmapMyLocation,
          ),
        ],
      ),
      body: BlocBuilder<CommunityRoadmapBloc, CommunityRoadmapState>(
        builder: (context, state) {
          List<RoadmapPointEntity> points = [];
          if (state is CommunityRoadmapLoaded) {
            points = state.points;
          } else if (state is CommunityRoadmapLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (state is CommunityRoadmapError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CommunityRoadmapLoaded && points.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.map_rounded,
                    size: 64.rsp(context),
                    color: AppColors.unselectedIcon,
                  ),
                  SizedBox(height: 16.rsh(context)),
                  Text(
                    context.l10n.communityRoadmapEmpty,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16.rsp(context),
                    ),
                  ),
                ],
              ),
            );
          }

          final markers = points.map((point) {
            return Marker(
              point: LatLng(point.latitude, point.longitude),
              width: 50.rs(context),
              height: 50.rs(context),
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: () => _showPointDetails(context, point),
                child: Column(
                  children: [
                    if (point.firstPostedBy?.avatarUrl != null)
                      Container(
                        width: 36.rs(context),
                        height: 36.rs(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            image: NetworkImage(point.firstPostedBy!.avatarUrl!),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                      )
                    else
                      Container(
                        width: 36.rs(context),
                        height: 36.rs(context),
                        padding: EdgeInsets.all(4.rs(context)),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4, offset: const Offset(0, 2)),
                          ],
                        ),
                        child: Icon(
                          Icons.place,
                          color: Colors.white,
                          size: 20.rsp(context),
                        ),
                      ),
                    Container(
                      width: 2.rs(context),
                      height: 8.rs(context),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 2, offset: const Offset(1, 0)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList();

          if (_currentLocation != null) {
            markers.add(
              Marker(
                point: _currentLocation!,
                width: 40.rs(context),
                height: 40.rs(context),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                ),
              ),
            );
          }

          // Determine initial center
          LatLng initialCenter = _currentLocation ?? const LatLng(10.762622, 106.660172); // Default to HCMC
          if (_currentLocation == null && points.isNotEmpty) {
            initialCenter = LatLng(points.first.latitude, points.first.longitude);
          }

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 10.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.socialapp.fe',
              ),
              if (points.length > 1)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _generateCurvyPoints(points),
                      color: AppColors.primary,
                      strokeWidth: 4.0,
                      pattern: StrokePattern.dashed(segments: const [10, 10]),
                    ),
                  ],
                ),
              MarkerLayer(markers: markers),
            ],
          );
        },
      ),
    );
  }
}
