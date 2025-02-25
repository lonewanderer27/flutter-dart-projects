import 'package:flutter_dotenv/flutter_dotenv.dart';

var backendUri = Uri.https(dotenv.env['BACKEND_URL']!);