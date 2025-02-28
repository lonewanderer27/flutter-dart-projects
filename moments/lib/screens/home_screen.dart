import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/data/dummy_places.dart';
import 'package:moments/providers/camera_provider.dart';
import 'package:moments/screens/new_place_screen.dart';
import 'package:moments/widgets/camera_viewfinder.dart';
import 'package:moments/widgets/place_item.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late PageController _pageViewController;
  late TabController _tabController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              children: [
                ...(dummyPlaces
                    .map((place) => PlaceItem(
                          dummyPlace: place,
                        ))
                    .toList()),
                CameraViewFinder()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox.shrink(
                    child: Row(
                  children: [
                    // TODO: Page indicator that disappears when we're on the final page
                    SizedBox(
                      width: 20,
                    ),
                  ],
                )),
                ElevatedButton(
                  onPressed: () {
                    ref
                        .read(cameraProvider.notifier)
                        .takePicture()
                        .then((image) {
                      if (image == null) return;
                      var pickedImage = File(image.path);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => NewPlaceScreen(pickedImage)));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: 30,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
