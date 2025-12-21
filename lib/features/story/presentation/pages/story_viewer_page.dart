import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:social_app_fe/core/enums/media_type.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_background_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_footer_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_header_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_react_count_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_reacts_bottom_sheet.dart';

class StoryViewerPage extends StatefulWidget {
  final List<GroupedUserStoryEntity> groups;
  final int initialGroupIndex;
  final int initialStoryIndex;
  final int durationSeconds;

  const StoryViewerPage({
    super.key,
    required this.groups,
    this.initialGroupIndex = 0,
    this.initialStoryIndex = 0,
    this.durationSeconds = 10,
  }) : assert(groups.length > 0);

  @override
  State<StoryViewerPage> createState() => _StoryViewerPageState();
}

class _StoryViewerPageState extends State<StoryViewerPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _textController = TextEditingController();
  late int _currentGroupIndex;
  late int _currentStoryIndex;

  // Audio player for Deezer preview
  late final AudioPlayer _audioPlayer;
  
  int _currentMusicDurationSeconds = 10; // Mặc định 10 giây nếu không có nhạc
  
  int _currentVideoDurationSeconds = 0; // 0 = chưa có video hoặc chưa load
  
  bool _durationUpdatedForCurrentStory = false;

  // Thêm biến để theo dõi vị trí kéo
  Offset _dragOffset = Offset.zero;

  // Biến để xác định hướng trượt
  double _slideDirection =
      1.0; // 1.0 = trượt sang trái (Next), -1.0 = trượt sang phải (Prev)
  // biến theo dõi vị trí kéo ngang khi vuốt giữa các nhóm
  double _horizontalOffset = 0.0;
  
  // Current user ID để kiểm tra story của chính user
  String? _currentUserId;

  GroupedUserStoryEntity get _currentGroup => widget.groups[_currentGroupIndex];
  StoryEntity get _currentStory => _currentGroup.stories[_currentStoryIndex];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudioPlayerListeners();
    _currentGroupIndex = widget.initialGroupIndex.clamp(
      0,
      widget.groups.length - 1,
    );
    _currentStoryIndex = widget.initialStoryIndex.clamp(
      0,
      widget.groups[_currentGroupIndex].stories.length - 1,
    );
    _loadCurrentUserId();
    _initController();
    _controller.forward();
    _playCurrentPreview();
  }
  
  Future<void> _loadCurrentUserId() async {
    final userData = await TokenStorage.getUserData();
    if (userData != null && mounted) {
      setState(() {
        _currentUserId = userData['id'];
      });
    }
  }
  
  void _setupAudioPlayerListeners() {
    _audioPlayer.onDurationChanged.listen((duration) {
      if (mounted && duration.inSeconds > 0) {
        final newDuration = duration.inSeconds;
        final isFirstUpdate = !_durationUpdatedForCurrentStory;
        
        setState(() {
          _currentMusicDurationSeconds = newDuration;
          _durationUpdatedForCurrentStory = true;
        });
        
        if (_currentStory.mediaType != MediaType.video) {
          // Cập nhật duration của AnimationController
          if (isFirstUpdate) {
            _controller.duration = Duration(seconds: newDuration);
            _controller.reset();
            _controller.forward();
          } else {
            _updateControllerDuration(newDuration);
          }
        }
      }
    });
  }
  
  void _onVideoDurationChanged(int durationSeconds) {
    if (mounted && durationSeconds > 0) {
      final isFirstUpdate = !_durationUpdatedForCurrentStory;
      
      setState(() {
        _currentVideoDurationSeconds = durationSeconds;
        _durationUpdatedForCurrentStory = true;
      });
      
      if (isFirstUpdate) {
        _controller.duration = Duration(seconds: durationSeconds);
        _controller.reset();
        _controller.forward();
      } else {
        _updateControllerDuration(durationSeconds);
      }
    }
  }

  void _initController() {
    final initialDuration = _getStoryDuration();
    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(seconds: initialDuration),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _onNext();
          }
        });
  }
  
  int _getStoryDuration() {
    if (_currentStory.mediaType == MediaType.video && _currentVideoDurationSeconds > 0) {
      return _currentVideoDurationSeconds;
    }
    if (_currentStory.music != null && _currentMusicDurationSeconds > 0) {
      return _currentMusicDurationSeconds;
    }
    return widget.durationSeconds;
  }
  
  void _updateControllerDuration(int durationSeconds) {
    if (_controller.duration?.inSeconds != durationSeconds) {
      final wasPlaying = _controller.isAnimating;
      final wasCompleted = _controller.status == AnimationStatus.completed;
      
      double newValue = 0.0;
      if (wasPlaying && !wasCompleted) {
        final oldDuration = _controller.duration?.inSeconds ?? widget.durationSeconds;
        if (oldDuration > 0) {
          newValue = (_controller.value * oldDuration) / durationSeconds;
          newValue = newValue.clamp(0.0, 1.0);
        }
      }
      
      _controller.duration = Duration(seconds: durationSeconds);
      _controller.value = newValue;
      
      if (wasPlaying && !wasCompleted) {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _resetAndPlay() {
    setState(() {
      _currentMusicDurationSeconds = widget.durationSeconds;
      _currentVideoDurationSeconds = 0; // Reset video duration
      _durationUpdatedForCurrentStory = false;
    });
    _updateControllerDuration(widget.durationSeconds);
    
    _controller.stop();
    _controller.reset();
    _controller.forward();
    _playCurrentPreview();
  }

  void _close() {
    _controller.stop();
    _audioPlayer.stop();
    Navigator.of(context).pop();
  }

  void _onPrev() {
    if (_currentStoryIndex > 0) {
      setState(() => _currentStoryIndex--);
      _resetAndPlay();
    } else if (_currentGroupIndex > 0) {
      // move to previous group, last story
      setState(() {
        _slideDirection = -1.0; // Đặt hướng trượt sang phải
        _currentGroupIndex--;
        _currentStoryIndex =
            widget.groups[_currentGroupIndex].stories.length - 1;
      });
      _resetAndPlay();
    } else {
      _resetAndPlay();
    }
  }

  void _onNext() {
    if (_currentStoryIndex <
        widget.groups[_currentGroupIndex].stories.length - 1) {
      setState(() => _currentStoryIndex++);
      _resetAndPlay();
    } else if (_currentGroupIndex < widget.groups.length - 1) {
      // move to next group, first story
      setState(() {
        _slideDirection = 1.0; // Đặt hướng trượt sang trái
        _currentGroupIndex++;
        _currentStoryIndex = 0;
      });
      _resetAndPlay();
    } else {
      _close();
    }
  }

  Future<void> _playCurrentPreview() async {
    final previewUrl = _currentStory.music?.preview;
    if (previewUrl == null || previewUrl.isEmpty) {
      await _audioPlayer.stop();
      setState(() {
        _currentMusicDurationSeconds = widget.durationSeconds;
        _durationUpdatedForCurrentStory = true; 
      });
      _updateControllerDuration(widget.durationSeconds);
      return;
    }
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(UrlSource(previewUrl));
      await _audioPlayer.resume();
    } catch (_) {
      setState(() {
        _currentMusicDurationSeconds = widget.durationSeconds;
        _durationUpdatedForCurrentStory = true; 
      });
      _updateControllerDuration(widget.durationSeconds);
    }
  }

  void _onTapDown(TapDownDetails details) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final dx = details.globalPosition.dx;
    final dy = details.globalPosition.dy;
    

    final isOwnStory = _currentStory.user.userId == _currentUserId;
    final footerHeight = 80.0; // Chiều cao ước tính của footer area
    final isInFooterArea = dy > (height - footerHeight);
    
    // Nếu tap vào footer area và không phải story của chính mình, không xử lý
    if (!isOwnStory && isInFooterArea) {
      return;
    }
    
    if (dx < width / 2) {
      _onPrev();
    } else {
      _onNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: _onTapDown,
          onLongPressStart: (_) {
            _controller.stop();
            _audioPlayer.pause();
          },
          onLongPressEnd: (_) {
            _controller.forward();
            _audioPlayer.resume();
          },
          onVerticalDragStart: (_) {
            _controller.stop();
            _audioPlayer.pause();
          },
          onHorizontalDragStart: (_) {
            _controller.stop();
            _audioPlayer.pause();
          },
          onVerticalDragUpdate: (details) {
            setState(() {
              //  _dragOffset sẽ theo dõi cả kéo lên (dy < 0) và kéo xuống (dy > 0)
              _dragOffset = Offset(0, _dragOffset.dy + details.delta.dy);
            });
          },
          onHorizontalDragUpdate: (details) {
            setState(() {
              _horizontalOffset += details.delta.dx;
            });
          },
          onVerticalDragEnd: (details) {
            final screenSize = MediaQuery.of(context).size;

            // Thoát nếu kéo đủ xa (lên hoặc xuống) HOẶC vuốt đủ nhanh (lên hoặc xuống)
            if (_dragOffset.dy.abs() > screenSize.height / 4 ||
                (details.primaryVelocity ?? 0).abs() > 300) {
              _close();
            } else {
              // Nếu không, trả về vị trí cũ và chạy lại story
              setState(() {
                _dragOffset = Offset.zero;
              });
              _controller.forward();
              _audioPlayer.resume();
            }
          },
          onHorizontalDragEnd: (details) {
            final screenSize = MediaQuery.of(context).size;
            final dx = _horizontalOffset;
            final vx = details.primaryVelocity ?? 0;
            // threshold: swipe more than 20% width or velocity
            final threshold = screenSize.width * 0.2;
            if (dx.abs() > threshold || vx.abs() > 300) {
              if (dx < 0 || vx < 0) {
                // swiped left -> go to next group
                if (_currentGroupIndex < widget.groups.length - 1) {
                  setState(() {
                    _slideDirection = 1.0;
                    _currentGroupIndex++;
                    _currentStoryIndex = 0;
                  });
                  _resetAndPlay();
                } else {
                  _close();
                }
              } else if (dx > 0 || vx > 0) {
                // swiped right -> previous group
                if (_currentGroupIndex > 0) {
                  setState(() {
                    _slideDirection = -1.0;
                    _currentGroupIndex--;
                    _currentStoryIndex =
                        widget.groups[_currentGroupIndex].stories.length - 1;
                  });
                  _resetAndPlay();
                } else {
                  // at first group, reset
                  _resetAndPlay();
                }
              }
            } else {
              // not a full swipe - reset offset
              setState(() {
                _horizontalOffset = 0.0;
              });
              _controller.forward();
              _audioPlayer.resume();
            }
            // reset offset after handling
            setState(() {
              _horizontalOffset = 0.0;
            });
          },
          child: Transform.translate(
            offset: Offset(_horizontalOffset, _dragOffset.dy),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                // Hiệu ứng cho widget mới đi vào
                final inAnimation = Tween<Offset>(
                  begin: Offset(_slideDirection, 0.0),
                  end: Offset.zero,
                ).animate(animation);

                // Hiệu ứng cho widget cũ đi ra
                final outAnimation = Tween<Offset>(
                  begin: Offset(-_slideDirection, 0.0),
                  end: Offset.zero,
                ).animate(animation);

                // Áp dụng hiệu ứng dựa trên key
                if (child.key == ValueKey<int>(_currentGroupIndex)) {
                  return SlideTransition(position: inAnimation, child: child);
                } else {
                  return SlideTransition(position: outAnimation, child: child);
                }
              },

              child: Stack(
                key: ValueKey<int>(_currentGroupIndex),
                children: [
                  // Media
                  StoryBackgroundWidget(
                    key: ValueKey('${_currentGroupIndex}_${_currentStoryIndex}_${_currentStory.mediaUrl}'),
                    mediaUrl: _currentStory.mediaUrl,
                    mediaType: _currentStory.mediaType,
                    dragOffset: _dragOffset,
                    shouldPlay: true,
                    onVideoDurationChanged: _onVideoDurationChanged,
                  ),

                  // Header
                  StoryHeaderWidget(
                    animationController: _controller,
                    currentGroup: _currentGroup,
                    currentStoryIndex: _currentStoryIndex,
                    onClose: _close,
                    currentUserId: _currentUserId,
                  ),

                  // Bottom: comment input + reactions (chỉ hiển thị khi không phải story của chính mình)
                  StoryFooterWidget(
                    textController: _textController,
                    story: _currentStory,
                    currentUserId: _currentUserId,
                    isOwnStory: _currentStory.user.userId == _currentUserId,
                  ),

                  // Hiển thị số lượng react ở góc trái dưới cho story của chính mình
                  if (_currentStory.user.userId == _currentUserId)
                    StoryReactCountWidget(
                      story: _currentStory,
                      onTap: () {
                        StoryReactsBottomSheet.show(context, story: _currentStory);
                      },
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
