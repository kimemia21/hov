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
            padding: EdgeInsets.all(8),
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
                            top: 60,
                            left: 10,
                            right: 10,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  getGreeting(),
                                  style: GoogleFonts.albertSans(
                                    fontSize: 24,
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
                              top: 170,
                              left: 10,
                              right: 10,
                              child: FutureBuilder<List<SpotifyPlaylist>>(
                                  future: playLists,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data;
                                      return SizedBox(
                                       height: MediaQuery.of(context).size.height*0.4,
                                        child: GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2),
                                          scrollDirection: Axis.vertical,
                                          itemCount: data!.length,
                                          itemBuilder: (context, index) {
                                            final item = data[index];
                                            return Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: Image.network(
                                                    item.images[0].url!));
                                          },
                                        ),
                                      );
                                    } else {
                                      return Center(
                                        child: Text("No Data"),
                                      );
                                    }
                                  }))
                        ],
                      ),
                    ),
                  ),
          )),
    );
  }
}

class ArtistRecentPlayCard extends StatelessWidget {
  final String artistName;
  final String artistImageUrl;
  final String genre;

  const ArtistRecentPlayCard({
    Key? key,
    required this.artistName,
    required this.artistImageUrl,
    required this.genre,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.black.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Hero(
                tag: artistName,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 15,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      artistImageUrl,
                      width: 120,
                      height: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade900,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white24,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Artist Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artistName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        genre,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // View Profile Button
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.2),
                      Colors.white.withOpacity(0.1)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                  onPressed: () {
                    // Navigate to artist profile
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ArtistProfilePage(artistName: artistName),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtistProfilePage extends StatelessWidget {
  final String artistName;

  const ArtistProfilePage({Key? key, required this.artistName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(artistName),
      ),
      body: Center(
        child: Text(
          'Artist Profile for $artistName',
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class RecentPlaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: ListView(
        children: [
          ArtistRecentPlayCard(
            artistName: "The Weeknd",
            artistImageUrl: "https://example.com/artist-image.jpg",
            genre: "Pop R&B",
          ),
          ArtistRecentPlayCard(
            artistName: "Billie Eilish",
            artistImageUrl: "https://example.com/billie-image.jpg",
            genre: "Alternative Pop",
          ),
        ],
      ),
    );
  }
}
