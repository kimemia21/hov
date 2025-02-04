// import 'dart:convert';

// import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';
// import 'package:app_links/app_links.dart';
// import 'package:spotifyplayer/creditials.dart';
// import 'package:url_launcher/url_launcher.dart';
// AppLinks appLinks = AppLinks();



// class TestLogin extends StatefulWidget {
//   const TestLogin({Key? key}) : super(key: key);

//   @override
//   State<TestLogin> createState() => _TestLoginState();
// }

// class _TestLoginState extends State<TestLogin> {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {

//   final String scope = 'user-read-private user-read-email';

//   late String accessToken;
//   late String refreshToken;

//   Uri get createAuthenticationUri {
//     var query = [
//       'response_type=code',
//       'client_id=$clientId',
//       'scope=${Uri.encodeComponent(scope)}',
//       'redirect_uri=${Uri.encodeComponent(redirectUri)}',
//     ];

//     var queryString = query.join('&');
//     var url = 'https://accounts.spotify.com/authorize?$queryString';
//     var parsedUrl = Uri.parse(url);
//     return parsedUrl;
//   }

//   Future<void> launchInBrowser() async {
//     if (!await launchUrl(
//       createAuthenticationUri,
//       mode: LaunchMode.externalApplication,
//     )) {
//       throw Exception('Could not launch Url');
//     }
//   }

//   Future<void> getAccessToken(String code) async {
//     var body = {
//       'grant_type': 'authorization_code',
//       'code': code,
//       'redirect_uri': redirectUri,
//       'client_id': clientId,
//       'client_secret': "clientSecret"
//     };
//     // Create a request header with the required information
//     var header = {
//       'Content-Type': 'application/x-www-form-urlencoded',
//       'Authorization': 'Basic ${base64Encode(utf8.encode('$clientID:$clientSecret'))}'
//     };
//     // Send the request to the Spotify token endpoint
//     var response = await http.post(Uri.parse('https://accounts.spotify.com/api/token'), body: body, headers: header);

//     print('check status code: ${response.statusCode}');
//     print('check body: ${response.body}');

//     // Check if the request was successful
//     if (response.statusCode == 200) {
//       // Parse the JSON response
//       var data = json.decode(response.body);
//       // Get the access token from the response
//       accessToken = data['access_token'];
//       refreshToken = data['refresh_token'];

//       // Store the access token for future use
//       // ...
//       print('access token: $accessToken');
//       print('refresh token: $refreshToken');
//     } else {
//       print('Something went wrong');
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     handleLinks();
//   }

//   void handleLinks() {
//       appLinks.uriLinkStream.listen((event) {
//       print('message handleLinks event happened: ${event?.query}');
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Spotify Web API'),
//         centerTitle: true,
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await launchInBrowser();
//           },
//           child: const Text('Get Token'),
//         ),
//       ),
//     );
//   }
// }