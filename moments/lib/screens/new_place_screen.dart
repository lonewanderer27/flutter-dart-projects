import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:moments/providers/location_provider.dart';
import 'package:moments/providers/places_provider.dart';

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen(this.image, this.pageController, {super.key});
  final File image;
  final PageController pageController;

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  late LocationState _loc;
  late LocationNotifier _locN;
  late PlacesNotifier _places;

  // 0 - set the name
  // 1 - set the location
  // 2 - finalize (show a little preview of how the info overlay would look)
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    // Fetch location data when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loc = ref.watch(locationProvider);
      _locN = ref.read(locationProvider.notifier);

      if (_loc.locationData != null) return;
      _locN.refresh();
    });
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() == false) {
      return;
    }

    _formKey.currentState!.save();

    if (_step == 2) {
      handleAdd();
      return;
    }

    setState(() {
      _step += 1;
    });
  }

  void _handlePrev() {
    if (_step == 0) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _step -= 1;
    });
  }

  void handleAdd() {
    if (_loc.address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location not available. Please try again.')),
      );
      return;
    }

    _places.add(_savedName, widget.image, DateTime.now(), _loc.address!);

    // we navigate to the very first page
    // so the user can see the newly added fave place
    widget.pageController.jumpTo(0);

    Navigator.of(context).pop();
  }

  Widget _buildLocationContent() {
    if (_loc.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            Text(
              'Error fetching location: ${_loc.error}',
              style: TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => _locN.refresh(),
              child: Text('Retry', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    if (_loc.loading == true) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text('Loading location...', style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    if (_loc.locationData?.latitude == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off, color: Colors.white, size: 48),
            const SizedBox(height: 16),
            const Text(
              'Location data unavailable',
              style: TextStyle(color: Colors.white),
            ),
            TextButton(
              onPressed: () => _locN.refresh(),
              child: Text('Try Again', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: ClipRRect(
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.circular(10),
            child: IgnorePointer(
              child: FlutterMap(
                options: MapOptions(
                    initialCenter: LatLng(
                  _loc.locationData!.latitude!,
                  _loc.locationData!.longitude!,
                )),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(markers: [
                    Marker(
                        point: LatLng(
                          _loc.locationData!.latitude!,
                          _loc.locationData!.longitude!,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.red,
                        ))
                  ])
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        if (_loc.address != null)
          Text(
            _loc.address!.displayName.isNotEmpty
                ? _loc.address!.displayName
                : _loc.address!.name,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white),
          )
      ],
    );
  }

  Widget _buildConfirmScreen() {
    if (_loc.address == null) {
      return Column(
        children: [
          Text(
            'Location not available',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () => setState(() => _step = 1),
            child: Text('Go back and retry',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Caption',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(_savedName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white)),
        SizedBox(height: 20),
        Text(
          'Address',
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .copyWith(color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
            _loc.address!.displayName.isNotEmpty
                ? _loc.address!.displayName
                : _loc.address!.name,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.white))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _loc = ref.watch(locationProvider);
    _locN = ref.read(locationProvider.notifier);
    _places = ref.read(placesProvider.notifier);

    return Form(
        key: _formKey,
        child: Scaffold(
            backgroundColor: Colors.black54,
            body: Stack(
              children: [
                Hero(
                    tag: 'image-preview',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      clipBehavior: Clip.hardEdge,
                      child: Image.file(
                        widget.image,
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )),
                Column(
                  children: [
                    Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: _step == 0
                                // Caption screen
                                ? Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      TextFormField(
                                        style: TextStyle(color: Colors.white),
                                        initialValue: _savedName,
                                        decoration: InputDecoration(
                                            label: Text(
                                          'Caption',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                        onSaved: (value) {
                                          setState(() {
                                            _savedName = value ?? '';
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter a caption';
                                          }

                                          if (value.trim().length < 2 ||
                                              value.length > 50) {
                                            return 'Must be between 2 to 50 characters.';
                                          }

                                          return null;
                                        },
                                      ),
                                    ],
                                  )
                                : _step == 1
                                    // Location screen
                                    ? _buildLocationContent()
                                    // Confirm screen
                                    : _buildConfirmScreen(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white),
                                    onPressed: _handlePrev,
                                    child:
                                        Text(_step == 0 ? 'Cancel' : 'Back')),
                                ElevatedButton(
                                    onPressed: _step == 2 &&
                                            _loc.loading == false &&
                                            _loc.address == null
                                        ? null
                                        : _handleNext,
                                    child: Text(_step == 2 ? 'Save' : 'Next'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            )));
  }
}
