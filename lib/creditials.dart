import 'package:flutter_dotenv/flutter_dotenv.dart';

final clientId = dotenv.get("CLIENT_ID");
final redirectUri = 'myapp://callback';
final clientSecret =dotenv.get("CLIENT_SECRET");
String accessCode ="empty";
