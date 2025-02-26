import 'dart:io';

import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class FavoritePlace {
  final String id;
  final String name;
  final File image;

  FavoritePlace({required this.name, required this.image}) : id = uuid.v4();
}
