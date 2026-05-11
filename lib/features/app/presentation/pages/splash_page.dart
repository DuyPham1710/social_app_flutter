import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/local/token_storage.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_bloc.dart';
import 'package:social_app_fe/features/menu/presentation/bloc/menu_event.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  static const _logoImagePath = 'assets/icons/logo.jpg';
  static const _logoVideoPath = 'assets/icons/logo.mp4';
  static const _fallbackIntroDuration = Duration(milliseconds: 1800);
  static const _fadeDuration = Duration(milliseconds: 280);

  late final VideoPlayerController _videoController;
  _SessionResult? _sessionResult;
  bool _isVideoReady = false;
  bool _showVideo = false;
  bool _isIntroDone = false;
  bool _isFadingOut = false;
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(_logoVideoPath);
    _prepareIntroVideo();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final user = await TokenStorage.getUserData();
    final token = await TokenStorage.getAccessToken();

    if (!mounted) return;

    _sessionResult = _SessionResult(
      isAuthenticated: user != null && token != null,
    );
    _tryNavigate();
  }

  Future<void> _prepareIntroVideo() async {
    try {
      await _videoController.initialize();
      await _videoController.setLooping(false);
      await _videoController.setVolume(0);

      if (!mounted) return;

      _videoController.addListener(_onVideoChanged);
      setState(() => _isVideoReady = true);

      await Future.delayed(const Duration(milliseconds: 80));
      if (!mounted) return;

      setState(() => _showVideo = true);
      await _videoController.play();

      final duration = _videoController.value.duration;
      Future.delayed(
        duration > Duration.zero
            ? duration + const Duration(milliseconds: 150)
            : _fallbackIntroDuration,
        _markIntroDone,
      );
    } catch (error) {
      debugPrint('[Splash] Unable to play intro video: $error');
      Future.delayed(_fallbackIntroDuration, _markIntroDone);
    }
  }

  void _onVideoChanged() {
    if (!_videoController.value.isInitialized || _isIntroDone) return;

    final position = _videoController.value.position;
    final duration = _videoController.value.duration;
    if (duration > Duration.zero &&
        position >= duration - const Duration(milliseconds: 120)) {
      _markIntroDone();
    }
  }

  void _markIntroDone() {
    if (!mounted || _isIntroDone) return;
    _isIntroDone = true;
    _tryNavigate();
  }

  Future<void> _tryNavigate() async {
    if (!mounted || _hasNavigated || !_isIntroDone || _sessionResult == null) {
      return;
    }

    _hasNavigated = true;
    setState(() => _isFadingOut = true);
    await Future.delayed(_fadeDuration);

    if (!mounted) return;

    if (_sessionResult!.isAuthenticated) {
      context.read<MenuBloc>().add(LoadCurrentUserEvent());
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _videoController.removeListener(_onVideoChanged);
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: AnimatedOpacity(
        opacity: _isFadingOut ? 0 : 1,
        duration: _fadeDuration,
        curve: Curves.easeOutCubic,
        child: Center(
          child: Container(
            width: 200,
            height: 200,
            color: AppColors.background,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(_logoImagePath, fit: BoxFit.cover),
                if (_isVideoReady)
                  AnimatedOpacity(
                    opacity: _showVideo ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    curve: Curves.easeOut,
                    child: Container(
                      color: Colors.white,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _videoController.value.size.width,
                              height: _videoController.value.size.height,
                              child: ColorFiltered(
                                colorFilter: ColorFilter.matrix(<double>[
                                  1.1, 0, 0, 0, 10,
                                  0, 1.1, 0, 0, 10,
                                  0, 0, 1.1, 0, 10,
                                  0, 0, 0, 1, 0,
                                ]),
                                child: VideoPlayer(_videoController),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SessionResult {
  const _SessionResult({required this.isAuthenticated});

  final bool isAuthenticated;
}
