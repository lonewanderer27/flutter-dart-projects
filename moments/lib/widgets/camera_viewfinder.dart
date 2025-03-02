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
  // Remove 'late' and initialize as null
  CameraController? _cameraController;
  Future<void>? _initializeControllerFuture;

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      final camController = CameraController(
          cameras.first, ResolutionPreset.high,
          enableAudio: false);

      // Store the controller
      setState(() {
        _cameraController = camController;
      });

      // Set in provider so we can access its methods from other widgets
      ref.read(cameraProvider.notifier).setController(camController);

      // Initialize and store the future
      final future = camController.initialize();
      setState(() {
        _initializeControllerFuture = future;
      });
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    // Only dispose if controller exists
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 40, bottom: 20, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // camera controllers here
                  Text('New Memory',
                      style: TextStyle(
                          fontSize: 25,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  Text('Today',
                      style: TextStyle(fontSize: 15, color: Colors.white60))
                ],
              ),
            ),
            Expanded(
                child: ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    borderRadius: BorderRadius.circular(20),
                    child: Hero(
                      tag: 'image-preview',
                      child: FutureBuilder(
                          future: _initializeControllerFuture,
                          builder: (ctx, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              // If the Future is complete, display the preview.
                              return CameraPreview(_cameraController!);
                            } else {
                              // Otherwise, display a loading indicator.
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                    )))
          ],
        ));
  }
}
