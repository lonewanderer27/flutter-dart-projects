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
        CameraController(cameras.first, ResolutionPreset.high);

    var initializeControllerFuture = camController.initialize();
    state = state.copyWith(controller: camController, hasInitialized: true);
    return initializeControllerFuture;
  }

  Future<XFile?> takePicture() async {
    XFile? image;

    if (state.controller != null && state.hasInitialized) {
      image = await state.controller!.takePicture();
    }

    return image;
  }
}

/// Riverpod Provider for the CameraNotifier
final cameraProvider =
    StateNotifierProvider<CameraNotifier, CameraState>((ref) {
  return CameraNotifier();
});
