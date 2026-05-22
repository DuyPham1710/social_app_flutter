import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
// Thay đổi đường dẫn theo dự án của bạn
import 'package:social_app_fe/features/profile/domain/entities/update_user_entity.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:social_app_fe/features/profile/presentation/bloc/profile_event.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class SingleImagePickerPage extends StatefulWidget {
  final bool isAvatar; // True: Sửa Avatar, False: Sửa ảnh bìa
  final ProfileBloc profileBloc; // Truyền Bloc từ màn hình trước sang

  const SingleImagePickerPage({
    super.key,
    required this.isAvatar,
    required this.profileBloc,
  });

  @override
  State<SingleImagePickerPage> createState() => _SingleImagePickerPageState();
}

class _SingleImagePickerPageState extends State<SingleImagePickerPage> {
  List<AssetEntity> _assets = [];
  AssetEntity? _selectedAsset; // Chỉ lưu 1 ảnh được chọn

  @override
  void initState() {
    super.initState();
    _fetchAssets();
  }

  Future<void> _fetchAssets() async {
    // Xin quyền truy cập ảnh
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      // Lấy album Recent (Gần đây) với sắp xếp từ mới nhất tới cũ nhất
      final List<AssetPathEntity> paths = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
        filterOption: FilterOptionGroup(
          orders: [
            const OrderOption(
              type: OrderOptionType.createDate,
              asc: false, // false = giảm dần (mới nhất trước)
            ),
          ],
        ),
      );
      if (paths.isNotEmpty) {
        // Lấy danh sách ảnh trong album đầu tiên
        // Lấy 100 ảnh demo, thực tế nên dùng phân trang (load more)
        final List<AssetEntity> entities = await paths[0].getAssetListPaged(
          page: 0,
          size: 100,
        );
        setState(() {
          _assets = entities;
        });
      }
    } else {
      PhotoManager.openSetting();
    }
  }

  // Hàm toggle chọn ảnh (Logic: Chọn cái mới thì bỏ cái cũ)
  void _toggleAssetSelection(AssetEntity asset) {
    setState(() {
      if (_selectedAsset == asset) {
        _selectedAsset = null;
      } else {
        _selectedAsset = asset;
      }
    });
  }

  // Hàm Lưu
  Future<void> _onSave() async {
    if (_selectedAsset == null) return;

    // Lấy File thật từ AssetEntity
    final File? file = await _selectedAsset!.file;
    if (file == null) return;

    // Tạo params tương ứng
    final params = widget.isAvatar
        ? UpdateUserEntity(avatarFile: file)
        : UpdateUserEntity(coverFile: file);

    // Gửi Event cập nhật thông qua Bloc đã được truyền vào
    widget.profileBloc.add(UpdateUserProfileEvent(params));

    // Đóng trang chọn ảnh
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isAvatar
              ? context.l10n.profileChooseAvatar
              : context.l10n.profileChooseCover,
        ),
        actions: [
          TextButton(
            onPressed: _selectedAsset != null ? _onSave : null,
            child: Text(
              context.l10n.commonSave,
              style: TextStyle(
                color: _selectedAsset != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: _assets.isEmpty
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
              ),
              itemCount: _assets.length,
              itemBuilder: (context, index) {
                final asset = _assets[index];
                final isSelected = asset == _selectedAsset;

                return GestureDetector(
                  onTap: () => _toggleAssetSelection(asset),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hiển thị ảnh (Thay thế đoạn AssetEntityImage bị lỗi)
                      FutureBuilder<Uint8List?>(
                        // Load ảnh thumbnail kích thước 200x200 cho nhẹ
                        future: asset.thumbnailDataWithSize(
                          const ThumbnailSize.square(200),
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.data != null) {
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          }
                          // Placeholder màu xám khi đang load
                          return Container(color: AppColors.secondBackground);
                        },
                      ),

                      // Overlay khi chọn
                      if (isSelected)
                        Container(
                          color: Colors.black.withOpacity(0.4),
                          child: const Center(
                            child: Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
