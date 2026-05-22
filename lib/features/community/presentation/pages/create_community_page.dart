import 'dart:io';
import 'package:flutter/material.dart';
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
  const CreateCommunityPage({super.key});

  @override
  State<CreateCommunityPage> createState() => _CreateCommunityPageState();
}

class _CreateCommunityPageState extends State<CreateCommunityPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedPrivacy = 'public';
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
      showErrorSnackBar(
        context,
        context.l10n.communityPickImageError(e.toString()),
      );
    }
  }

  void _showImageSourceMenu({required bool isAvatar}) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(context.l10n.postCamera),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, isAvatar: isAvatar);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
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
            Future.delayed(const Duration(seconds: 1), () {
              if (mounted) {
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
        child: Scaffold(
          backgroundColor: const Color(0xFFF4F7FB),
          appBar: AppBar(
            title: Text(
              context.l10n.communityCreateTitle,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            backgroundColor: const Color(0xFFF4F7FB),
            elevation: 0,
            scrolledUnderElevation: 0,
          ),
          body: BlocBuilder<CommunityCreateBloc, CommunityCreateState>(
            builder: (context, state) {
              return SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1363DF), Color(0xFF0096C7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.groups_2_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              context.l10n.communityCreateIntro,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Avatar Section
                    Text(
                      context.l10n.communityAvatar,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showImageSourceMenu(isAvatar: true),
                      child: Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
                        ),
                        child: _avatarPath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  File(_avatarPath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEAF2FF),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.add_photo_alternate_rounded,
                                        size: 28,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      context.l10n.communityChooseAvatar,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cover Image Section
                    Text(
                      context.l10n.communityCoverImage,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _showImageSourceMenu(isAvatar: false),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: const Color(0xFFD0D5DD)),
                        ),
                        child: _coverImagePath != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: Image.file(
                                  File(_coverImagePath!),
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFE8FBF5),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.wallpaper_rounded,
                                        size: 28,
                                        color: Color(0xFF0F766E),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      context.l10n.communityChooseCover,
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name Field
                    Text(
                      context.l10n.communityName,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: context.l10n.communityNameHint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D5DD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Description Field
                    Text(
                      context.l10n.communityDescription,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _descriptionController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: context.l10n.communityDescriptionHint,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D5DD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Privacy Dropdown
                    Text(
                      context.l10n.communityType,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedPrivacy,
                      items: [
                        DropdownMenuItem(
                          value: 'public',
                          child: Row(
                            children: [
                              const Icon(Icons.public, size: 20),
                              const SizedBox(width: 8),
                              Text(context.l10n.communityPublic),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'private',
                          child: Row(
                            children: [
                              const Icon(Icons.lock, size: 20),
                              const SizedBox(width: 8),
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
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFFD0D5DD),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

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
                                        _descriptionController.text.isNotEmpty
                                        ? _descriptionController.text
                                        : null,
                                    privacy: _selectedPrivacy,
                                    avatarPath: _avatarPath,
                                    coverImagePath: _coverImagePath,
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: state is CommunityCreateLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                context.l10n.communityCreateTitle,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
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
    );
  }
}
