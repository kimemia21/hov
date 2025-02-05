import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotifyplayer/Globals.dart';
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

  late Future<List<RecentlyPlayedItem>> recentPlays;
  late Future<List<TopArtists>> topArtists;
  @override
  void initState() {
    super.initState();
    getProfile();
    // getRecentPlays();
    // getRecentPlayLists();
    playLists = getRecentPlayLists();
    recentPlays = getRecentPlayed();
    topArtists = getTopArtists();
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

  Future<List<RecentlyPlayedItem>> getRecentPlayed() async {
    setState(() {
      isLoading = true;
    });

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
        return rsP.items;
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
    setState(() {
      isLoading = true;
    });

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
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.all(2),
          child: isLoading
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.green, size: 40),
                )
              : Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 10,
                      right: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getGreeting(),
                            style: GoogleFonts.albertSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.notifications,
                                    // size: 28,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.history,
                                    // size: 28,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.05),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.settings,
                                    // size: 28,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 80,
                        left: 10,
                        right: 10,
                        child: RefreshIndicator(
                          onRefresh: () async {
                            await getProfile();
                            await getRecentPlayed();
                            await getRecentPlayLists();
                          },
                          child: SingleChildScrollView(
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
                                            playlistName: item.name,
                                            imageUrl: item.images[0].url!,
                                          );
                                        },
                                      );
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                        child: Text("Error loading playlists",
                                            style:
                                                TextStyle(color: Colors.white)),
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
                                FutureBuilder<List<RecentlyPlayedItem>>(
                                  future: recentPlays,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data;
                                      return SpotifyReleaseCard(
                                          RPI: data![0],
                                          onPlay: () {},
                                          onLike: () {});
                                    } else if (snapshot.hasError) {
                                      return const Center(
                                        child: Text(
                                            "Error loading Recent Plays",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      );
                                    } else {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Your Top 10 Artists",
                                  style: GoogleFonts.albertSans(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                  SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ))
                  ],
                ),
        ));
  }
}

class HomepagePlayListTile extends StatefulWidget {
  final String imageUrl;
  final String playlistName;

  const HomepagePlayListTile({
    super.key,
    required this.imageUrl,
    required this.playlistName,
  });

  @override
  State<HomepagePlayListTile> createState() => _HomepagePlayListTileState();
}

class _HomepagePlayListTileState extends State<HomepagePlayListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              widget.imageUrl,
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
                widget.playlistName,
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
    );
  }
}

class SpotifyReleaseCard extends StatelessWidget {
  final RecentlyPlayedItem RPI;
  final VoidCallback onPlay;
  final VoidCallback onLike;

  const SpotifyReleaseCard({
    Key? key,
    required this.RPI,
    required this.onPlay,
    required this.onLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
              color: const Color.fromARGB(255, 8, 8, 8),
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
    );
  }
}
