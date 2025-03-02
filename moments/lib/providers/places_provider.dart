import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moments/models/address.dart';
import 'package:moments/models/place.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class PlacesNotifier extends StateNotifier<List<Place>> {
  PlacesNotifier() : super([]);

  Future<void> _handleDbConfigure(Database db) async {
    // Add support for cascade delete
    // See: https://github.com/tekartik/sqflite/issues/544
    return await db.execute("PRAGMA foreign_keys = ON");
  }

  Future<void> _handleDbCreate(Database db, int version) {
    return db.transaction((txn) async {
      await txn.execute(
          'CREATE TABLE addresses(id INTEGER PRIMARY KEY, road TEXT, village TEXT, state_district TEXT, state TEXT, post_code TEXT, country TEXT, country_code TEXT, display_name TEXT, name TEXT, lat REAL, lon REAL)');
      await txn.execute(
          'CREATE TABLE places(id INTEGER PRIMARY KEY, title TEXT, image TEXT, dateTime TEXT, address_id TEXT, FOREIGN KEY(address_id) REFERENCES addresses(id) ON DELETE CASCADE)');
    });
  }

  Future<Database> _getDatabase() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(path.join(dbPath, 'places.db'),
        onConfigure: _handleDbConfigure, onCreate: _handleDbCreate, version: 2);

    return db;
  }

  void add(String name, File image, DateTime dateTime, Address address) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final fileName = path.basename(image.path);
    final copiedImage = await image.copy('${appDir.path}/$fileName');

    final db = await _getDatabase();

    try {
      var res = await db.transaction((txn) async {
        // insert our address first
        int addressId = await txn.insert('addresses', {
          'road': address.road,
          'village': address.village,
          'state_district': address.stateDistrict,
          'state': address.state,
          'post_code': address.postCode,
          'country': address.country,
          'country_code': address.countryCode,
          'display_name': address.displayName,
          'name': address.name,
          'lat': address.lat,
          'lon': address.lon,
        });

        // insert the place into the places table
        int placeId = await txn.insert('places', {
          'title': name,
          'image': image.path,
          'dateTime': dateTime.toIso8601String(),
          'address_id': addressId,
        });

        return [placeId, addressId];
      });

      final newPlace = Place(
          id: res.first.toString(),
          title: name,
          image: copiedImage,
          dateTime: dateTime,
          address: address);

      state = [
        newPlace,
        ...state,
      ];
    } catch (err) {
      debugPrint('Error: ${err.toString()}');
    }
  }

  Future<void> loadPlaces() async {
    final db = await _getDatabase();
    final rawData = await db.query('places');
    final addresses = await _getAddresses();
    final data = rawData
        .map((row) => Place(
            id: row['id'] as String,
            // find our related address
            address: addresses
                .firstWhere((address) => address.id == row['id'] as String),
            image: File(row['image'] as String),
            title: row['title'] as String,
            dateTime: DateTime.parse(row['dateTime'] as String)))
        .toList();
    state = data;
  }

  Future<List<Address>> _getAddresses() async {
    final db = await _getDatabase();
    final rawData = await db.query('addresses');
    final data = rawData
        .map((row) => Address(
            id: row['id'] as String,
            road: row['road'] as String,
            village: row['village'] as String,
            stateDistrict: row['state_district'] as String,
            state: row['state'] as String,
            postCode: row['post_code'] as String,
            country: row['country'] as String,
            countryCode: row['country_code'] as String,
            displayName: row['display_name'] as String,
            name: row['name'] as String,
            lat: row['lat'] as double,
            lon: row['lon'] as double))
        .toList();

    return data;
  }
}

final placesProvider =
    StateNotifierProvider<PlacesNotifier, List<Place>>((ref) {
  return PlacesNotifier();
});
