import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotifyplayer/models/RecentPlayed.dart';

class MusicPlayerScreen extends StatelessWidget {
  final Track track;
  final String? playListName;

  const MusicPlayerScreen({required this.track, this.playListName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            print(details);
            if (details.primaryDelta! > 10) {
              // Detects a downward swipe
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              // Top bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          color: Colors.white,
                          Icons.keyboard_arrow_down,
                          size: 30,
                        )),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'PLAYING FROM PLAYLIST',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          playListName!,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const Icon(Icons.more_vert, color: Colors.white70),
                  ],
                ),
              ),

              // Album art
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(track.album.images[0].url!)),
                      color: Colors.deepOrange,

                    ),
                    child:  Center(
                      child: Text(
                        'kimem',
                        style: GoogleFonts.poppins(
                          fontSize: 4,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Player controls
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Song info
                     Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              track.name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                             track.artists[0].name,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.favorite, color: Colors.green),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Progress bar
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: 0.3,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0:30',
                                style: TextStyle(color: Colors.white70)),
                            Text('3:05',
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.shuffle, color: Colors.white70),
                        const Icon(Icons.skip_previous,
                            color: Colors.white, size: 36),
                        Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(Icons.pause,
                                color: Colors.black, size: 36),
                          ),
                        ),
                        const Icon(Icons.skip_next,
                            color: Colors.white, size: 36),
                        const Icon(Icons.repeat, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Bottom controls
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.devices, color: Colors.white70),
                        Icon(Icons.share, color: Colors.white70),
                        Icon(Icons.queue_music, color: Colors.white70),
                      ],
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
