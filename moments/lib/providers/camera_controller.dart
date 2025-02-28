import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CameraState {
  final CameraController? controller;
  final bool hasInitialized;

  CameraState({this.controller, this.hasInitialized = false});

  CameraState copyWith({CameraController? controller, bool? hasInitialized}) {
    return CameraState(
      controller: controller ?? this.controller,
      hasInitialized: hasInitialized ?? this.hasInitialized,
    );
  }
}

class CameraNotifier extends StateNotifier<CameraState> {
  CameraNotifier() : super(CameraState());

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    final camController =
        CameraController(cameras.first, ResolutionPreset.medium);

    var _initializeControllerFuture = camController.initialize();
    state = state.copyWith(controller: camController, hasInitialized: true);
    return _initializeControllerFuture;
  }

  Future<void> takePicture() async {
    if (state.controller != null && state.hasInitialized) {
      final image = state.controller!.takePicture();
      inspect(image);
    }
  }
}

/// Riverpod Provider for the CameraNotifier
final cameraProvider =
    StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});
