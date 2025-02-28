import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/providers/camera_provider.dart';

class CameraViewFinder extends ConsumerStatefulWidget {
  const CameraViewFinder({super.key});

  @override
  ConsumerState<CameraViewFinder> createState() => _CameraViewFinderState();
}

class _CameraViewFinderState extends ConsumerState<CameraViewFinder> {
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture =
        ref.read(cameraProvider.notifier).initCamera();
  }

  @override
  void dispose() {
    if (mounted) {
      ref.read(cameraProvider).controller?.dispose();
    }
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
                      return Hero(
                          tag: 'image-preview',
                          child: CameraPreview(controller!));
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
