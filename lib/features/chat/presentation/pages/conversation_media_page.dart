import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/di/injection.dart';
import 'package:social_app_fe/core/utils/date_time_extensions.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/chat/domain/entities/chat_media_entity.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_media/chat_media_cubit.dart';
import 'package:social_app_fe/features/chat/presentation/bloc/chat_media/chat_media_state.dart';
import 'package:social_app_fe/features/chat/presentation/pages/pdf_viewer_page.dart';
import 'package:social_app_fe/features/post/presentation/pages/video_player_screen.dart';
import 'package:social_app_fe/shared/helpers/full_screen_image_viewer.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';
import 'package:social_app_fe/shared/helpers/show_info_snackBar.dart';
import 'package:social_app_fe/shared/helpers/video_thumbnail.dart';
import 'package:social_app_fe/l10n/l10n.dart';

String _getAbsoluteUrl(String url) {
  if (url.startsWith('/')) {
    final baseUrl = dotenv.env['BASE_URL'] ?? 'http://192.168.100.218:3000/';
    final baseUrlWithoutTrailingSlash = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    return '$baseUrlWithoutTrailingSlash$url';
  }
  return url;
}

String _formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
  return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
}

class ConversationMediaPage extends StatefulWidget {
  final String conversationId;
  final bool isWebLayout;
  final VoidCallback? onBack;

  const ConversationMediaPage({
    super.key,
    required this.conversationId,
    this.isWebLayout = false,
    this.onBack,
  });

  @override
  State<ConversationMediaPage> createState() => _ConversationMediaPageState();
}

