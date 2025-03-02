import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:moments/models/nominatim_address.dart';
import 'package:moments/providers/places_provider.dart';
import 'package:http/http.dart' as http;

Location location = Location();

class NewPlaceScreen extends ConsumerStatefulWidget {
  const NewPlaceScreen(this.image, {super.key});
  final File image;

  @override
  ConsumerState<NewPlaceScreen> createState() => _NewPlaceScreenState();
}

class _NewPlaceScreenState extends ConsumerState<NewPlaceScreen> {
  late PlacesNotifier _placesNotifier;

  bool _loading = false;
  bool _serviceEnabled = false;
  PermissionStatus _locationGranted = PermissionStatus.denied;
  late LocationData _location;
  NominatimAddress? _address;

  // 0 - set the name
  // 1 - set the location
  // 2 - finalize (show a little preview of how the info overlay would look)
  int _step = 0;
  final _formKey = GlobalKey<FormState>();
  String _savedName = '';

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    Future.microtask(() async {
      await _checkPermission();
      await _getLocation();
      await _getAddress();
    });
  }

  Future<void> _checkPermission() async {
    var servEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      servEnabled = await location.requestService();
      if (!_serviceEnabled) return;
    }

    setState(() {
      _serviceEnabled = servEnabled;
    });

    var permGranted = await location.hasPermission();
    if (permGranted == PermissionStatus.denied) {
      permGranted = await location.requestPermission();
      if (permGranted != PermissionStatus.granted) return;
    }

    setState(() {
      _locationGranted = permGranted;
    });
  }

  Future<void> _getLocation() async {
    setState(() {
      _loading = true;
    });
    try {
      var locData = await location.getLocation();
      setState(() {
        _location = locData;
      });
    } catch (err) {
      _checkPermission();
    }

    setState(() {
      _loading = false;
    });
  }

  Future<void> _getAddress() async {
    try {
      //
      final res =
          await http.get(Uri.https('nominatim.openstreetmap.org', 'reverse', {
        'lat': _location.latitude.toString(),
        'lon': _location.longitude.toString(),
        'format': 'jsonv2'
      }));

      debugPrint('res:\n$res');

      if (res.statusCode != 200) return;

      // decode the raw response as a map
      final rawData = jsonDecode(res.body) as Map<String, dynamic>;

      debugPrint('rawData:\n${rawData.toString()}');

      // See: https://nominatim.org/release-docs/develop/api/Reverse/#example-with-formatjsonv2
      // for the complete json data that we get.
      // For now, we only need the value under 'address' key, and the display_name and name
      NominatimAddress address = NominatimAddress.fromJSON(
          rawData['address'], rawData['display_name'], rawData['name']);

      setState(() {
        _address = address;
      });
    } catch (err) {
      debugPrint('ERROR:\n$err');
    }
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
      // if we're on step 1: check if the the user has put a valid caption
      _step += 1;
    });
  }

  void _handlePrev() {
    setState(() {
      if (_step == 0) {
        Navigator.of(context).pop();
        return;
      }

      _step -= 1;
    });
  }

  void handleAdd() {
    _placesNotifier.add(_savedName, widget.image, DateTime.now(), _address!);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    _placesNotifier = ref.read(placesProvider.notifier);

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
              Expanded(
                  child: Column(
                children: [
                  Expanded(
                    child: SizedBox.expand(),
                  ),
                  Expanded(
                    flex: 0,
                    child: Container(
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
                                            _savedName = value ??= '';
                                          });
                                        },
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.length > 50) {
                                            return 'Please enter a valid place name';
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
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          (_loading == true ||
                                                  _location.latitude == null)
                                              ? CircularProgressIndicator()
                                              : SizedBox(
                                                  height: 250,
                                                  width: double.infinity,
                                                  child: ClipRRect(
                                                    clipBehavior: Clip.hardEdge,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    child: IgnorePointer(
                                                      child: FlutterMap(
                                                        options: MapOptions(
                                                            initialCenter: LatLng(
                                                                _location
                                                                        .latitude ??
                                                                    0,
                                                                _location
                                                                        .longitude ??
                                                                    0)),
                                                        children: [
                                                          TileLayer(
                                                            urlTemplate:
                                                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                                          ),
                                                          MarkerLayer(markers: [
                                                            Marker(
                                                                point: LatLng(
                                                                    _location
                                                                            .latitude ??
                                                                        0,
                                                                    _location
                                                                            .longitude ??
                                                                        0),
                                                                child: Icon(
                                                                  Icons
                                                                      .location_on,
                                                                  color: Colors
                                                                      .red,
                                                                ))
                                                          ])
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                          SizedBox(height: 10),
                                          if (_address != null)
                                            Text(
                                              _address!.displayName.isEmpty
                                                  ? _address!.name
                                                  : _address!.displayName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium!
                                                  .copyWith(
                                                      color: Colors.white),
                                            )
                                        ],
                                      )
                                    // Confirm screen
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Caption',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(_savedName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            'Address',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelMedium!
                                                .copyWith(color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                              _address!.displayName.isEmpty
                                                  ? _address!.name
                                                  : _address!.displayName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white))
                                        ],
                                      ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
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
                                    onPressed: _handleNext,
                                    child: Text(_step == 2 ? 'Save' : 'Next'))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
          // body: SingleChildScrollView(
          //   child: Padding(
          //     padding:
          //         EdgeInsets.only(top: 40, bottom: 20, right: 20, left: 20),
          //     child: Column(
          //       children: [
          //         Hero(
          //             tag: 'image-preview',
          //             child: ClipRRect(
          //               borderRadius: BorderRadius.circular(20),
          //               clipBehavior: Clip.hardEdge,
          //               child: Image.file(widget.image,
          //                   height: 500,
          //                   width: double.infinity,
          //                   fit: BoxFit.fill),
          //             )),
          //         SizedBox(height: 10),
          //         TextFormField(
          //           controller: _nameController,
          //           decoration: InputDecoration(label: Text('Place')),
          //           validator: (value) {
          //             if (value == null || value.isEmpty || value.length > 50) {
          //               return 'Please enter a valid place name';
          //             }

          //             if (value.trim().length < 2 || value.length > 50) {
          //               return 'Must be between 2 to 50 characters.';
          //             }

          //             return null;
          //           },
          //         ),
          //         SizedBox(
          //           height: 20,
          //         ),
          //         ElevatedButton(onPressed: handleAdd, child: Text('Submit'))
          //       ],
          //     ),
          //   ),
          // ),
        ));
  }
}
