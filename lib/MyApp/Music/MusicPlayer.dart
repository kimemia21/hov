import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spotifyplayer/models/RecentPlayed.dart';

class MusicPlayerScreen extends StatefulWidget {
  final Track track;
  final String? playListName;
  final bool isPlaying;
  final int? currentProgress;

  const MusicPlayerScreen(
      {required this.track,
      this.playListName,
      required this.isPlaying,
      this.currentProgress});

  @override
  State<MusicPlayerScreen> createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  Timer? _progressTimer;
  int _currentProgress = 0;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.isPlaying;
    if (_isPlaying) {
      _currentProgress = widget.currentProgress!;
    }
    startProgressTimer();
  }

  void startProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted && _isPlaying) {
        setState(() {
          _currentProgress += 500;

          if (_currentProgress >= widget.track.durationMs) {
            _currentProgress = widget.track.durationMs;
          }
        });
      }
    });
  }

  String formatTime(int milliseconds) {
    if (milliseconds < 0) milliseconds = 0;
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            if (details.primaryDelta! > 10) {
              Navigator.of(context).pop();
            }
          },
          child: Column(
            children: [
              SizedBox(height: 30),
              // Top bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.keyboard_arrow_down,
                          color: Colors.white, size: 30),
                    ),
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
                          widget.playListName!,
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    Icon(Icons.more_vert, color: Colors.white70),
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
                      image: DecorationImage(
                        image: NetworkImage(widget.track.album.images[0].url!),
                      ),
                    ),
                    child: Center(
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
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.track.name,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              widget.track.artists[0].name,
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 14),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(Icons.favorite, color: Colors.green),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Progress bar
                    Column(
                      children: [
                        LinearProgressIndicator(
                          value: widget.track.durationMs > 0
                              ? _currentProgress / widget.track.durationMs
                              : 0.0,
                          backgroundColor: Colors.white24,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(_currentProgress),
                                style: TextStyle(color: Colors.white70)),
                            Text(formatTime(widget.track.durationMs),
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Playback controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.shuffle, color: Colors.white70),
                        Icon(Icons.skip_previous,
                            color: Colors.white, size: 36),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                              if (_isPlaying) {
                                startProgressTimer();
                              }
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 36,
                              ),
                            ),
                          ),
                        ),
                        Icon(Icons.skip_next, color: Colors.white, size: 36),
                        Icon(Icons.repeat, color: Colors.white70),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
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
