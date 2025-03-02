import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/data/dummy_places.dart';
import 'package:moments/providers/camera_provider.dart';
import 'package:moments/providers/page_provider.dart';
import 'package:moments/providers/places_provider.dart';
import 'package:moments/screens/new_place_screen.dart';
import 'package:moments/widgets/camera_viewfinder.dart';
import 'package:moments/widgets/place_item.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    final favoritePlaces = ref.watch(placesProvider);
    List<Widget> slides = [
      ...(favoritePlaces.map((place) => PlaceItem(place: place)).toList()),
      // ...(dummyPlaces
      //     .map((place) => PlaceItem(
      //           dummyPlace: place,
      //         ))
      //     .toList()),
      CameraViewFinder()
    ];

    void handleCamPress() {
      // if we're on the slides then set the current page to the last
      if (_currentPageIndex < slides.length - 1) {
        _pageViewController.animateToPage(slides.length - 1,
            duration: Durations.long2, curve: Curves.decelerate);
        return;
      }

      // otherwise trigger the camera
      ref.read(cameraProvider.notifier).takePicture().then((image) {
        if (image == null) return;
        var pickedImage = File(image.path);
        Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => NewPlaceScreen(pickedImage)));
      });
    }

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageViewController,
              onPageChanged: (page) {
                setState(() {
                  debugPrint('current page: $page');
                  _currentPageIndex = page;
                });
              },
              children: slides,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_currentPageIndex < slides.length - 1 && slides.isNotEmpty)
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: SmoothPageIndicator(
                              controller: _pageViewController,
                              count: slides.length),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                ElevatedButton(
                  onPressed: handleCamPress,
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                  ),
                  child: Icon(
                    Icons.photo_camera,
                    size: 28,
                  ),
                ),
                if (_currentPageIndex == slides.length - 1)
                  IconButton.outlined(
                      onPressed: () {
                        ref
                            .read(cameraProvider.notifier)
                            .selectFromGallery()
                            .then((image) {
                          if (image == null) return;
                          var pickedImage = File(image.path);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx) => NewPlaceScreen(pickedImage)));
                        });
                      },
                      icon: Icon(Icons.image))
              ],
            ),
          )
        ],
      ),
    );
  }
}
