import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:spotifyplayer/comms.dart';
import 'package:spotifyplayer/models/UserAccount.dart';

final clientId = dotenv.get("CLIENT_ID");
final redirectUri = 'myapp://callback';
final clientSecret = dotenv.get("CLIENT_SECRETE");
String accessCode = "empty";
String baseUrl = "https://api.spotify.com";

SpotifyRequests spotifyRequests = SpotifyRequests();
SpotifyUser spotifyUser = SpotifyUser();
