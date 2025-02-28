import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/providers/camera_controller.dart';

class ImageInput extends ConsumerStatefulWidget {
  const ImageInput({super.key});

  @override
  ConsumerState<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends ConsumerState<ImageInput> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture =
        ref.read(cameraProvider.notifier).initCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = ref.watch(cameraProvider).controller;

    return Padding(
        padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  // camera controllers here
                ],
              ),
            ),
            Expanded(
                child: ClipRRect(
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.circular(20),
              child: FutureBuilder(
                  future: _initializeControllerFuture,
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      // If the Future is complete, display the preview.
                      return CameraPreview(controller!);
                    } else {
                      // Otherwise, display a loading indicator.
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ))
          ],
        ));
  }
}
