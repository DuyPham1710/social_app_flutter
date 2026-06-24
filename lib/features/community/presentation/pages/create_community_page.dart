import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_create_bloc.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_create_event.dart';
import 'package:social_app_fe/features/community/presentation/bloc/community_create_state.dart';
import 'package:social_app_fe/features/community/presentation/utils/community_l10n_helper.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';
import 'package:social_app_fe/l10n/l10n.dart';

class CreateCommunityPage extends StatefulWidget {
  CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedPrivacy = 'public';
  String _selectedType = 'standard';
  String? _avatarPath;
  String? _coverImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source, {required bool isAvatar}) async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: source);
      if (image != null) {
        setState(() {
          if (isAvatar) {
            _avatarPath = image.path;
          } else {
            _coverImagePath = image.path;
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      showErrorSnackBar(
        context,
        context.l10n.communityPickImageError(e.toString()),
      );
    }
  }

  void _showImageSourceMenu({required bool isAvatar}) {
    if (kIsWeb) {
      _pickImage(ImageSource.gallery, isAvatar: isAvatar);
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.rs(context)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.iconPrimary),
              title: Text(context.l10n.postCamera),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isAvatar: isAvatar);
              },
            ),
            ListTile(
              leading: Icon(Icons.image, color: AppColors.iconPrimary),
              title: Text(context.l10n.communityChooseFromLibrary),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, isAvatar: isAvatar);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => s1<CommunityCreateBloc>(),
      child: BlocListener<CommunityCreateBloc, CommunityCreateState>(
        listener: (context, state) {
          if (state is CommunityCreateSuccess) {
            showSuccessSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
            Future.delayed(Duration(seconds: 1), () {
              if (context.mounted) {
                Navigator.of(context).pop(state.community);
              }
            });
          } else if (state is CommunityCreateError) {
            showErrorSnackBar(
              context,
              localizedCommunityMessage(context.l10n, state.message),
            );
          }
        },
        child: Container(
          color: AppColors.background,

          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: ResponsiveHelper.feedMaxWidth,
              ),
              child: Scaffold(
                backgroundColor: AppColors.secondBackground,
                appBar: AppBar(
                  title: Text(
                    context.l10n.communityCreateTitle,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: AppColors.secondBackground,
                  foregroundColor: AppColors.iconPrimary,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  surfaceTintColor: Colors.transparent,
                ),
                body: BlocBuilder<CommunityCreateBloc, CommunityCreateState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        16.rs(context),
                        8.rsh(context),
                        16.rs(context),
                        20.rsh(context),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar Section
                          Text(
                            context.l10n.communityAvatar,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          GestureDetector(
                            onTap: () => _showImageSourceMenu(isAvatar: true),
                            child: Container(
                              width: double.infinity,
                              height: 180.rsh(context),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(
                                  18.rsr(context),
                                ),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: _avatarPath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        18.rsr(context),
                                      ),
                                      child: kIsWeb
                                          ? Image.network(
                                              _avatarPath!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(_avatarPath!),
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                              10.rs(context),
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.add_photo_alternate_rounded,
                                              size: 28.rsp(context),
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(height: 8.rsh(context)),
                                          Text(
                                            context.l10n.communityChooseAvatar,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 24.rsh(context)),

                          // Cover Image Section
                          Text(
                            context.l10n.communityCoverImage,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          GestureDetector(
                            onTap: () => _showImageSourceMenu(isAvatar: false),
                            child: Container(
                              width: double.infinity,
                              height: 150.rsh(context),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(
                                  18.rsr(context),
                                ),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: _coverImagePath != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        18.rsr(context),
                                      ),
                                      child: kIsWeb
                                          ? Image.network(
                                              _coverImagePath!,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.file(
                                              File(_coverImagePath!),
                                              fit: BoxFit.cover,
                                            ),
                                    )
                                  : Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(
                                              10.rs(context),
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.primary
                                                  .withValues(alpha: 0.12),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.wallpaper_rounded,
                                              size: 28.rsp(context),
                                              color: AppColors.primary,
                                            ),
                                          ),
                                          SizedBox(height: 8.rsh(context)),
                                          Text(
                                            context.l10n.communityChooseCover,
                                            style: TextStyle(
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 24.rsh(context)),

                          // Name Field
                          Text(
                            context.l10n.communityName,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: context.l10n.communityNameHint,
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 16.rsh(context)),

                          // Description Field
                          Text(
                            context.l10n.communityDescription,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          TextField(
                            controller: _descriptionController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              hintText: context.l10n.communityDescriptionHint,
                              hintStyle: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            style: TextStyle(color: AppColors.textPrimary),
                          ),
                          SizedBox(height: 16.rsh(context)),

                          // Privacy Dropdown
                          Text(
                            context.l10n.communityType,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedPrivacy,
                            dropdownColor: AppColors.background,
                            iconEnabledColor: AppColors.iconPrimary,
                            style: TextStyle(color: AppColors.textPrimary),
                            items: [
                              DropdownMenuItem(
                                value: 'public',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.public,
                                      size: 20.rsp(context),
                                      color: AppColors.iconPrimary,
                                    ),
                                    SizedBox(width: 8.rs(context)),
                                    Text(context.l10n.communityPublic),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'private',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.lock,
                                      size: 20.rsp(context),
                                      color: AppColors.iconPrimary,
                                    ),
                                    SizedBox(width: 8.rs(context)),
                                    Text(context.l10n.communityPrivate),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedPrivacy = value);
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24.rsh(context)),

                          // Type Dropdown
                          Text(
                            'Loại cộng đồng', // TODO: L10n later
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 8.rsh(context)),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedType,
                            dropdownColor: AppColors.background,
                            iconEnabledColor: AppColors.iconPrimary,
                            style: TextStyle(color: AppColors.textPrimary),
                            items: [
                              DropdownMenuItem(
                                value: 'standard',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.group,
                                      size: 20.rsp(context),
                                      color: AppColors.iconPrimary,
                                    ),
                                    SizedBox(width: 8.rs(context)),
                                    Text('Cộng đồng tiêu chuẩn'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'travel',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.travel_explore,
                                      size: 20.rsp(context),
                                      color: AppColors.iconPrimary,
                                    ),
                                    SizedBox(width: 8.rs(context)),
                                    Text('Cộng đồng du lịch'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _selectedType = value);
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: AppColors.background,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.divider,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  12.rsr(context),
                                ),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 32.rsh(context)),

                          // Submit Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is CommunityCreateLoading
                                  ? null
                                  : () {
                                      if (_nameController.text.isEmpty) {
                                        showErrorSnackBar(
                                          context,
                                          context.l10n.communityNameRequired,
                                        );
                                        return;
                                      }

                                      context.read<CommunityCreateBloc>().add(
                                        CreateCommunityRequested(
                                          name: _nameController.text,
                                          description:
                                              _descriptionController
                                                  .text
                                                  .isNotEmpty
                                              ? _descriptionController.text
                                              : null,
                                          privacy: _selectedPrivacy,
                                          type: _selectedType,
                                          avatarPath: _avatarPath,
                                          coverImagePath: _coverImagePath,
                                        ),
                                      );
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(
                                  vertical: 16.rsh(context),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    14.rsr(context),
                                  ),
                                ),
                              ),
                              child: state is CommunityCreateLoading
                                  ? SizedBox(
                                      height: 20.rsh(context),
                                      width: 20.rs(context),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      ),
                                    )
                                  : Text(
                                      context.l10n.communityCreateTitle,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.rsp(context),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
