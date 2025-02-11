import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spotifyplayer/Globals.dart';
import 'package:spotifyplayer/MyApp/Music/CurrentDevices.dart';
import 'package:spotifyplayer/MyApp/Music/MusicPlayer.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:spotifyplayer/models/CurrentModel.dart';
import 'dart:async';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotifyplayer/models/Device.dart';
import 'package:spotifyplayer/notifications/PremiumToast.dart';

class CurrentlyPlayingTile extends StatefulWidget {
  const CurrentlyPlayingTile({super.key});

  @override
  State<CurrentlyPlayingTile> createState() => _CurrentlyPlayingTileState();
}

class _CurrentlyPlayingTileState extends State<CurrentlyPlayingTile> {
  StreamController<CurrentPlayModel?> _playbackController =
      StreamController.broadcast();
  StreamController<List<Device>> _devicesController =
      StreamController.broadcast();

  Timer? _pollingTimer;
  Timer? _progressTimer;
  int _currentProgress = 0;
  bool isPlaying = false;
  int timeStamp = 0;
  Color backGroundColor = Color(0xFF282828);
  String currentPlayImageUrl = "";
void startRealTimeUpdates() {
  // Fetch updated playback info every 3 seconds
  _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) {
    _currentProgress =
        DateTime.fromMillisecondsSinceEpoch(timeStamp).millisecondsSinceEpoch;
    getPlaying();
    getDevices();
    // Don't restart startMusicProgress() here
  });

  // Start the music progress updates separately
  if (_progressTimer == null || !_progressTimer!.isActive) {
    startMusicProgress();
  }
}

void startMusicProgress() {
  _progressTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
    if (mounted && isPlaying) {
      setState(() {
        _currentProgress += 500; // Simulate real-time progress
      });
    }
  });
}

  Future<void> getPlaying() async {
    try {
      final value = await spotifyRequests.getRequests(enpoint: "v1/me/player");

      if (value["success"]) {
        final model = CurrentPlayModel.fromJson(value["rsp"]);

        if (mounted) {
          setState(() {
            isPlaying = model.isPlaying;
            isPlaying ? timeStamp = model.progressMs : timeStamp;
            currentPlayImageUrl = model.item.album.images.first.url!;
          });
          _playbackController.add(model);
          _updateBackgroundColor();
        }
      } else {
        _playbackController.add(null);
      }
    } catch (e) {
      print("Current Play Error: $e");
      _playbackController.add(null);
    }
  }

  Future<void> playerActions(playStates state) async {
    print("called and the state is $state");
    // final String _state = playStatesToStrings(state: state);

    try {
      switch (state) {
        case playStates.play:
          await spotifyRequests.PutRequests(
            enpoint: "v1/me/player/play",
          ).then((value) {
            if (value["success"]) {
              getPlaying();
            }
          });
          break;
        case playStates.pause:
          await spotifyRequests.PutRequests(
            enpoint: "v1/me/player/pause",
          ).then((value) {});
          break;
        case playStates.next:
          await spotifyRequests.PostRequests(enpoint: "v1/me/player/next")
              .then((value) {
            print(value);
            if (value["success"]) {
              getPlaying();
            } else {
              Fluttertoast.showToast(
                  msg: "This is a premium Feature",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            {}
          });
          break;
        case playStates.previous:
          await spotifyRequests.PostRequests(enpoint: "v1/me/player/previous")
              .then((value) {
            print(value);
            if (value["success"]) {
              getPlaying();
            } else {
              Fluttertoast.showToast(
                  msg: "This is a premium Feature",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            {}
          });
          break;
        case playStates.stuffle:
          await spotifyRequests.PutRequests(
                  enpoint: "v1/me/player/shuffle?state={true|false}")
              .then((value) {});
          break;
        case playStates.repeat:
          await spotifyRequests.PutRequests(
                  enpoint: "v1/me/player/repeat?state={track|context|off}")
              .then((value) {});
          break;
      }
    } catch (e) {
      print("Current Play Error: $e");
      // _playbackController.add(null);
    }
  }

  Future<void> getDevices() async {
    try {
      final value =
          await spotifyRequests.getRequests(enpoint: "v1/me/player/devices");

      if (value["success"]) {
        final model = value["rsp"]["devices"] as List;
        final devices = model.map((e) => Device.fromJson(e)).toList();

        if (mounted) {
          _devicesController.add(devices);
          _updateBackgroundColor();
        }
      } else {
        _devicesController.add([]);
      }
    } catch (e) {
      print("Current device Error: $e");
      _devicesController.add([]);
    }
  }

  String formatTime(int milliseconds) {
    if (milliseconds < 0) milliseconds = 0;
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<void> _updateBackgroundColor() async {
    final ImageProvider imageProvider = NetworkImage(currentPlayImageUrl);

    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        imageProvider,
        size: const Size(200, 200), // Smaller size for faster processing
      );

      if (mounted) {
        setState(() {
          backGroundColor =
              paletteGenerator.dominantColor?.color.withOpacity(0.9) ??
                  backGroundColor;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          backGroundColor = Colors.black87;
          // isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPlaying();
    startRealTimeUpdates();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _progressTimer?.cancel();
    _playbackController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CurrentPlayModel?>(
      stream: _playbackController.stream,
      builder: (context, snapshot) {
        final currentTrack = snapshot.data;

        return GestureDetector(
          onTap: () => Navigator.push(
              context,
              SlideUpRoute(
                  page: MusicPlayerScreen(
                track: currentTrack!.item,
                playListName: currentTrack.item.album.name,
                isPlaying: true,
                currentProgress: _currentProgress,
              ))),
          onHorizontalDragEnd: (DragEndDetails details) async {
            print(details.primaryVelocity);
            if (details.primaryVelocity! > 1000) {
              await playerActions(playStates.next);
            } else if (details.primaryVelocity! < -1000) {
              await playerActions(playStates.previous);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                color: backGroundColor,
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.center,
                    colors: [backGroundColor, Color(0xFF282828)])),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child:
                            currentTrack?.item.album.images.isNotEmpty == true
                                ? Image.network(
                                    currentTrack!.item.album.images.first.url!,
                                    width: 56,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: 56,
                                        height: 56,
                                        color: Colors.deepOrange,
                                      );
                                    },
                                  )
                                : Container(
                                    width: 56,
                                    height: 56,
                                    color: Colors.deepOrange,
                                  ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentTrack?.item.name ?? 'No Track Playing',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              currentTrack?.item.artists
                                      .map((a) => a.name)
                                      .join(', ') ??
                                  'Unknown Artist',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.devices_outlined,
                                color: Colors.green),
                            onPressed: () async {
                              showBottomSheet(
                                  showDragHandle: true,
                                  context: context,
                                  builder: (context) {
                                    return Container(
                                        height: 400,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.9)),
                                        child: SpotifyDevicesStream(
                                          devicesStream:
                                              _devicesController.stream,
                                        ));
                                  });
                              // Implement device selection
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite_border,
                                color: Colors.white70),
                            onPressed: () async {
                              // Implement like functionality
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              currentTrack?.isPlaying == true
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              playerActions(playStates.play);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (currentTrack != null) ...[
                  LinearProgressIndicator(
                    value: currentTrack.item.durationMs > 0
                        ? _currentProgress / currentTrack.item.durationMs
                        : 0.0,
                    backgroundColor: Colors.white24,
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 3,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatTime(_currentProgress),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          formatTime(currentTrack.item.durationMs),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
