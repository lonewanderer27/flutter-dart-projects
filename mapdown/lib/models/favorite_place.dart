import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

class FavoritePlace {
  String id;
  String name;

  FavoritePlace({required this.name}) : id = uuid.v4();
}
