import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:moments/models/nominatim_address.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class Place {
  final String id;
  final String title;
  final DateTime dateTime;
  final File image;
  final NominatimAddress address;

  Place(
      {required this.title,
      required this.image,
      required this.dateTime,
      required this.address})
      : id = uuid.v4();

  /// Factory constructor for assets
  static Future<Place> fromAsset(
      {required String name,
      required String assetPath,
      required DateTime dateTime,
      required NominatimAddress address}) async {
    final file = await _copyAssetToFile(assetPath);
    return Place(
        title: name, image: file, dateTime: dateTime, address: address);
  }

  /// Factory constructor for file path
  static Future<Place> fromFilePath(
      {required String name,
      required String filePath,
      required DateTime dateTime,
      required NominatimAddress address}) async {
    final file = File(filePath);
    if (await file.exists()) {
      return Place(
          title: name, image: file, dateTime: dateTime, address: address);
    } else {
      throw Exception("File does not exist at path: $filePath");
    }
  }

  /// Factory constructor for file instance
  static Place fromFileInstance(
      {required String name,
      required File file,
      required DateTime dateTime,
      required NominatimAddress address}) {
    return Place(
        title: name, image: file, dateTime: dateTime, address: address);
  }

  /// Helper method to copy an asset to a temporary file
  static Future<File> _copyAssetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/${assetPath.split('/').last}');

    await tempFile.writeAsBytes(byteData.buffer.asUint8List());
    return tempFile;
  }

  String get formattedDate {
    String formattedDate = DateFormat('E, MMM d y').format(dateTime);
    return formattedDate;
  }
}
