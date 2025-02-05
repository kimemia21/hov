import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotifyplayer/Globals.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:spotifyplayer/models/SpotifyPlaylists.dart';
import 'package:spotifyplayer/models/UserAccount.dart';

class AppHomepage extends StatefulWidget {
  const AppHomepage({super.key});

  @override
  State<AppHomepage> createState() => _AppHomepageState();
}

class _AppHomepageState extends State<AppHomepage> {
  bool isLoading = false;
  late Future<List<SpotifyPlaylist>> playLists;
  @override
  void initState() {
    super.initState();
    getProfile();
    // getRecentPlays();
    // getRecentPlayLists();
    playLists = getRecentPlayLists();
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

  Future<void> getRecentPlays() async {
    setState(() {
      isLoading = true;
    });
    try {
      await spotifyRequests
          .getRequests(enpoint: "v1/me/player/recently-played")
          .then((value) {
        if (value["success"]) {
          setState(() {
            isLoading = false;
          });
          print(value["rsp"]);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("recent plays error $e ");
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await getProfile();
        await getRecentPlayLists();
      },
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Container(
            padding: EdgeInsets.all(2),
            child: isLoading
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.green, size: 40),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Stack(
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
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.05),
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                              child:
// Modified FutureBuilder implementation
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
                              ))
                        ],
                      ),
                    ),
                  ),
          )),
    );
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
