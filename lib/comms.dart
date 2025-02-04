import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;

class SpotifyRequests {
  static final authUrl = 'https://accounts.spotify.com/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri'
      '&scope=user-read-private user-read-email playlist-read-private'
      '&show_dialog=true';

// static Future<void> clearCookies() async {
//   final cookieManager = WebviewCookieManager();
//   await cookieManager.clearCookies();
// }
  static Future<Map<String, dynamic>> loginWithSpotify() async {
    try {
      print('DEBUG: Starting Spotify authentication flow');
      print('DEBUG: Using callback scheme: myapp');

      final String debugAuthUrl = authUrl;
      print('DEBUG: Full auth URL being used: $debugAuthUrl');

      final result = await FlutterWebAuth.authenticate(
        url: debugAuthUrl,
        callbackUrlScheme: "myapp",
        preferEphemeral: true,
        // useWebview: true,
        // options: FlutterWebAuth2Options(preferEphemeral: true,useWebview: true,),
      ).timeout(Duration(seconds: 8), onTimeout: () {
        print('DEBUG: Authentication timed out');
        throw TimeoutException('Authentication timed out after 5 minutes');
      });

      print('DEBUG: Raw authentication result: $result');

      // Parse the result URL
      final Uri resultUri = Uri.parse(result);
      print('DEBUG: Parsed result URI: $resultUri');
      print('DEBUG: Query parameters: ${resultUri.queryParameters}');

      // Check for error parameters
      if (resultUri.queryParameters.containsKey('error')) {
        print(
            'DEBUG: Error found in response: ${resultUri.queryParameters['error']}');
        return {
          'success': false,
          'error': resultUri.queryParameters['error'],
          'error_description': resultUri.queryParameters['error_description']
        };
      }

      final code = resultUri.queryParameters['code'];
    
      if (code != null) {
          accessCode = code;
        try {
          final tokenResponse = await getAccessToken(accessCode);

          print('DEBUG: Successfully retrieved access token');
          return {
            'success': true,
            'code': code,
            'tokenResponse': "tokenResponse",
          };
        } catch (e) {
          print('DEBUG: Token exchange failed: $e');
          return {
            'success': false,
            'error': 'Token exchange failed',
            'details': e.toString()
          };
        }
      } else {
        print('DEBUG: No authorization code received');
        return {
          'success': false,
          'error': 'No authorization code received',
          'rawResult': result
        };
      }
    } catch (e) {
      print('DEBUG: Authentication error: $e');
      return {
        'success': false,
        'error': e.toString(),
        'stackTrace': StackTrace.current.toString()
      };
    }
  }

  static Future<void> getAccessToken(String code) async {
    print(code);
    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}"
      },
      body: {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectUri
      },
    );

    final data = json.decode(response.body);
    print("Access Token: ${data['access_token']}");
  }
}
