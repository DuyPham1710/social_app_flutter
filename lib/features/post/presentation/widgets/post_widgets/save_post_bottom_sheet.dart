import 'package:flutter/material.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/resources/data_state.dart';
import 'package:social_app_fe/features/post/domain/entities/post_entity.dart';
import 'package:social_app_fe/features/save/domain/repository/save_repository.dart';
import 'package:social_app_fe/features/save/presentation/pages/saved_items_page.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_success_snackBar.dart';

class SavePostBottomSheet extends StatefulWidget {
  final PostEntity post;
  final Function(String savedId) onSaved;

  const SavePostBottomSheet({
    super.key,
    required this.post,
    required this.onSaved,
  });

  @override
  State<SavePostBottomSheet> createState() => _SavePostBottomSheetState();

  static void show(
    BuildContext context, {
    required PostEntity post,
    required Function(String savedId) onSaved,
  }) {
    if (ResponsiveHelper.isWebOrDesktop) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: SavePostBottomSheet(post: post, onSaved: onSaved),
          );
        },
      );
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) {
          return SavePostBottomSheet(post: post, onSaved: onSaved);
        },
      );
    }
  }
}

class _SavePostBottomSheetState extends State<SavePostBottomSheet> {
  final SaveRepository _saveRepository = s1<SaveRepository>();
  bool _isLoading = true;
  bool _isSaving = false;
  List<Map<String, dynamic>> _collections = []; // name, image

  @override
  void initState() {
    super.initState();
    _loadCollections();
  }

