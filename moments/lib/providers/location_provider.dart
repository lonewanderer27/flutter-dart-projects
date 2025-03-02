import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:moments/models/nominatim_address.dart';
import 'package:http/http.dart' as http;

class LocationState {
  final String? error;
  final bool? loading;
  final bool? serviceEnabled;
  final PermissionStatus? permissionStatus;
  final Location? location;
  final LocationData? locationData;
  final NominatimAddress? address;

  LocationState({
    this.error,
    this.loading = false,
    this.serviceEnabled = false,
    this.permissionStatus,
    this.location,
    this.locationData,
    this.address,
  });

  LocationState copyWith(
      {String? error,
      bool? loading,
      bool? serviceEnabled,
      PermissionStatus? permissionStatus,
      Location? location,
      LocationData? locationData,
      NominatimAddress? address}) {
    return LocationState(
        loading: loading ?? this.loading,
        serviceEnabled: serviceEnabled ?? this.serviceEnabled,
        permissionStatus: permissionStatus ?? this.permissionStatus,
        location: location ?? this.location,
        locationData: locationData ?? this.locationData,
        address: address ?? this.address);
  }
}

class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState(location: Location()));

  Future<void> refresh() async {
    await checkPermission();
    if (state.permissionStatus == PermissionStatus.granted) {
      await getLocation();
      if (state.locationData != null) {
        await getAddress();
      }
    }
  }

  Future<bool> checkPermission() async {
    _startLoading();

    var servEnabled = await state.location?.serviceEnabled();
    if (servEnabled == null || !servEnabled) {
      servEnabled = await state.location?.requestService();
      if (servEnabled == null || !servEnabled) {
        _finishLoading();
        return false;
      }
    }

    state = state.copyWith(serviceEnabled: servEnabled);

    var permGranted = await state.location?.hasPermission();
    if (permGranted == PermissionStatus.denied) {
      permGranted = await state.location?.requestPermission();
      if (permGranted != PermissionStatus.granted) {
        _finishLoading();
        return false;
      }
    }

    state = state.copyWith(permissionStatus: permGranted, loading: false);
    return true;
  }

  Future<LocationData?> getLocation() async {
    _startLoading();

    try {
      if (state.location == null) {
        state = state.copyWith(error: "Location service not initialized");
        _finishLoading();
        return null;
      }

      var locData = await state.location!.getLocation();
      state = state.copyWith(locationData: locData);
      _finishLoading();
      return locData;
    } catch (err) {
      state = state.copyWith(error: err.toString());
      _finishLoading();
      return null;
    }
  }

  Future<NominatimAddress?> getAddress() async {
    _startLoading();

    try {
      if (state.locationData == null ||
          state.locationData!.latitude == null ||
          state.locationData!.longitude == null) {
        state = state.copyWith(error: "Location data not available");
        _finishLoading();
        return null;
      }

      final res =
          await http.get(Uri.https('nominatim.openstreetmap.org', 'reverse', {
        'lat': state.locationData!.latitude.toString(),
        'lon': state.locationData!.longitude.toString(),
        'format': 'jsonv2'
      }));

      if (res.statusCode != 200) {
        state =
            state.copyWith(error: "Failed to fetch address: ${res.statusCode}");
        _finishLoading();
        return null;
      }

      // decode the raw response as a map
      final rawData = jsonDecode(res.body) as Map<String, dynamic>;

      debugPrint('rawData: $rawData');

      // See: https://nominatim.org/release-docs/develop/api/Reverse/#example-with-formatjsonv2
      NominatimAddress address = NominatimAddress.fromJSON(
          rawData['address'], rawData['display_name'], rawData['name']);

      state = state.copyWith(address: address);
      _finishLoading();
      return address;
    } catch (err) {
      state = state.copyWith(error: "Error fetching address: $err");
      debugPrint('ERROR: $err');
      _finishLoading();
      return null;
    }
  }

  void _startLoading() {
    state = state.copyWith(loading: true, error: null);
  }

  void _finishLoading() {
    state = state.copyWith(loading: false);
  }
}

final locationProvider =
    StateNotifierProvider<LocationNotifier, LocationState>((ref) {
  return LocationNotifier();
});
