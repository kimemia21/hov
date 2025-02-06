import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotifyplayer/creditials.dart';

class SpotifyUserPage extends StatefulWidget {
  const SpotifyUserPage({super.key});

  @override
  State<SpotifyUserPage> createState() => _SpotifyUserPageState();
}

class _SpotifyUserPageState extends State<SpotifyUserPage> {
  PaletteGenerator? _paletteGenerator;
  List<Color> gradientColors = [
    Colors.brown.shade800.withOpacity(0.8),
    Colors.brown.shade200.withOpacity(0.8)
  ];

  @override
  void initState() {
    super.initState();
    getProfile();
    _updatePaletteGenerator();
  }
  
  Future<void> getProfile() async {
    try {
      await spotifyRequests.getRequests(enpoint: "v1/me").then((value) {
        if (value["success"]) {
          Map<String, dynamic> data = value["rsp"];
          spotifyUser.initialize(data);
          spotifyUser.printDetails();
        }

        // print("profile data is$value");
      });
    } catch (e) {
      print("useraccount error $e ");
    }
  }

  Future<void> _updatePaletteGenerator() async {
    final imageProvider = NetworkImage(spotifyUser.images![0].url!);
    
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      imageProvider,
      size: const Size(200, 200), // Reduced size for performance
    );
    
    if (mounted) {
      setState(() {
        _paletteGenerator = paletteGenerator;
        if (_paletteGenerator?.dominantColor != null && 
            _paletteGenerator?.darkMutedColor != null) {
          gradientColors = [
            _paletteGenerator!.dominantColor!.color.withOpacity(0.8),
            _paletteGenerator!.darkMutedColor!.color.withOpacity(0.8),
          ];
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

     decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft ,
              colors: [
                const Color.fromARGB(255, 16, 54, 18),
                const Color.fromARGB(255, 18, 69, 4), // Top right
              
                 const Color.fromARGB(255, 6, 23, 8), 
                 Colors.black
            
               // Bottom left
              ],
              // stops: [0.2, 0.8], // Adjust this for the perfect gradient balance
            ),
          ),


        child: Stack(
          children: [
            // Positioned(
            //   top: 0,
            //   left: 0,
            //   right: 0,
            //   child: Container(
            //     width: MediaQuery.of(context).size.width,
            //     height: MediaQuery.of(context).size.height * 0.3,
            //     decoration: BoxDecoration(
                  
            //       image: DecorationImage(
            //         fit: BoxFit.cover,
            //         image: NetworkImage(spotifyUser.images![0].url!),
            //       ),
            //       gradient: LinearGradient(
            //         begin: Alignment.topCenter,
            //         end: Alignment.bottomCenter,
            //         colors: gradientColors,
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}