  Future<void> _loadCollections() async {
    try {
      final result = await _saveRepository.getSavedByUser(
        type: 'post',
        limit: 50,
      );
      if (result is DataStateSuccess && result.data != null) {
        // Group by collection name
        final Map<String, String?> collectionMap = {};
        for (var item in result.data!.data) {
          if (!collectionMap.containsKey(item.collection)) {
            // Find a thumbnail from the post content if available (for simplified demo we use content or null)
            collectionMap[item.collection] = item.content.isNotEmpty
                ? item.content
                : null;
          }
        }

        final collections = collectionMap.entries
            .map((e) => {'name': e.key, 'image': e.value})
            .toList();
        if (!collectionMap.containsKey('default')) {
          collections.insert(0, {'name': 'default', 'image': null});
        }

        setState(() {
          _collections = collections;
          _isLoading = false;
        });
      } else {
        setState(() {
          _collections = [
            {'name': 'default', 'image': null},
          ];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _collections = [
          {'name': 'default', 'image': null},
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _saveToCollection(String collectionName) async {
    final l10n = context.l10n;
    setState(() {
      _isSaving = true;
    });

    try {
      String? contentPreview;
      if (widget.post.urls.isNotEmpty) {
        contentPreview = widget.post.urls.first.url;
      }

      final result = await _saveRepository.savePost(
        targetId: widget.post.id,
        type: 'post',
        collection: collectionName,
        content: contentPreview,
      );

      if (mounted) {
        Navigator.pop(context); // Close bottom sheet

        if (result is DataStateSuccess && result.data != null) {
          widget.onSaved(result.data!.id);
          showSuccessSnackBar(
            context,
            l10n.postSavedToCollection(collectionName),
          );
        } else if (result is DataStateError) {
          showErrorSnackBar(
            context,
            l10n.postErrorPrefix(result.error?.message ?? l10n.postSaveFailed),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showErrorSnackBar(context, l10n.postErrorPrefix(e.toString()));
      }
    }
  }

  Future<void> _showCreateCollectionDialog() async {
    final l10n = context.l10n;
    final TextEditingController controller = TextEditingController();

    final collectionName = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          surfaceTintColor: Colors.transparent,
          title: Text(
            l10n.postCreateCollectionTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          content: TextField(
            controller: controller,
            style: TextStyle(
              fontSize: 14.rsp(context),
              color: AppColors.textPrimary,
            ),
            cursorColor: AppColors.primary,
            decoration: InputDecoration(
              hintText: l10n.postCollectionNameHint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.rsp(context),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.rs(context),
                vertical: 10.rsh(context),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.rsr(context)),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.rsr(context)),
                borderSide: BorderSide(color: AppColors.divider),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.rsr(context)),
                borderSide: BorderSide(color: AppColors.primary),
              ),
              fillColor: AppColors.secondBackground,
              filled: true,
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                l10n.commonCancel,
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Navigator.pop(context, controller.text.trim());
                }
              },
              child: Text(
                l10n.commonCreate,
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        );
      },
    );

    if (collectionName != null && collectionName.isNotEmpty) {
      _saveToCollection(collectionName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = ResponsiveHelper.isWebOrDesktop;

    final childWidget = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isWeb) ...[
          SizedBox(height: 12.rsh(context)),
          Center(
            child: Container(
              width: 40.rs(context),
              height: 4.rsh(context),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2.rsr(context)),
              ),
            ),
          ),
        ] else ...[
          // For web dialog, show a close button / title at the top
          Padding(
            padding: EdgeInsets.fromLTRB(
              16.rs(context),
              16.rsh(context),
              16.rs(context),
              8.rsh(context),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.postAddToCollection,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.rsp(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: AppColors.iconPrimary,
                    size: 20.rsp(context),
                  ),
                  onPressed: () => Navigator.pop(context),
                  splashRadius: 20.rsr(context),
                ),
              ],
            ),
          ),

          Divider(height: 1.rsh(context), color: AppColors.divider),
        ],

        SizedBox(height: 16.rsh(context)),

        InkWell(
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SavedItemsPage()),
            );
          },

          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16.rs(context),
              vertical: 8.rsh(context),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.rs(context),
                  height: 40.rs(context),
                  decoration: BoxDecoration(
                    color: AppColors.secondBackground,
                    shape: BoxShape.circle,
                  ),

                  child: Icon(Icons.bookmark, color: AppColors.textPrimary),
                ),

                SizedBox(width: 12.rs(context)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.l10n.postSaved,
                        style: TextStyle(
                          fontSize: 16.rsp(context),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),

                      SizedBox(height: 2.rsh(context)),

                      Row(
                        children: [
                          Icon(
                            Icons.lock,
                            size: 12.rsp(context),
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(width: 4.rs(context)),
                          Text(
                            context.l10n.postOnlyMe,
                            style: TextStyle(
                              fontSize: 12.rsp(context),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.rsh(context)),
          child: Divider(height: 1.rsh(context), color: AppColors.divider),
        ),

        // Collection list header
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.rs(context),
            vertical: 8.rsh(context),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                context.l10n.postAddToCollection,
                style: TextStyle(
                  fontSize: 18.rsp(context),
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _showCreateCollectionDialog,
                child: Text(
                  context.l10n.commonCreate,
                  style: TextStyle(
                    fontSize: 16.rsp(context),
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Collection List
        if (_isLoading)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (_isSaving)
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(vertical: 8.rsh(context)),
              itemCount: _collections.length,
              itemBuilder: (context, index) {
                final item = _collections[index];
                return _buildCollectionItem(
                  context,
                  item['name'],
                  item['image'],
                );
              },
            ),
          ),
      ],
    );

    if (isWeb) {
      return Center(
        child: Container(
          width: 480,
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(color: Colors.transparent, child: childWidget),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.rsr(context)),
          topRight: Radius.circular(20.rsr(context)),
        ),
      ),
      child: SafeArea(child: childWidget),
    );
  }

  Widget _buildCollectionItem(
    BuildContext context,
    String title,
    String? imageUrl,
  ) {
    return InkWell(
      onTap: () => _saveToCollection(title),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.rs(context),
          vertical: 8.rsh(context),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 50.rs(context),
              height: 50.rs(context),
              decoration: BoxDecoration(
                color: AppColors.secondBackground,
                borderRadius: BorderRadius.circular(8.rsr(context)),
                image: imageUrl != null && imageUrl.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: imageUrl == null || imageUrl.isEmpty
                  ? Icon(Icons.bookmark_border, color: AppColors.unselectedIcon)
                  : null,
            ),
            SizedBox(width: 12.rs(context)),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.rsp(context),
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.rsh(context)),
                  Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 12.rsp(context),
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4.rs(context)),
                      Text(
                        context.l10n.postOnlyMe,
                        style: TextStyle(
                          fontSize: 12.rsp(context),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Add icon
            Container(
              width: 30.rs(context),
              height: 30.rs(context),
              decoration: BoxDecoration(
                color: Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.textSecondary, width: 1.5),
              ),
              child: Icon(
                Icons.add,
                size: 20.rsp(context),
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
