import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart' as import_geo;
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class LocationPickerPage extends StatefulWidget {
  final LatLng? initialLocation;

  const LocationPickerPage({super.key, this.initialLocation});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final MapController _mapController = MapController();
  LatLng? _selectedLocation;
  String _currentAddress = '';
  bool _isLoadingAddress = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialLocation != null) {
      _selectedLocation = widget.initialLocation;
      _getAddressFromLatLng(_selectedLocation!);
    } else {
      _getUserLocation();
    }
  }

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Default to HCMC
      _setDefaultLocation();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _setDefaultLocation();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _setDefaultLocation();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition();
      final latLng = LatLng(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _selectedLocation = latLng;
        });
        _mapController.move(latLng, 15.0);
      }
      _getAddressFromLatLng(latLng);
    } catch (e) {
      _setDefaultLocation();
    }
  }

  void _setDefaultLocation() {
    // Default to HCMC Center
    final defaultLocation = const LatLng(10.762622, 106.660172);
    setState(() {
      _selectedLocation = defaultLocation;
    });
    _mapController.move(defaultLocation, 12.0);
    _getAddressFromLatLng(defaultLocation);
  }

  Future<void> _getAddressFromLatLng(LatLng position) async {
    if (mounted) {
      setState(() {
        _isLoadingAddress = true;
      });
    }
    try {
      List<import_geo.Placemark> placemarks = await import_geo.placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        final String address = [
          if (placemark.street != null && placemark.street!.isNotEmpty) placemark.street,
          placemark.subLocality,
          placemark.locality,
          placemark.administrativeArea,
          placemark.country,
        ].where((e) => e != null && e.isNotEmpty).join(', ');

        if (mounted) {
          setState(() {
            _currentAddress = address.isNotEmpty ? address : context.l10n.locationUnknown;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _currentAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentAddress = '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingAddress = false;
        });
      }
    }
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    // Ẩn bàn phím
    FocusScope.of(context).unfocus();

    try {
      List<import_geo.Location> locations = await import_geo.locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final latLng = LatLng(location.latitude, location.longitude);
        if (mounted) {
          setState(() {
            _selectedLocation = latLng;
          });
          _mapController.move(latLng, 15.0);
        }
        _getAddressFromLatLng(latLng);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.locationNotFound)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.locationSearchError)),
        );
      }
    }
  }

  Future<void> _fetchSuggestions(String query) async {
    setState(() {
      _isSearching = true;
    });
    try {
      final response = await Dio().get(
        'https://nominatim.openstreetmap.org/search',
        options: Options(
          headers: {
            'User-Agent': 'SocialApp_KLTN/1.0',
            'Accept-Language': 'vi-VN,vi;q=0.9,en-US;q=0.8,en;q=0.7',
          },
        ),
        queryParameters: {
          'q': query,
          'format': 'json',
          'addressdetails': 1,
          'limit': 8,
          'countrycodes': 'vn',
        },
      );
      if (mounted) {
        setState(() {
          _suggestions = List<Map<String, dynamic>>.from(response.data);
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _suggestions = [];
          _isSearching = false;
        });
      }
    }
  }

  void _onConfirm() {
    if (_selectedLocation == null) return;
    Navigator.pop(context, {
      'lat': _selectedLocation!.latitude,
      'lng': _selectedLocation!.longitude,
      'address': _currentAddress,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.postCheckIn,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.rsp(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _selectedLocation != null ? _onConfirm : null,
            child: Text(
              context.l10n.commonConfirm,
              style: TextStyle(
                color: _selectedLocation != null ? AppColors.primary : AppColors.textSecondary,
                fontSize: 16.rsp(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation ?? const LatLng(10.762622, 106.660172),
              initialZoom: 12.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
                _getAddressFromLatLng(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.social_app.app',
              ),
              if (_selectedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation!,
                      width: 40.0,
                      height: 40.0,
                      alignment: Alignment.topCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 3.0,
                            height: 15.0,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 2,
                                  offset: const Offset(1, 0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Search Bar
          Positioned(
            top: 16.rsh(context),
            left: 16.rs(context),
            right: 16.rs(context),
            child: Column(
              children: [
                Card(
                  color: AppColors.background,
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.rsr(context))),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: AppColors.textSecondary),
                        SizedBox(width: 8.rs(context)),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: context.l10n.locationSearchHint,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              _debounce?.cancel();
                              _debounce = Timer(const Duration(milliseconds: 500), () {
                                if (value.isNotEmpty) {
                                  _fetchSuggestions(value);
                                } else {
                                  if (mounted) {
                                    setState(() {
                                      _suggestions = [];
                                    });
                                  }
                                }
                              });
                            },
                            onSubmitted: (_) => _searchLocation(),
                          ),
                        ),
                        if (_isSearching)
                          Padding(
                            padding: EdgeInsets.only(right: 8.rs(context)),
                            child: SizedBox(
                              width: 16.rs(context),
                              height: 16.rs(context),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        else if (_searchController.text.isNotEmpty)
                          IconButton(
                            icon: Icon(Icons.clear, color: AppColors.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _suggestions = [];
                              });
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                if (_suggestions.isNotEmpty)
                  Card(
                    color: AppColors.background,
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.rsr(context))),
                    margin: EdgeInsets.only(top: 8.rsh(context)),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 250.rsh(context)),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: _suggestions.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.divider),
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          final displayName = suggestion['display_name'] as String? ?? '';
                          return ListTile(
                            leading: Icon(Icons.location_on_outlined, color: AppColors.textSecondary),
                            title: Text(
                              displayName,
                              style: TextStyle(color: AppColors.textPrimary, fontSize: 14.rsp(context)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            onTap: () {
                              final lat = double.tryParse(suggestion['lat']?.toString() ?? '');
                              final lon = double.tryParse(suggestion['lon']?.toString() ?? '');
                              if (lat != null && lon != null) {
                                final point = LatLng(lat, lon);
                                setState(() {
                                  _selectedLocation = point;
                                  _suggestions = [];
                                  _searchController.text = displayName;
                                });
                                _mapController.move(point, 15.0);
                                _getAddressFromLatLng(point);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // My Location Button
          Positioned(
            right: 16.rs(context),
            bottom: 120.rsh(context),
            child: FloatingActionButton(
              heroTag: 'my_location',
              backgroundColor: AppColors.background,
              onPressed: _getUserLocation,
              child: Icon(Icons.my_location, color: AppColors.primary),
            ),
          ),
          
          // Address Bottom Card
          Positioned(
            left: 16.rs(context),
            right: 16.rs(context),
            bottom: 30.rsh(context),
            child: Container(
              padding: EdgeInsets.all(16.rs(context)),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16.rsr(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.rs(context)),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on,
                      color: AppColors.primary,
                      size: 24.rs(context),
                    ),
                  ),
                  SizedBox(width: 16.rs(context)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          context.l10n.locationSelected,
                          style: TextStyle(
                            fontSize: 12.rsp(context),
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4.rsh(context)),
                        if (_isLoadingAddress)
                          const CupertinoActivityIndicator()
                        else
                          Text(
                            _currentAddress.isNotEmpty
                                ? _currentAddress
                                : context.l10n.locationNotSelected,
                            style: TextStyle(
                              fontSize: 14.rsp(context),
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
