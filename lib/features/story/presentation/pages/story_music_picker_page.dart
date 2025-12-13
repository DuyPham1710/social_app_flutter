import 'dart:async';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/features/story/data/models/deezer_music_model.dart';
import 'package:social_app_fe/features/story/presentation/widgets/music_tile_widget.dart';

class StoryMusicPickerPage extends StatefulWidget {
  const StoryMusicPickerPage({super.key});

  @override
  State<StoryMusicPickerPage> createState() => _StoryMusicPickerPageState();
}

class _StoryMusicPickerPageState extends State<StoryMusicPickerPage> {
  final TextEditingController _searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final ScrollController _scrollController = ScrollController();
  Timer? _searchDebounce;

  bool _isLoading = true;
  String? _error;
  List<DeezerMusicModel> _tracks = [];
  
  // Search state
  bool _isSearching = false;
  bool _isSearchLoading = false;
  String? _searchError;
  List<DeezerMusicModel> _searchResults = [];
  int _searchCurrentPage = 0;
  bool _hasMoreSearchResults = true;
  String? _currentSearchQuery;
  
  int? _playingId;
  bool _isPaused = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchTracks();
    _scrollController.addListener(_onScroll);
    _audioPlayer.onPlayerComplete.listen((_) {
      if (mounted) {
        setState(() {
          _playingId = null;
          _isPaused = false;
          _position = Duration.zero;
          _duration = Duration.zero;
        });
      }
    });
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted) {
        setState(() {
          _duration = duration;
        });
      }
    });
    _audioPlayer.onPositionChanged.listen((position) {
      if (mounted) {
        setState(() {
          _position = position;
        });
      }
    });
  }

  void _onScroll() {
    if (!_isSearching || !_hasMoreSearchResults || _isSearchLoading) {
      return;
    }

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final delta = 200.0; // Tải thêm khi còn cách cuối 200px

    if (currentScroll >= (maxScroll - delta)) {
      _loadMoreSearchResults();
    }
  }

  Future<void> _fetchTracks() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final res = await Dio().get('https://api.deezer.com/chart');
      final data = res.data['tracks']?['data'] as List<dynamic>? ?? [];
      final parsed = data
          .map((e) => DeezerMusicModel.fromJson({
                'id': e['id'],
                'title': e['title'],
                'preview': e['preview'] ?? '',
                'artist': {
                  'id': e['artist']?['id'] ?? 0,
                  'name': e['artist']?['name'] ?? '',
                  'picture': e['artist']?['picture'] ??
                      e['artist']?['picture_medium'] ??
                      '',
                },
                'album': {
                  'id': e['album']?['id'] ?? 0,
                  'title': e['album']?['title'] ?? '',
                  'cover': e['album']?['cover'] ??
                      e['album']?['cover_medium'] ??
                      '',
                },
              }))
          .toList();
      if (mounted) {
        setState(() {
          _tracks = parsed;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'Không tải được danh sách nhạc. Vui lòng thử lại.';
          _isLoading = false;
        });
      }
    }
  }

  List<DeezerMusicModel> get _displayTracks {
    if (_isSearching) {
      return _searchResults;
    }
    return _tracks;
  }

  Future<void> _searchTracks(String query, {int page = 0, bool loadMore = false}) async {
    if (query.trim().isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
        _searchCurrentPage = 0;
        _hasMoreSearchResults = true;
        _currentSearchQuery = null;
      });
      return;
    }

    setState(() {
      if (!loadMore) {
        _isSearchLoading = true;
        _searchError = null;
        _searchResults = [];
        _searchCurrentPage = 0;
        _hasMoreSearchResults = true;
        _currentSearchQuery = query;
      }
    });

    try {
      final index = page * 10;
      final res = await Dio().get(
        'https://api.deezer.com/search',
        queryParameters: {
          'q': query,
          'limit': 10,
          'index': index,
        },
      );
      
      final data = res.data['data'] as List<dynamic>? ?? [];
      final total = res.data['total'] as int? ?? 0;
      
      final parsed = data
          .map((e) => DeezerMusicModel.fromJson({
                'id': e['id'],
                'title': e['title'],
                'preview': e['preview'] ?? '',
                'artist': {
                  'id': e['artist']?['id'] ?? 0,
                  'name': e['artist']?['name'] ?? '',
                  'picture': e['artist']?['picture'] ??
                      e['artist']?['picture_medium'] ??
                      '',
                },
                'album': {
                  'id': e['album']?['id'] ?? 0,
                  'title': e['album']?['title'] ?? '',
                  'cover': e['album']?['cover'] ??
                      e['album']?['cover_medium'] ??
                      '',
                },
              }))
          .toList();

      if (mounted && _currentSearchQuery == query) {
        setState(() {
          if (loadMore) {
            _searchResults.addAll(parsed);
          } else {
            _searchResults = parsed;
          }
          _searchCurrentPage = page;
          _hasMoreSearchResults = _searchResults.length < total;
          _isSearching = true;
          _isSearchLoading = false;
        });
      }
    } catch (_) {
      if (mounted && _currentSearchQuery == query) {
        setState(() {
          _searchError = 'Không tìm thấy kết quả. Vui lòng thử lại.';
          _isSearchLoading = false;
          if (!loadMore) {
            _searchResults = [];
          }
        });
      }
    }
  }

  Future<void> _loadMoreSearchResults() async {
    if (_isSearchLoading || !_hasMoreSearchResults || _currentSearchQuery == null) {
      return;
    }
    
    setState(() {
      _isSearchLoading = true;
    });
    
    await _searchTracks(
      _currentSearchQuery!,
      page: _searchCurrentPage + 1,
      loadMore: true,
    );
  }

  void _onSearchChanged(String query) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      _searchTracks(query);
    });
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111315),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSearchBar(context),
            if (!_isSearching)
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                child: Row(
                  children: [
                    Text(
                      "Dành cho bạn",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Xem tất cả",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 8.w, 0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1E21),
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white70),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {});
                        _onSearchChanged(value);
                      },
                      style: TextStyle(color: Colors.white, fontSize: 14.sp),
                      decoration: const InputDecoration(
                        hintText: "Tìm kiếm nhạc",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    IconButton(
                      splashRadius: 18,
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.clear, color: Colors.white70, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        _onSearchChanged('');
                      },
                    ),
                  IconButton(
                    splashRadius: 18,
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.mic_none, color: Colors.white70),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    // Show loading for initial chart load
    if (!_isSearching && _isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    // Show error for initial chart load
    if (!_isSearching && _error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: _fetchTracks,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    
    // Show loading for search
    if (_isSearching && _isSearchLoading && _searchResults.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    
    // Show search error
    if (_isSearching && _searchError != null && _searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _searchError!,
              style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            TextButton(
              onPressed: () => _searchTracks(_currentSearchQuery ?? ''),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    
    // Show empty state
    if (_displayTracks.isEmpty) {
      return Center(
        child: Text(
          _isSearching 
              ? 'Không tìm thấy bài hát phù hợp.'
              : 'Không có bài hát nào.',
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
      );
    }
    
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: const Color(0xFF111315),
      onRefresh: _isSearching 
          ? () => _searchTracks(_currentSearchQuery ?? '')
          : _fetchTracks,
      child: ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        itemCount: _displayTracks.length + (_isSearching && _hasMoreSearchResults && _isSearchLoading ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 6.h),
        itemBuilder: (context, index) {
          // Loading indicator khi đang tải thêm
          if (_isSearching && _hasMoreSearchResults && _isSearchLoading && index == _displayTracks.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            );
          }
          
          final item = _displayTracks[index];
          final isCurrentPlaying = _playingId == item.id && !_isPaused;
          final progress = isCurrentPlaying && _duration.inMilliseconds > 0
              ? _position.inMilliseconds / _duration.inMilliseconds
              : null;

          return MusicTileWidget(
            item: item,
            isPlaying: isCurrentPlaying,
            progress: progress,
            onPlay: () => _handlePlay(item),
            onTap: () => Navigator.of(context).pop(item),
          );
        },
      ),
    );
  }

  Future<void> _handlePlay(DeezerMusicModel item) async {
    // Nếu đang phát bài này thì toggle pause/resume
    if (_playingId == item.id) {
      final state = _audioPlayer.state;
      if (state == PlayerState.playing) {
        await _audioPlayer.pause();
        setState(() {
          _isPaused = true;
        });
      } else {
        await _audioPlayer.resume();
        setState(() {
          _isPaused = false;
        });
      }
      return;
    }

    // Phát bài mới
    setState(() {
      _playingId = item.id;
      _isPaused = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
    await _audioPlayer.stop();
    if (item.preview != null && item.preview!.isNotEmpty) {
      await _audioPlayer.play(UrlSource(item.preview!));
    } else {
      // không có preview
      setState(() {
        _playingId = null;
        _isPaused = false;
        _position = Duration.zero;
        _duration = Duration.zero;
      });
    }
  }
}
