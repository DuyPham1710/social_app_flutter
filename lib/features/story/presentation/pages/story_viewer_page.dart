import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:social_app_fe/features/story/domain/entities/story_entity.dart';
import 'package:social_app_fe/features/story/domain/entities/grouped_story_list_entity.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_background_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_footer_widget.dart';
import 'package:social_app_fe/features/story/presentation/widgets/story_header_widget.dart';

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

  // Thêm biến để theo dõi vị trí kéo
  Offset _dragOffset = Offset.zero;

  // Biến để xác định hướng trượt
  double _slideDirection =
      1.0; // 1.0 = trượt sang trái (Next), -1.0 = trượt sang phải (Prev)
  // biến theo dõi vị trí kéo ngang khi vuốt giữa các nhóm
  double _horizontalOffset = 0.0;

  GroupedUserStoryEntity get _currentGroup => widget.groups[_currentGroupIndex];
  StoryEntity get _currentStory => _currentGroup.stories[_currentStoryIndex];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentGroupIndex = widget.initialGroupIndex.clamp(
      0,
      widget.groups.length - 1,
    );
    _currentStoryIndex = widget.initialStoryIndex.clamp(
      0,
      widget.groups[_currentGroupIndex].stories.length - 1,
    );
    _initController();
    _controller.forward();
    _playCurrentPreview();
  }

  void _initController() {
    _controller =
        AnimationController(
          vsync: this,
          duration: Duration(seconds: widget.durationSeconds),
        )..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            _onNext();
          }
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    _textController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _resetAndPlay() {
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
      return;
    }
    try {
      await _audioPlayer.stop();
      await _audioPlayer.setSource(UrlSource(previewUrl));
      await _audioPlayer.resume();
    } catch (_) {
      // Silently ignore playback errors for now
    }
  }

  void _onTapDown(TapDownDetails details) {
    final width = MediaQuery.of(context).size.width;
    final dx = details.globalPosition.dx;
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
          onLongPressStart: (_) => _controller.stop(),
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
                    mediaUrl: _currentStory.mediaUrl,
                    dragOffset: _dragOffset,
                  ),

                  // Header
                  StoryHeaderWidget(
                    animationController: _controller,
                    currentGroup: _currentGroup,
                    currentStoryIndex: _currentStoryIndex,
                    onClose: _close,
                  ),

                  // Bottom: comment input + reactions
                  StoryFooterWidget(textController: _textController),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
