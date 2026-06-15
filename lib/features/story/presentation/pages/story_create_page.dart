import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_privacy_settings_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_music_picker_page.dart';
import 'package:social_app_fe/features/story/presentation/pages/story_editor_page.dart';
import 'package:social_app_fe/features/story/presentation/bloc/story_create_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/l10n/l10n.dart';

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
    if (kIsWeb) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (!mounted) return;
    if (ps.isAuth) {
      // Lấy tất cả các thư mục bao gồm cả ảnh và video
      // Sắp xếp theo thời gian cập nhật mới nhất
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.common,
        filterOption: FilterOptionGroup(
          orders: [OrderOption(type: OrderOptionType.updateDate, asc: false)],
        ),
      );
      if (paths.isNotEmpty) {
        if (mounted) {
          setState(() {
            _paths = paths;
            _currentPath = paths.firstWhere(
              (path) =>
                  path.name.toLowerCase().contains('all') ||
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

    final entities = await path.getAssetListPaged(page: 0, size: 120);

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

  Future<void> _pickFileWeb() async {
    final result = await FilePicker.pickFiles(
      type: FileType.media,
      allowMultiple: false,
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      if (!mounted) return;
      final isVideo =
          file.extension?.toLowerCase() == 'mp4' ||
          file.extension?.toLowerCase() == 'webm';
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => s1<StoryCreateBloc>(),
            child: StoryEditorPage(
              webFileBytes: file.bytes,
              webFileName: file.name,
              isVideo: isVideo,
            ),
          ),
        ),
      );
    }
  }

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
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(context),
                  SizedBox(height: 12.rsh(context)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                    child: _buildActionRow(),
                  ),
                  if (!kIsWeb) ...[
                    SizedBox(height: 12.rsh(context)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                      child: _buildMultiPickButton(),
                    ),
                    SizedBox(height: 16.rsh(context)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
                      child: _buildLibraryHeader(),
                    ),
                  ],
                  SizedBox(height: 8.rsh(context)),
                  Expanded(child: _buildGrid()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 12.rs(context),
        vertical: 8.rsh(context),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.close, color: AppColors.iconPrimary),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Center(
              child: Text(
                context.l10n.chatCreateStory,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.settings, color: AppColors.iconPrimary),
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
            label: context.l10n.storyText,
            onTap: () {},
          ),
        ),
        SizedBox(width: 8.rs(context)),
        Expanded(
          child: _ActionCard(
            icon: Icons.music_note_rounded,
            label: context.l10n.storyMusic,
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const StoryMusicPickerPage()),
              );
            },
          ),
        ),
        SizedBox(width: 8.rs(context)),
        Expanded(
          child: _ActionCard(
            icon: Icons.photo_library_rounded,
            label: context.l10n.storyPhotoGroup,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildMultiPickButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        side: BorderSide(color: AppColors.divider),
        padding: EdgeInsets.symmetric(
          vertical: 12.rsh(context),
          horizontal: 12.rs(context),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.rsr(context)),
        ),
      ),
      onPressed: () {},
      icon: Icon(Icons.collections_rounded, color: AppColors.iconPrimary),
      label: Text(context.l10n.storySelectMultipleFiles),
    );
  }

  Widget _buildLibraryHeader() {
    return GestureDetector(
      onTap: () => _showFolderPicker(),
      child: Row(
        children: [
          Text(
            _currentPath?.name ?? context.l10n.storyLibrary,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.rsp(context),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 6.rs(context)),
          Icon(Icons.expand_more, color: AppColors.iconPrimary),
        ],
      ),
    );
  }

  Future<void> _showFolderPicker() async {
    if (_paths.isEmpty) return;

    final selectedPath = await showModalBottomSheet<AssetPathEntity>(
      context: context,
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.rsr(context)),
        ),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16.rsh(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.rs(context),
              height: 4.rsh(context),
              margin: EdgeInsets.only(bottom: 16.rsh(context)),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.rsr(context)),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.rs(context)),
              child: Text(
                context.l10n.storyChooseFolder,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 16.rsh(context)),
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
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.iconPrimary,
                    ),
                    title: Text(
                      path.name,
                      style: TextStyle(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontSize: 16.rsp(context),
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
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
                          context.l10n.storyItemCount(count),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12.rsp(context),
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
    if (kIsWeb) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_rounded,
              size: 64,
              color: AppColors.iconPrimary.withValues(alpha: 0.5),
            ),
            SizedBox(height: 16.rsh(context)),
            Text(
              context.l10n.storyAddMediaFromComputer,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 16.rsp(context),
              ),
            ),
            SizedBox(height: 24.rsh(context)),
            ElevatedButton.icon(
              onPressed: _pickFileWeb,
              icon: const Icon(Icons.upload_file),
              label: Text(
                context.l10n.storySelectFile,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: 24.rs(context),
                  vertical: 14.rsh(context),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.rsr(context)),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_permissionDenied) {
      return Center(
        child: Text(
          context.l10n.storyLibraryPermissionRequired,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_assets.isEmpty) {
      return Center(
        child: Text(
          context.l10n.storyNoMediaInLibrary,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.rsp(context),
          ),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 8.rs(context)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.rs(context),
        mainAxisSpacing: 2.rs(context),
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
                  return Container(color: AppColors.secondBackground);
                },
              ),
              // Hiển thị icon video và duration
              if (isVideo)
                Positioned(
                  bottom: 4.rsh(context),
                  right: 4.rs(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.rs(context),
                      vertical: 2.rsh(context),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4.rsr(context)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 14.rsp(context),
                        ),
                        SizedBox(width: 4.rs(context)),
                        Builder(
                          builder: (context) {
                            final duration = asset.duration;
                            if (duration > 0) {
                              final minutes = duration ~/ 60;
                              final seconds = duration % 60;
                              return Text(
                                '${minutes.toString().padLeft(1, '0')}:${seconds.toString().padLeft(2, '0')}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.rsp(context),
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
                  color: Colors.black.withValues(alpha: 0.45),
                  child: Center(
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                      size: 28,
                    ),
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
        height: 70.rsh(context),
        decoration: BoxDecoration(
          color: AppColors.secondBackground,
          borderRadius: BorderRadius.circular(12.rsr(context)),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.iconPrimary, size: 26.rsp(context)),
            SizedBox(height: 6.rsh(context)),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13.rsp(context),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
