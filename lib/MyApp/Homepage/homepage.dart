import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotifyplayer/Globals.dart';
import 'package:spotifyplayer/MyApp/Music/CurrentPlay.dart';
import 'package:spotifyplayer/MyApp/Music/MusicPlayer.dart';
import 'package:spotifyplayer/MyApp/PlayLists/Playlist.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:spotifyplayer/models/RecentPlayed.dart';
import 'package:spotifyplayer/models/SpotifyPlaylists.dart';
import 'package:spotifyplayer/models/TopArtists.dart';
import 'package:spotifyplayer/models/UserAccount.dart';

class AppHomepage extends StatefulWidget {
  const AppHomepage({super.key});

  @override
  State<AppHomepage> createState() => _AppHomepageState();
}

class _AppHomepageState extends State<AppHomepage> {
  bool isLoading = false;
  late Future<List<SpotifyPlaylist>> playLists;

  StreamController<List<RecentlyPlayedItem>> recentPlaysController =
      StreamController.broadcast();
  Timer? _pollingTimer;

  // late Future<List<RecentlyPlayedItem>> recentPlays;
  late Future<List<TopArtists>> topArtists;
  @override
  void initState() {
    super.initState();
    getProfile();
    // getRecentPlays();
    // getRecentPlayLists();
    playLists = getRecentPlayLists();
    // recentPlays = getRecentPlayed();
    topArtists = getTopArtists();
    getRecentPlayed(); // Initial load
    startRealTimeUpdates(); // Start polling
  }

  void startRealTimeUpdates() {
    _pollingTimer = Timer.periodic(Duration(seconds: 60), (timer) {
    
      getRecentPlayed();
    });
  }

