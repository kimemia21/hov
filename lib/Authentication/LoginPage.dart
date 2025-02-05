import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotifyplayer/Globals.dart';
import 'package:spotifyplayer/MyApp/UserProfile.dart';
import 'package:spotifyplayer/comms.dart';
import 'package:spotifyplayer/creditials.dart';

import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotifyplayer/MyApp/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/SplashThirteen.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black26,
              BlendMode.darken,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Logo or Brand Icon
              Icon(
                Icons.music_note,
                size: 80,
                color: Colors.white.withOpacity(0.9),
              ),
              const SizedBox(height: 24),
              // Welcome Text
              Text(
                "Welcome Back",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Login to continue",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const Spacer(flex: 2),
              // Login Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          setState(() {
                            isLoading = true;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: Center(
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.green,
                                  size: 50,
                                ),
                              ),
                            ),
                          );

                          await spotifyRequests.loginWithSpotify()
                              .then((value) {
                            if (value["success"]) {
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.of(context).pop();
                              Navigator.push(
                                  context,SlideUpRoute(page: AppHomepage())
                                 );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                        Text(value['error'] ?? 'Login failed')),
                              );
                            }
                          });
                        } catch (e) {
                          Navigator.of(context)
                              .pop(); // Make sure to pop the loading dialog
                          print("Error in button press: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('An unexpected error occurred')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 8,
                        shadowColor: Colors.green.withOpacity(0.5),
                      ),
                      child: isLoading? LoadingAnimationWidget.staggeredDotsWave(
                                  color: Colors.white,
                                  size: 20,
                                ):Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.music_note,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Login with Spotify",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      
                      
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
