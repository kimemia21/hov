import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:spotifyplayer/notifications/PremiumToast.dart';

Dio dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 5),
    headers: {
      'Authorization': 'Bearer $accessCode',
      'Content-Type': 'application/json',
    },
  ),
);

class SpotifyRequests {
  static final authUrl = 'https://accounts.spotify.com/authorize'
      '?client_id=$clientId'
      '&response_type=code'
      '&redirect_uri=$redirectUri'
      '&scope=${Uri.encodeComponent(_scopes)}'
      '&show_dialog=true';

  static const _scopes = '''
ugc-image-upload user-read-playback-state user-modify-playback-state user-read-currently-playing 
app-remote-control streaming playlist-read-private playlist-read-collaborative playlist-modify-private 
playlist-modify-public user-follow-modify user-follow-read user-read-playback-position 
user-top-read user-read-recently-played user-library-modify user-library-read 
user-read-email user-read-private
''';

  Map<String, dynamic> _handleErrorResponse(Response response) {
    print("Error ${response.statusCode}: ${response.data}");

    switch (response.statusCode) {
      case 403:
        return {"success": false, "rsp": response.data};
      case 401:
        return {
          "success": false,
          "rsp": "Unauthorized: Please check your token."
        };
      case 400:
        return {"success": false, "rsp": "Bad Request: ${response.data}"};
      case 500:
        return {"success": false, "rsp": "Server Error: ${response.data}"};
      default:
        return {
          "success": false,
          "rsp": "Error ${response.statusCode}: ${response.data}"
        };
    }
  }

  Future<Map<String, dynamic>> loginWithSpotify() async {
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

      final loginCode = resultUri.queryParameters['code'];

      if (loginCode != null) {
        try {
          final tokenResponse = await getAccessToken(loginCode);

          print('DEBUG: Successfully retrieved access token');
          return {
            'success': true,
            'loginCode': loginCode,
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

  Future<void> getAccessToken(String logincode) async {
    final response = await http.post(
      Uri.parse("https://accounts.spotify.com/api/token"),
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        "Authorization":
            "Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}"
      },
      body: {
        "grant_type": "authorization_code",
        "code": logincode,
        "redirect_uri": redirectUri
      },
    );

    final data = json.decode(response.body);
    final access_Code = data['access_token'];
    if (response.statusCode == 200 && access_Code != null) {
      accessCode = data['access_token'];

      // print("###################3success");
      print("### acess code is $access_Code");
    }
  }

  Future<Map<String, dynamic>> getRequests({required String enpoint}) async {
    try {
      print(accessCode);
      if (accessCode != null) {
        print("hiting $baseUrl/$enpoint");
        final response = await dio.get("$baseUrl/$enpoint");
        if (response.statusCode == 200) {
          return {"success": true, "rsp": response.data};
        } else {
          var errorData = json.decode(response.data);

          return {"success": false, "rsp": "$errorData"};
        }
      } else {
        throw Exception('acessCode is missing');
      }
    } on DioException catch (e) {
      throw Exception('error on this enpoint $enpoint ,error is $e');
    }
  }

  Future<Map<String, dynamic>> PutRequests({required String enpoint}) async {
    try {
      print("Access Code: $accessCode");

      if (accessCode == null) {
        throw Exception('Access code is missing');
      }

      final String url = "$baseUrl/$enpoint";
      print("Hitting $url");

      final response = await dio.put(url);

      // Handling responses dynamically
      if (response.statusCode == 204) {
        return {"success": true, "rsp": response.data ?? "Success"};
      } else {
        print("########################################${response.statusCode}");
        // Handle different status codes dynamically
        return _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      return {"success": false, "rsp": "Request failed: ${e.message}"};
    }
  }

  Future<Map<String, dynamic>> PostRequests({required String enpoint}) async {
    try {
      print("Access Code: $accessCode");

      if (accessCode == null) {
        throw Exception('Access code is missing');
      }

      final String url = "$baseUrl/$enpoint";
      print("Hitting $url");

      final response = await dio.put(url);

      // Handling responses dynamically
      if (response.statusCode == 204) {
        return {"success": true, "rsp": response.data ?? "Success"};
      } else {
         
        // Handle different status codes dynamically
        return _handleErrorResponse(response);
      }
    } on DioException catch (e) {
      return {"success": false, "rsp": "Request failed: ${e.message}"};
    }
  }
}
