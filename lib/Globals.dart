import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

 enum playStates {pause,play,next,previous,stuffle,repeat}

 String playStatesToStrings({required playStates state}){
  switch(state){
    case playStates.pause:
      return "pause";
    case playStates.play:
      return "play";
    case playStates.next:
      return "next";
    case playStates.previous:
      return "previous";
    case playStates.stuffle:
      return "stuffle"; 
      case playStates.repeat:
      return "repeat";   
  }

 }

 



Future<void> openSpotify({required String url}) async {
  print("Opening URL: $url");

  final Uri uri = Uri.parse(url);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } else {
    print("Could not open Spotify.");
  }
}

class SmoothPageRoute extends PageRouteBuilder {
  final Widget page;

  SmoothPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Main animation for the new page
            var begin = Offset(1.0, 0.0);
            var end = Offset.zero;
            var tween = Tween(begin: begin, end: end);
            var offsetAnimation = animation.drive(tween);

            // Fade animation
            var fadeAnimation = animation.drive(Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutCubic)));

            // Scale animation
            var scaleAnimation = animation.drive(Tween(begin: 0.95, end: 1.0)
                .chain(CurveTween(curve: Curves.easeOutCubic)));

            return FadeTransition(
              opacity: fadeAnimation,
              child: SlideTransition(
                position: offsetAnimation,
                child: ScaleTransition(
                  scale: scaleAnimation,
                  child: child,
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 400),
          reverseTransitionDuration: Duration(milliseconds: 400),
        );
}

// Optional: Additional transition variations
class FadeScaleRoute extends PageRouteBuilder {
  final Widget page;

  FadeScaleRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var fadeAnimation = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            return FadeTransition(
              opacity: fadeAnimation,
              child: ScaleTransition(
                scale: Tween<double>(
                  begin: 0.95,
                  end: 1.0,
                ).animate(fadeAnimation),
                child: child,
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 300),
          reverseTransitionDuration: Duration(milliseconds: 300),
        );
}

class SlideUpRoute extends PageRouteBuilder {
  final Widget page;

  SlideUpRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeInOutCubic;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
          transitionDuration: Duration(milliseconds: 500),
          reverseTransitionDuration: Duration(milliseconds: 500),
        );
}

String getGreeting() {
  final hour = DateTime.now().hour;

  // Early morning (12 AM - 5 AM)
  if (hour >= 0 && hour < 5) {
    return "Hi there";
  }
  // Morning (5 AM - 12 PM)
  else if (hour >= 5 && hour < 12) {
    return "Good morning";
  }
  // Afternoon (12 PM - 5 PM)
  else if (hour >= 12 && hour < 17) {
    return "Good afternoon";
  }
  // Evening (5 PM - 9 PM)
  else if (hour >= 17 && hour < 21) {
    return "Good evening";
  }
  // Night (9 PM - 12 AM)
  else {
    return "How was your day";
  }
}
