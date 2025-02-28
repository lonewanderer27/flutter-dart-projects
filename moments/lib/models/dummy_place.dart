import 'package:intl/intl.dart';
import 'package:moments/models/place.dart';

class DummyPlace {
  final String id;
  final String title;
  final String imagePath;
  final DateTime dateTime;

  DummyPlace({required this.title, required this.imagePath, DateTime? dateTime})
      : id = uuid.v4(),
        dateTime = dateTime ?? DateTime.now();

  String get formattedDate {
    String formattedDate = DateFormat('E, MMM d y').format(dateTime);
    return formattedDate;
  }
}
