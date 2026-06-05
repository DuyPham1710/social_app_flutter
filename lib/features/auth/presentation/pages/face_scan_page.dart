import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:social_app_fe/core/constants/app_colors.dart';
import 'package:social_app_fe/core/utils/responsive_helper.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_app_fe/features/auth/presentation/bloc/auth_state.dart';
import 'package:social_app_fe/features/auth/presentation/widgets/auth_responsive_wrapper.dart';
import 'package:social_app_fe/l10n/l10n.dart';
import 'package:social_app_fe/shared/helpers/show_dialog_success.dart';
import 'package:social_app_fe/shared/helpers/show_error_snackBar.dart';

enum FacePose { center, up, down, left, right }

class FaceScanPage extends StatefulWidget {
  const FaceScanPage({super.key});

  @override
  State<FaceScanPage> createState() => _FaceScanPageState();
}

class _FaceScanPageState extends State<FaceScanPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;

  FaceDetector? _faceDetector;

  bool _isDetecting = false;
  bool _isCapturing = false;
  bool _isFinished = false;
  bool _isTooDark = false;
  bool _isUploading = false;

  int _currentPoseIndex = 0;
  final List<XFile> _capturedImages = [];
  String _userId = '';
  bool _isPrivacyTab = false;

  final List<FacePose> _poses = [
    FacePose.center,
    FacePose.up,
    FacePose.down,
    FacePose.left,
    FacePose.right,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!ResponsiveHelper.isMobile(context)) {
        _showMobileOnlyDialog();
      } else {
        final args =
            ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
        _userId = args?['userId'] as String? ?? '';
        _isPrivacyTab = args?['isPrivacyTab'] as bool? ?? false;
        debugPrint('[FaceScan] userId: $_userId');
        debugPrint('[FaceScan] isPrivacyTab: $_isPrivacyTab');
        _initCamera();
      }
    });
  }

  void _showMobileOnlyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Dialog(
              backgroundColor: AppColors.secondBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      CupertinoIcons.device_phone_portrait,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Tính năng không hỗ trợ",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Tính năng quét khuôn mặt chỉ hỗ trợ thực hiện trên thiết bị điện thoại di động.",
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                          Navigator.of(this.context).pop(); // Go back
                        },
                        child: const Text(
                          "Đồng ý",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _initCamera() async {
    try {
      _faceDetector = FaceDetector(
        options: FaceDetectorOptions(
          enableContours: false,
          enableClassification: false,
          enableTracking: true,
        ),
      );
      final cameras = await availableCameras();
      if (cameras.isEmpty) return;

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
      );

      await _cameraController!.initialize();
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
        _cameraController!.startImageStream(_processImage);
      }
    } catch (e) {
      debugPrint("Lỗi khởi tạo camera: $e");
    }
  }

  String _instructionTitle(BuildContext context) {
    if (_isUploading) return context.l10n.faceScanProcessing;
    if (_isFinished) return context.l10n.faceScanCompleted;
    if (_isCapturing) return context.l10n.faceScanHoldStill;
    if (_isTooDark) return context.l10n.faceScanTooDarkTitle;
    return context.l10n.faceScanStep(_currentPoseIndex + 1);
  }

  String _instructionText(BuildContext context) {
    if (_isUploading) return context.l10n.faceScanUploading;
    if (_isFinished) return context.l10n.faceScanStoredSafely;
    if (_isTooDark) return context.l10n.faceScanTooDarkMessage;

    switch (_poses[_currentPoseIndex]) {
      case FacePose.center:
        return context.l10n.faceScanLookStraight;
      case FacePose.up:
        return context.l10n.faceScanLookUp;
      case FacePose.down:
        return context.l10n.faceScanLookDown;
      case FacePose.left:
        return context.l10n.faceScanLookLeft;
      case FacePose.right:
        return context.l10n.faceScanLookRight;
    }
  }

  IconData get _poseIcon {
    if (_isFinished) return CupertinoIcons.checkmark_seal_fill;
    if (_isTooDark) return CupertinoIcons.lightbulb_slash;
    switch (_poses[_currentPoseIndex]) {
      case FacePose.center:
        return CupertinoIcons.person_crop_circle;
      case FacePose.up:
        return CupertinoIcons.arrow_up_circle;
      case FacePose.down:
        return CupertinoIcons.arrow_down_circle;
      case FacePose.left:
        return CupertinoIcons.arrow_left_circle;
      case FacePose.right:
        return CupertinoIcons.arrow_right_circle;
    }
  }

  Future<void> _processImage(CameraImage image) async {
    if (_isDetecting || _isCapturing || _isFinished) return;
    _isDetecting = true;

    try {
      // Kiểm tra độ sáng của khung hình trước
      final isBright = _isImageBrightEnough(image);
      if (_isTooDark != !isBright) {
        setState(() {
          _isTooDark = !isBright;
        });
      }

      // Nếu đủ sáng mới tiến hành nhận diện AI
      if (isBright && _faceDetector != null) {
        final inputImage = _inputImageFromCameraImage(image);
        if (inputImage != null) {
          final faces = await _faceDetector!.processImage(inputImage);

          // Cần đúng 1 khuôn mặt trong khung hình
          if (faces.length == 1) {
            final face = faces.first;

            // Kiểm tra xem khuôn mặt đã đúng góc độ yêu cầu chưa
            if (_checkPose(face, _poses[_currentPoseIndex])) {
              await _captureCurrentPose();
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Lỗi nhận diện: $e");
    }

    if (mounted) {
      _isDetecting = false;
    }
  }

  bool _isImageBrightEnough(CameraImage image) {
    if (image.planes.isEmpty) return true;

    // Lấy trung bình cộng độ sáng của các pixel trong ảnh.
    // Lấy mẫu (sample) mỗi 10 pixel để tối ưu tốc độ xử lý.
    const int step = 10;
    int totalLuminance = 0;
    int count = 0;

    if (Platform.isAndroid) {
      // Trên Android (NV21), plane 0 chứa dữ liệu Y (Luminance - Độ sáng: 0 đến 255)
      final yPlane = image.planes[0].bytes;
      for (int i = 0; i < yPlane.length; i += step) {
        totalLuminance += yPlane[i];
        count++;
      }
    } else {
      // Trên iOS (BGRA8888), tính trung bình màu RGB
      final bytes = image.planes[0].bytes;
      for (int i = 0; i < bytes.length; i += step * 4) {
        if (i + 2 < bytes.length) {
          int b = bytes[i];
          int g = bytes[i + 1];
          int r = bytes[i + 2];
          totalLuminance += (r + g + b) ~/ 3;
          count++;
        }
      }
    }

    if (count == 0) return true;
    double avgLuminance = totalLuminance / count;

    // Ngưỡng độ sáng. Dưới 80 thường là môi trường khá tối. Có thể tuỳ chỉnh.
    return avgLuminance > 80.0;
  }

  bool _checkPose(Face face, FacePose pose) {
    final double? rotY = face.headEulerAngleY; // Trái phải
    final double? rotX = face.headEulerAngleX; // Lên xuống

    if (rotY == null || rotX == null) return false;

    // Các hằng số góc để kiểm tra độ nghiêng
    const double angleThreshold =
        15.0; // Góc nhận diện (nhỏ hơn để dễ nhận diện hơn)
    const double tolerance = 15.0; // Độ sai số cho phép ở trục không yêu cầu

    switch (pose) {
      case FacePose.center:
        return rotY.abs() <= tolerance && rotX.abs() <= tolerance;
      case FacePose.up:
        return rotX >= angleThreshold && rotY.abs() <= tolerance;
      case FacePose.down:
        return rotX <= -angleThreshold && rotY.abs() <= tolerance;
      case FacePose.left:
        // rotY > 0 thường là quay sang trái của màn hình
        return rotY >= (angleThreshold + 5.0) && rotX.abs() <= tolerance;
      case FacePose.right:
        return rotY <= (-angleThreshold - 5.0) && rotX.abs() <= tolerance;
    }
  }

  Future<void> _captureCurrentPose() async {
    setState(() {
      _isCapturing = true;
    });

    try {
      // Dừng stream để takePicture được gọi an toàn
      await _cameraController!.stopImageStream();

      final XFile file = await _cameraController!.takePicture();
      _capturedImages.add(file);

      if (_currentPoseIndex < 4) {
        // Chuyển sang bước tiếp theo
        setState(() {
          _currentPoseIndex++;
        });

        // Delay 1 chút để user nhận biết đã chụp xong & chuẩn bị đổi tư thế
        await Future.delayed(const Duration(milliseconds: 1500));

        if (mounted && !_isFinished) {
          setState(() {
            _isCapturing = false;
          });
          _cameraController!.startImageStream(_processImage);
        }
      } else {
        // Đã hoàn thành 5 tấm
        setState(() {
          _isFinished = true;
          _isCapturing = false;
        });

        // Chờ thêm 1 giây rồi gửi lên server
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            _submitFaceRegistration();
          }
        });
      }
    } catch (e) {
      debugPrint("Lỗi khi chụp: $e");
      setState(() {
        _isCapturing = false;
      });
      if (mounted && !_isFinished) {
        _cameraController?.startImageStream(_processImage);
      }
    }
  }

  /// Convert ảnh đã chụp thành base64 và gửi lên server qua AuthBloc
  Future<void> _submitFaceRegistration() async {
    if (_userId.isEmpty) {
      debugPrint('[FaceScan] userId is empty, cannot submit');
      _showErrorAndReset(context.l10n.faceScanMissingAccount);
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Convert tất cả ảnh sang base64
      final List<String> base64Images = [];
      for (final xfile in _capturedImages) {
        final bytes = await File(xfile.path).readAsBytes();
        base64Images.add(base64Encode(bytes));
      }

      debugPrint(
        '[FaceScan] Converted ${base64Images.length} images to base64',
      );

      // Dispatch event qua BLoC
      if (mounted) {
        context.read<AuthBloc>().add(
          SubmitFaceRegistrationEvent(
            userId: _userId,
            base64Images: base64Images,
          ),
        );
      }
    } catch (e) {
      debugPrint('[FaceScan] Error converting images: $e');
      _showErrorAndReset(context.l10n.faceScanProcessImageFailed);
    }
  }

  void _showErrorAndReset(String message) {
    if (!mounted) return;
    showErrorSnackBar(context, message);

    // Đóng trang face-scan khi có lỗi
    Navigator.of(context).pop();
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_cameraController == null) return null;
    final camera = _cameraController!.description;
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation = 0;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = Platform.isAndroid
        ? InputImageFormat.nv21
        : InputImageFormat.bgra8888;

    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final inputImageData = InputImageMetadata(
      size: imageSize,
      rotation: rotation,
      format: format,
      bytesPerRow: image.planes[0].bytesPerRow,
    );

    return InputImage.fromBytes(bytes: bytes, metadata: inputImageData);
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    if (_faceDetector != null) {
      _faceDetector!.close().catchError((e) {
        debugPrint("Lỗi đóng face detector: $e");
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is FaceRegistrationSuccess) {
          showDialogSuccess(
            context,
            state.message,
            isNavigateLogin: !_isPrivacyTab,
          ).then((_) {
            if (_isPrivacyTab && mounted) {
              // Pop FaceScanPage and FaceRegistrationPage to go back to PrivacySecurityPage
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          });
        } else if (state is FaceRegistrationError) {
          _showErrorAndReset(state.message);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: AuthResponsiveWrapper(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 16.0,
                  ),

                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: Icon(
                            CupertinoIcons.back,
                            color: Colors.white,
                            size: 24.rsp(context),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Text(
                          context.l10n.faceScanTitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.rsp(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 40.rs(context)),
                    ],
                  ),
                ),

                SizedBox(height: 40.rsh(context)),

                // Tiến trình (Progress dots)
                if (!_isFinished)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 6.rs(context)),
                        width: index == _currentPoseIndex
                            ? 24.rs(context)
                            : 12.rs(context),
                        height: 12.rs(context),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.rs(context)),
                          color: index <= _currentPoseIndex
                              ? AppColors.primary
                              : Colors.grey[800],
                        ),
                      );
                    }),
                  ),

                SizedBox(height: 40.rsh(context)),

                // Camera View
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Camera Preview inside a circle
                      Container(
                        width: 300.rs(context),
                        height: 300.rs(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _isFinished
                                ? Colors.green
                                : (_isCapturing
                                      ? Colors.white
                                      : AppColors.primary),
                            width: _isCapturing ? 6.rs(context) : 4.rs(context),
                          ),
                        ),
                        child: ClipOval(
                          child: _isCameraInitialized
                              ? Builder(
                                  builder: (context) {
                                    // Camera ratio thường trả về landscape (VD: 16/9 = 1.77) trên Android
                                    // Nhưng màn hình đang dọc, nên ảnh thực tế là 9/16. Ta phải nghịch đảo.
                                    double ratio =
                                        _cameraController!.value.aspectRatio;
                                    if (ratio > 1.0) {
                                      ratio = 1.0 / ratio;
                                    }

                                    return SizedBox(
                                      width: 300.rs(context),
                                      height: 300.rs(context),
                                      child: FittedBox(
                                        fit: BoxFit.cover,
                                        child: SizedBox(
                                          width: 1000,
                                          height: 1000 / ratio,
                                          child: CameraPreview(
                                            _cameraController!,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Container(
                                  color: Colors.grey[900],
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      // Flash effect when capturing
                      if (_isCapturing && !_isFinished)
                        Container(
                          width: 300.rs(context),
                          height: 300.rs(context),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),

                      // Success overlay
                      if (_isFinished)
                        Container(
                          width: 300.rs(context),
                          height: 300.rs(context),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green.withOpacity(0.6),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.checkmark_alt,
                              color: Colors.white,
                              size: 100.rs(context),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Instructions
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.rs(context),
                    vertical: 40.rsh(context),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _poseIcon,
                        color: _isFinished ? Colors.green : AppColors.primary,
                        size: 40.rsp(context),
                      ),
                      SizedBox(height: 16.rsh(context)),
                      Text(
                        _instructionTitle(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: _isFinished ? Colors.green : Colors.white,
                          fontSize: 20.rsp(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.rsh(context)),
                      Text(
                        _instructionText(context),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16.rsp(context),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.rsh(context)),
              ],
            ),
          ),
        ),
      ), // Close BlocListener child
    );
  }
}
