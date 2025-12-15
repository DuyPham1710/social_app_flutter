import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_music_picker_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_editor_page.dart';
import 'package:social_app_fe/features/story/presentation/bloc/story_create_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StoryCreatePage extends StatefulWidget {
  const StoryCreatePage({super.key});

  @override
  State<StoryCreatePage> createState() => _StoryCreatePageState();
}

class _StoryCreatePageState extends State<StoryCreatePage> {
  final List<AssetEntity> _assets = [];
  final Set<AssetEntity> _selectedAssets = {};
  bool _isLoading = true;
  bool _permissionDenied = false;
  List<AssetPathEntity> _paths = [];
  AssetPathEntity? _currentPath;

  @override
  void initState() {
    super.initState();
    _fetchPathsAndAssets();
  }

  Future<void> _fetchPathsAndAssets() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;
    if (ps.isAuth) {
      // Lấy tất cả các thư mục bao gồm cả ảnh và video
      // Sắp xếp theo thời gian cập nhật mới nhất
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common, 
        filterOption: FilterOptionGroup(
          orders: [
            OrderOption(
              type: OrderOptionType.updateDate,
              asc: false,
            ),
          ],
        ),
      );
      if (paths.isNotEmpty) {
        if (mounted) {
          setState(() {
            _paths = paths;
            _currentPath = paths.firstWhere(
              (path) => path.name.toLowerCase().contains('all') ||
                  path.name.toLowerCase().contains('recent') ||
                  path.name.toLowerCase().contains('tất cả'),
              orElse: () => paths.first,
            );
          });
          await _loadAssetsFromPath(_currentPath!);
        }
        return;
      }
      setState(() => _isLoading = false);
    } else {
      setState(() {
        _permissionDenied = true;
        _isLoading = false;
      });
      PhotoManager.openSetting();
    }
  }

  Future<void> _loadAssetsFromPath(AssetPathEntity path) async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    final entities = await path.getAssetListPaged(
      page: 0,
      size: 120,
    );
    
    // Sắp xếp theo thời gian mới nhất (modifyDateTime hoặc createDateTime)
    entities.sort((a, b) {
      final dateA = a.createDateTime;
      final dateB = b.createDateTime;
      return dateB.compareTo(dateA); // Mới nhất trước
    });
    
    if (mounted) {
      setState(() {
        _assets
          ..clear()
          ..addAll(entities);
        _isLoading = false;
        _currentPath = path;
      });
    }
  }

  void _toggleSelection(AssetEntity asset) {
    // Khi chọn 1 ảnh/video, navigate đến màn hình editor
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => s1<StoryCreateBloc>(),
          child: StoryEditorPage(asset: asset),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildActionRow(),
            ),
            SizedBox(height: 12.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildMultiPickButton(),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: _buildLibraryHeader(),
            ),
            SizedBox(height: 8.h),
            Expanded(child: _buildGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                "Tạo tin",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StoryPrivacySettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.text_fields_rounded,
            label: "Văn bản",
            onTap: () {},
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _ActionCard(
            icon: Icons.music_note_rounded,
            label: "Nhạc",
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const StoryMusicPickerPage(),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: _ActionCard(
            icon: Icons.photo_library_rounded,
            label: "Nhóm ảnh",
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildMultiPickButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withOpacity(0.4)),
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
      onPressed: () {},
      icon: const Icon(Icons.collections_rounded),
      label: const Text("Chọn nhiều file"),
    );
  }

  Widget _buildLibraryHeader() {
    return GestureDetector(
      onTap: () => _showFolderPicker(),
      child: Row(
      children: [
        Text(
            _currentPath?.name ?? "Thư viện",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 6.w),
        const Icon(Icons.expand_more, color: Colors.white),
      ],
      ),
    );
  }

  Future<void> _showFolderPicker() async {
    if (_paths.isEmpty) return;

    final selectedPath = await showModalBottomSheet<AssetPathEntity>(
      context: context,
      backgroundColor: const Color(0xFF1D1F23),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 16.h),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "Chọn thư mục",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _paths.length,
                itemBuilder: (context, index) {
                  final path = _paths[index];
                  final isSelected = path.id == _currentPath?.id;
                  return ListTile(
                    leading: Icon(
                      Icons.folder,
                      color: isSelected ? AppColors.primary : Colors.white70,
                    ),
                    title: Text(
                      path.name,
                      style: TextStyle(
                        color: isSelected ? AppColors.primary : Colors.white,
                        fontSize: 16.sp,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: AppColors.primary)
                        : null,
                    subtitle: FutureBuilder<int>(
                      future: path.assetCountAsync,
                      builder: (context, snapshot) {
                        final count = snapshot.data ?? 0;
                        return Text(
                          "$count mục",
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 12.sp,
                          ),
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.pop(context, path);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );

    if (selectedPath != null && selectedPath.id != _currentPath?.id) {
      await _loadAssetsFromPath(selectedPath);
    }
  }

  Widget _buildGrid() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    if (_permissionDenied) {
      return Center(
        child: Text(
          "Cần quyền truy cập thư viện để hiển thị ảnh/video.",
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_assets.isEmpty) {
      return Center(
        child: Text(
          "Chưa có ảnh/video trong thư viện.",
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 2.w,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final asset = _assets[index];
        final isSelected = _selectedAssets.contains(asset);
        final isVideo = asset.type == AssetType.video;
        return GestureDetector(
          onTap: () => _toggleSelection(asset),
          child: Stack(
            fit: StackFit.expand,
            children: [
              FutureBuilder<Uint8List?>(
                future: asset.thumbnailDataWithSize(
                  const ThumbnailSize.square(300),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.data != null) {
                    return Image.memory(snapshot.data!, fit: BoxFit.cover);
                  }
                  return Container(color: Colors.grey[800]);
                },
              ),
              // Hiển thị icon video và duration
              if (isVideo)
                Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Builder(
                          builder: (context) {
                            final duration = asset.duration;
                            if (duration != null && duration > 0) {
                              final minutes = duration ~/ 60;
                              final seconds = duration % 60;
                              return Text(
                                '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ],
                    ),
                  ),
              ),
              if (isSelected)
                Container(
                  color: Colors.black.withOpacity(0.45),
                  child: const Center(
                    child: Icon(Icons.check_circle, color: AppColors.primary, size: 28),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.h,
        decoration: BoxDecoration(
          color: const Color(0xFF1D1F23),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26.sp),
            SizedBox(height: 6.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
