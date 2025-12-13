import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/shared/helpers/camera_helper.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  bool _isInitialized = false;
  bool _isRecording = false;
  bool _isPhoto = true; // true: chụp ảnh, false: quay video
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      print('Starting camera initialization...');

      // Request permissions first
      final hasPermissions = await CameraHelper.requestCameraPermissions();
      print('Permissions granted: $hasPermissions');

      if (!hasPermissions) {
        print('Permissions denied, closing camera');
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      _cameras = await CameraHelper.getAvailableCameras();
      print('Available cameras: ${_cameras.length}');

      if (_cameras.isNotEmpty) {
        await _setupCamera(_selectedCameraIndex);
      } else {
        print('No cameras available');
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      if (mounted) {
        // Show error dialog instead of just closing
        showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Lỗi Camera'),
            content: Text('Không thể khởi tạo camera: $e'),
            actions: [
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    }
  }

  Future<void> _setupCamera(int cameraIndex) async {
    try {
      print('Setting up camera $cameraIndex of ${_cameras.length}');

      if (_controller != null) {
        await _controller!.dispose();
        _controller = null;
      }

      _controller = CameraController(
        _cameras[cameraIndex],
        ResolutionPreset.high,
        enableAudio: true,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      print('Initializing camera controller...');
      await _controller!.initialize();

      if (!mounted) return;

      print('Camera initialized successfully');
      print('Camera aspect ratio: ${_controller!.value.aspectRatio}');
      print('Camera description: ${_cameras[cameraIndex].lensDirection}');

      try {
        await _controller!.setFlashMode(_flashMode);
      } catch (e) {
        print('Error setting flash mode: $e');
      }

      setState(() {
        _isInitialized = true;
      });
      print('Camera state updated, isInitialized: $_isInitialized');
    } catch (e) {
      print('Error setting up camera: $e');
      print('Stack trace: ${StackTrace.current}');
      if (mounted) {
        setState(() {
          _isInitialized = false;
        });
        
        // Show error to user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khởi tạo camera: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length > 1) {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
      await _setupCamera(_selectedCameraIndex);
    }
  }

  Future<void> _toggleFlash() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        switch (_flashMode) {
          case FlashMode.off:
            _flashMode = FlashMode.auto;
          case FlashMode.auto:
            _flashMode = FlashMode.always;
          case FlashMode.always:
            _flashMode = FlashMode.torch;
          case FlashMode.torch:
            _flashMode = FlashMode.off;
        }
        await _controller!.setFlashMode(_flashMode);
        setState(() {});
      } catch (e) {
        print('Error toggling flash: $e');
      }
    }
  }

  Future<void> _capturePhoto() async {
    if (_controller != null && _controller!.value.isInitialized) {
      try {
        final XFile photo = await _controller!.takePicture();
        if (mounted) {
          Navigator.pop(context, {'type': 'photo', 'path': photo.path});
        }
      } catch (e) {
        print('Error capturing photo: $e');
      }
    }
  }

  Future<void> _startRecording() async {
    if (_controller != null &&
        _controller!.value.isInitialized &&
        !_isRecording) {
      try {
        await _controller!.startVideoRecording();
        setState(() {
          _isRecording = true;
        });
      } catch (e) {
        print('Error starting video recording: $e');
      }
    }
  }

  Future<void> _stopRecording() async {
    if (_controller != null && _isRecording) {
      try {
        final XFile video = await _controller!.stopVideoRecording();
        setState(() {
          _isRecording = false;
        });
        if (mounted) {
          Navigator.pop(context, {'type': 'video', 'path': video.path});
        }
      } catch (e) {
        print('Error stopping video recording: $e');
      }
    }
  }

  IconData _getFlashIcon() {
    switch (_flashMode) {
      case FlashMode.off:
        return CupertinoIcons.bolt_slash;
      case FlashMode.auto:
        return CupertinoIcons.bolt_badge_a;
      case FlashMode.always:
        return CupertinoIcons.bolt;
      case FlashMode.torch:
        return CupertinoIcons.bolt_fill;
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _controller == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CupertinoActivityIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera preview full screen
          if (_controller!.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),
            )
          else
            Container(
              color: Colors.black,
              child: const Center(
                child: CupertinoActivityIndicator(
                  color: Colors.white,
                ),
              ),
            ),

          // Top controls
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),

                  // Flash button
                  GestureDetector(
                    onTap: _toggleFlash,
                    child: Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getFlashIcon(),
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                ),
              ),
              child: Column(
                children: [
                  // Mode selector (Photo/Video)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (!_isRecording) {
                            setState(() {
                              _isPhoto = true;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: _isPhoto ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Ảnh',
                            style: TextStyle(
                              color: _isPhoto ? Colors.black : Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 20.w),

                      GestureDetector(
                        onTap: () {
                          if (!_isRecording) {
                            setState(() {
                              _isPhoto = false;
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 8.h,
                          ),
                          decoration: BoxDecoration(
                            color: !_isPhoto
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            'Video',
                            style: TextStyle(
                              color: !_isPhoto ? Colors.black : Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 30.h),

                  // Camera controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Gallery button (placeholder)
                      Container(
                        width: 50.w,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(
                          CupertinoIcons.photo,
                          color: Colors.white,
                          size: 24.sp,
                        ),
                      ),

                      // Capture/Record button
                      GestureDetector(
                        onTap: _isPhoto
                            ? _capturePhoto
                            : (_isRecording ? _stopRecording : _startRecording),
                        child: Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            color: _isRecording ? Colors.red : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: _isRecording
                              ? Icon(
                                  CupertinoIcons.stop_fill,
                                  color: Colors.white,
                                  size: 32.sp,
                                )
                              : (_isPhoto
                                    ? null
                                    : Icon(
                                        CupertinoIcons.circle_fill,
                                        color: Colors.red,
                                        size: 24.sp,
                                      )),
                        ),
                      ),

                      // Switch camera button
                      GestureDetector(
                        onTap: _cameras.length > 1 ? _switchCamera : null,
                        child: Container(
                          width: 50.w,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            CupertinoIcons.camera_rotate,
                            color: _cameras.length > 1
                                ? Colors.white
                                : Colors.grey,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Recording indicator
          if (_isRecording)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: 20.h),
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.circle_fill,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Đang quay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