class _ConversationMediaPageState extends State<ConversationMediaPage> {
  @override
  Widget build(BuildContext context) {
    final isVi = Localizations.localeOf(context).languageCode == 'vi';

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          centerTitle: ResponsiveHelper.isWebOrDesktop,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
            onPressed: () {
              if (widget.isWebLayout && widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Text(
            isVi ? 'Ảnh, video, tài liệu và link' : 'Media, files, and links',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: ResponsiveHelper.isWebOrDesktop ? 900 : double.infinity,
                ),
                child: TabBar(
                  isScrollable: false,
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.textSecondary,
                  labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.normal,
                  ),
                  tabs: [
                    Tab(text: isVi ? 'Ảnh' : 'Images'),
                    Tab(text: isVi ? 'Video' : 'Videos'),
                    Tab(text: isVi ? 'Tài liệu' : 'Files'),
                    Tab(text: isVi ? 'Liên kết' : 'Links'),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveHelper.isWebOrDesktop ? 900 : double.infinity,
            ),
            child: TabBarView(
              children: [
                _MediaGridTab(
                  conversationId: widget.conversationId,
                  type: 'image',
                  isWebLayout: widget.isWebLayout,
                ),
                _MediaGridTab(
                  conversationId: widget.conversationId,
                  type: 'video',
                  isWebLayout: widget.isWebLayout,
                ),
                _FileListTab(conversationId: widget.conversationId),
                _LinkListTab(conversationId: widget.conversationId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaGridTab extends StatefulWidget {
  final String conversationId;
  final String type;
  final bool isWebLayout;

  const _MediaGridTab({
    required this.conversationId,
    required this.type,
    this.isWebLayout = false,
  });

  @override
  State<_MediaGridTab> createState() => _MediaGridTabState();
}

class _MediaGridTabState extends State<_MediaGridTab> {
  final ScrollController _scrollController = ScrollController();
  late ChatMediaCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatMediaCubit(
      getConversationMediaUseCase: s1(),
      conversationId: widget.conversationId,
      type: widget.type,
    )..loadMedia();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _cubit.loadMedia();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ChatMediaCubit, ChatMediaState>(
        builder: (context, state) {
          if (state is ChatMediaInitial ||
              (state is ChatMediaLoading && state.isFirstFetch)) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatMediaEntity> items = [];
          bool hasMore = false;
          if (state is ChatMediaLoading) {
            items = state.oldItems;
          } else if (state is ChatMediaLoaded) {
            items = state.items;
            hasMore = state.hasMore;
          } else if (state is ChatMediaError) {
            return Center(child: Text(state.message));
          }

          if (items.isEmpty) {
            return Center(
              child: Text(
                widget.type == 'image'
                    ? (Localizations.localeOf(context).languageCode == 'vi'
                          ? 'Không có hình ảnh nào'
                          : 'No images found')
                    : (Localizations.localeOf(context).languageCode == 'vi'
                          ? 'Không có video nào'
                          : 'No videos found'),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          final urls = items.map((e) => _getAbsoluteUrl(e.url)).toList();

          return GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(8.r),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (ResponsiveHelper.isWebOrDesktop && !widget.isWebLayout) ? 5 : 3,
              crossAxisSpacing: 8.r,
              mainAxisSpacing: 8.r,
            ),
            itemCount: items.length + (hasMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = items[index];
              final absoluteUrl = _getAbsoluteUrl(item.url);

              return GestureDetector(
                onTap: () {
                  if (widget.type == 'image') {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FullScreenImageViewer(
                          imageUrls: urls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoData: absoluteUrl),
                      ),
                    );
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (widget.type == 'image')
                          Image.network(
                            absoluteUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.broken_image,
                              color: AppColors.textSecondary,
                              size: 24.sp,
                            ),
                          )
                        else
                          buildVideoThumbnail(absoluteUrl),
                        if (widget.type == 'video')
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Colors.black38,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 24.sp,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FileListTab extends StatefulWidget {
  final String conversationId;

  const _FileListTab({required this.conversationId});

  @override
  State<_FileListTab> createState() => _FileListTabState();
}

class _FileListTabState extends State<_FileListTab> {
  final ScrollController _scrollController = ScrollController();
  late ChatMediaCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatMediaCubit(
      getConversationMediaUseCase: s1(),
      conversationId: widget.conversationId,
      type: 'file',
    )..loadMedia();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _cubit.loadMedia();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  Future<void> _downloadAndOpenFile(
    BuildContext context,
    String url,
    String fileName,
  ) async {
    try {
      if (kIsWeb) {
        final uri = Uri.tryParse(url);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          showErrorSnackBar(context, 'Invalid download URL');
        }
        return;
      }

      showInfoSnackBar(context, context.l10n.chatDownloadingFile);

      final tempDir = await getTemporaryDirectory();
      final safeFileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');
      final savePath = '${tempDir.path}/$safeFileName';

      final file = File(savePath);
      if (!await file.exists()) {
        final dio = Dio();
        await dio.download(url, savePath);
      }

      final result = await OpenFilex.open(savePath);
      if (result.type != ResultType.done && context.mounted) {
        showErrorSnackBar(context, context.l10n.chatNoAppToOpenFile);
      }
    } catch (e) {
      if (context.mounted) {
        showErrorSnackBar(
          context,
          context.l10n.chatOpenFileFailed(e.toString()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ChatMediaCubit, ChatMediaState>(
        builder: (context, state) {
          if (state is ChatMediaInitial ||
              (state is ChatMediaLoading && state.isFirstFetch)) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatMediaEntity> items = [];
          bool hasMore = false;
          if (state is ChatMediaLoading) {
            items = state.oldItems;
          } else if (state is ChatMediaLoaded) {
            items = state.items;
            hasMore = state.hasMore;
          } else if (state is ChatMediaError) {
            return Center(child: Text(state.message));
          }

          if (items.isEmpty) {
            return Center(
              child: Text(
                Localizations.localeOf(context).languageCode == 'vi'
                    ? 'Không có tài liệu nào'
                    : 'No documents found',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(12.r),
            itemCount: items.length + (hasMore ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = items[index];
              final absoluteUrl = _getAbsoluteUrl(item.url);
              final fileName = item.name ?? 'Document';
              final formattedSize = _formatFileSize(item.size ?? 0);
              final sentDate = item.sentAt.formatRelativeTime();

              return ListTile(
                onTap: () async {
                  if (!kIsWeb && fileName.toLowerCase().endsWith('.pdf')) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PdfViewerPage(url: absoluteUrl, fileName: fileName),
                      ),
                    );
                  } else {
                    await _downloadAndOpenFile(context, absoluteUrl, fileName);
                  }
                },
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 4.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
                tileColor: AppColors.textSecondary.withOpacity(0.03),
                leading: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.insert_drive_file_outlined,
                    color: AppColors.primary,
                    size: 24.sp,
                  ),
                ),
                title: Text(
                  fileName,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '$formattedSize • $sentDate',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.textSecondary,
                  size: 14.sp,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _LinkListTab extends StatefulWidget {
  final String conversationId;

  const _LinkListTab({required this.conversationId});

  @override
  State<_LinkListTab> createState() => _LinkListTabState();
}

class _LinkListTabState extends State<_LinkListTab> {
  final ScrollController _scrollController = ScrollController();
  late ChatMediaCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ChatMediaCubit(
      getConversationMediaUseCase: s1(),
      conversationId: widget.conversationId,
      type: 'link',
    )..loadMedia();

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      _cubit.loadMedia();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<ChatMediaCubit, ChatMediaState>(
        builder: (context, state) {
          if (state is ChatMediaInitial ||
              (state is ChatMediaLoading && state.isFirstFetch)) {
            return const Center(child: CircularProgressIndicator());
          }

          List<ChatMediaEntity> items = [];
          bool hasMore = false;
          if (state is ChatMediaLoading) {
            items = state.oldItems;
          } else if (state is ChatMediaLoaded) {
            items = state.items;
            hasMore = state.hasMore;
          } else if (state is ChatMediaError) {
            return Center(child: Text(state.message));
          }

          if (items.isEmpty) {
            return Center(
              child: Text(
                Localizations.localeOf(context).languageCode == 'vi'
                    ? 'Không có liên kết nào'
                    : 'No links found',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
            );
          }

          return ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.all(12.r),
            itemCount: items.length + (hasMore ? 1 : 0),
            separatorBuilder: (context, index) => SizedBox(height: 8.h),
            itemBuilder: (context, index) {
              if (index >= items.length) {
                return const Center(child: CircularProgressIndicator());
              }

              final item = items[index];
              final linkUrl = item.url;
              final sentDate = item.sentAt.formatRelativeTime();
              final senderName =
                  item.sender?.fullName ?? item.sender?.username ?? '';
              final senderAvatar = item.sender?.avatarUrl;

              return Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: AppColors.textSecondary.withOpacity(0.1),
                  ),
                ),
                color: AppColors.textSecondary.withOpacity(0.03),
                child: InkWell(
                  onTap: () async {
                    final uri = Uri.tryParse(linkUrl);
                    if (uri != null) {
                      await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 12.r,
                              backgroundImage: senderAvatar != null
                                  ? NetworkImage(_getAbsoluteUrl(senderAvatar))
                                  : const NetworkImage(
                                      "https://res.cloudinary.com/dk7ypst5k/image/upload/v1766304547/avt_bnegko.jpg",
                                    ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                senderName,
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              sentDate,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Icon(
                                Icons.link,
                                color: AppColors.primary,
                                size: 20.sp,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                linkUrl,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13.sp,
                                  decoration: TextDecoration.underline,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