  Future<void> getProfile() async {
    setState(() {
      isLoading = true;
    });
    try {
      await spotifyRequests.getRequests(enpoint: "v1/me").then((value) {
        if (value["success"]) {
          Map<String, dynamic> data = value["rsp"];
          
          spotifyUser.initialize(data);

          setState(() {
            isLoading = false;
          });
        }
        setState(() {
          isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("useraccount error $e ");
    }
  }

  Future<void> getRecentPlayed() async {
    // setState(() {
    //   isLoading = true;
    // });

    try {
      final value = await spotifyRequests.getRequests(
        enpoint: "v1/me/player/recently-played?limit=1",
      );

      if (value["success"]) {
        setState(() {
          isLoading = false;
        });
        Map<String, dynamic> json = value["rsp"];

        final RecentlyPlayedResponse rsP =
            RecentlyPlayedResponse.fromJson(json);
        if (mounted) {
          recentPlaysController.add(rsP.items);
        }

        // return rsP.items;
      } else {
        throw Exception("getRecentPlayLists ${value["rsp"]}");
      }
    } catch (e) {
      print("Recent plays error: $e");
      throw Exception("getRecentPlayLists $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<List<SpotifyPlaylist>> getRecentPlayLists() async {
    // setState(() {
    //   isLoading = true;
    // });

    try {
      final value = await spotifyRequests.getRequests(
        enpoint: "v1/me/playlists?offset=1&limit=6",
      );

      if (value["success"]) {
        setState(() {
          isLoading = false;
        });

        print("recent playlists is ${value["rsp"]}");
        Map<String, dynamic> json = value["rsp"];
        final SpotifyPlaylistResponse spL =
            SpotifyPlaylistResponse.fromJson(json);

        return spL.items;
      } else {
        throw Exception("getRecentPlayLists ${value["rsp"]}");
      }
    } catch (e) {

      setState(() {
        isLoading = false;
      });
       recentPlaysController.addError(e); // Add this
      print("recent playlist error $e");
      throw Exception("getRecentPlayLists error $e");
    }
  }

  Future<List<TopArtists>> getTopArtists() async {
    setState(() {
      isLoading = true;
    });

    try {
      final value = await spotifyRequests.getRequests(
        enpoint: "v1/me/top/artists?time_range=medium_term&limit=10",
      );

      if (value["success"]) {
        setState(() {
          isLoading = false;
        });

        print("recent playlists is ${value["rsp"]}");
        Map<String, dynamic> json = value["rsp"];

        final TopArtistsResponse response = TopArtistsResponse.fromJson(json);

        return response.items;
      } else {
        throw Exception("getTop Artists error ${value["rsp"]}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("getTop Artists  error $e");
      throw Exception("getTop Artists error $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    recentPlaysController.close();
    _pollingTimer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(2),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.green, size: 40),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await getProfile();
                    await getRecentPlayed();
                    await getRecentPlayLists();
                    await getTopArtists();
                  },
                  child: Container(
                    child: SizedBox(
                      // error with the scrolling some kids are not being displayed correctly
                      // height: MediaQuery.of(context).size.height * 1,
                      // width: MediaQuery.of(context).size.width,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 50,
                            left: 10,
                            right: 10,
                            child: SingleChildScrollView(
                              physics: BouncingScrollPhysics(),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    getGreeting(),
                                    style: GoogleFonts.albertSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.notifications,
                                            // size: 28,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.history,
                                            // size: 28,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.05),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Icon(
                                            Icons.settings,
                                            // size: 28,
                                            color:
                                                Colors.white.withOpacity(0.7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                              top: 80,
                              left: 10,
                              right: 10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<List<SpotifyPlaylist>>(
                                    future: playLists,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final data = snapshot.data;
                                        return GridView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio:
                                                2.1, // This controls the height of the tiles
                                            crossAxisSpacing: 1,
                                            mainAxisSpacing: 1,
                                          ),
                                          shrinkWrap:
                                              true, // Add this to prevent expanding issues
                                          itemCount: data!.length,
                                          itemBuilder: (context, index) {
                                            final item = data[index];
                                            return HomepagePlayListTile(
                                              playlist: item,
                                            );
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text("Error loading playlists",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Recently Played",
                                    style: GoogleFonts.albertSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  StreamBuilder<List<RecentlyPlayedItem>>(
                                    stream: recentPlaysController.stream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.isNotEmpty) {
                                        final data = snapshot.data;
                                        return RecentPlayed(
                                            RPI: data!.first,
                                            onPlay: () {},
                                            onLike: () {});
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text(
                                              "Error loading Recent Plays",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Your Top 10 Artists",
                                    style: GoogleFonts.albertSans(
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FutureBuilder<List<TopArtists>>(
                                    future: topArtists,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        final data = snapshot.data;
                                        return SizedBox(
                                          height: 250,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                              itemCount: data!.length,
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) {
                                                return TopArtistTile(
                                                  topArtists: data[index],
                                                );
                                              }),
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text("Error top Plays",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        );
                                      } else {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              )),
                          Positioned(
                              bottom: 20,
                              right: 0,
                              left: 0,
                              child: CurrentlyPlayingTile())
                        ],
                      ),
                    ),
                  ),
                ),
        ));
  }
}

class HomepagePlayListTile extends StatefulWidget {
  final SpotifyPlaylist playlist;

  const HomepagePlayListTile({required this.playlist});

  @override
  State<HomepagePlayListTile> createState() => _HomepagePlayListTileState();
}

class _HomepagePlayListTileState extends State<HomepagePlayListTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            SlideUpRoute(page: Playlist(playlistId: widget.playlist.id)));
      },
      child: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
              child: Image.network(
                widget.playlist.images[0].url!,
                width: 50,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 65,
                    height: 65,
                    color: Colors.grey.shade800,
                    child: const Icon(Icons.music_note, color: Colors.white),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.playlist.name,
                  style: GoogleFonts.albertSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentPlayed extends StatelessWidget {
  final RecentlyPlayedItem RPI;
  final VoidCallback onPlay;
  final VoidCallback onLike;

  const RecentPlayed({
    Key? key,
    required this.RPI,
    required this.onPlay,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            SlideUpRoute(
                page: MusicPlayerScreen(
              track: RPI.track,
              playListName: RPI.track.album.name,
              isPlaying: false,
            )));
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          boxShadow: [
            // Bottom shadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Moves shadow **down**
            ),
            // Top shadow
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, -3), // Moves shadow **up**
            ),
          ],
          color: Colors.black,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with artist image and "NEW RELEASE FROM" text
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(RPI.track.album.images[0].url!),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      RPI.track.artists[0].name,
                      style: GoogleFonts.abel(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4.0),
              ),
              child: Row(
                children: [
                  // Album art
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      bottomLeft: Radius.circular(4),
                    ),
                    child: Image.network(
                      RPI.track.album.images[0].url!,
                      width: 100,
                      height: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            RPI.track.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${RPI.track.album.albumType} • (${RPI.track.album.name})',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.favorite_border),
                                color: Colors.white,
                                onPressed: onLike,
                              ),
                              IconButton(
                                icon: const Icon(Icons.play_circle_filled),
                                color: Colors.white,
                                iconSize: 40,
                                onPressed: onPlay,
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopArtistTile extends StatefulWidget {
  final TopArtists topArtists;
  const TopArtistTile({required this.topArtists});

  @override
  State<TopArtistTile> createState() => _TopArtistTileState();
}

class _TopArtistTileState extends State<TopArtistTile> {
  @override
  Widget build(BuildContext context) {
    print(widget.topArtists.genres);
    return Container(
      width: 180,
      decoration: BoxDecoration(
        color: Colors.black,

        // borderRadius: BorderRadius.circular(10)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,

          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.topArtists.images[0].url!,
              height: 120,
              width: 180,
              fit: BoxFit.cover,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              widget.topArtists.name,
              style: GoogleFonts.albertSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            Text(
              widget.topArtists.type,
              style: GoogleFonts.albertSans(
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
