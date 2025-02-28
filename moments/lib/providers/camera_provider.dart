import 'package:camera/camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class CameraNotifier extends StateNotifier<CameraController?> {
  CameraNotifier() : super(null);

  // Future<void> initCamera() async {
  //   await disposeCamera();

  //   final cameras = await availableCameras();
  //   final camController =
  //       CameraController(cameras.first, ResolutionPreset.high);

  //   var initializeControllerFuture = camController.initialize();
  //   state = state.copyWith(controller: camController, hasInitialized: true);
  //   return initializeControllerFuture;
  // }

  void setController(CameraController controller) async {
    state = controller;
  }

  Future<void> disposeCamera() async {
    if (state != null) {
      await state!.dispose();
    }
  }

  Future<XFile?> selectFromGallery() async {
    final imagePicker = ImagePicker();
    return await imagePicker.pickMedia();
  }

  Future<XFile?> takePicture() async {
    XFile? image;

    if (state != null) {
      image = await state!.takePicture();
    }

    return image;
  }
}

/// Riverpod Provider for the CameraNotifier
final cameraProvider =
    StateNotifierProvider<CameraNotifier, CameraController?>((ref) {
  return CameraNotifier();
});
