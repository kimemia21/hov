import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:spotifyplayer/models/Playlistmodel.dart';
import 'package:spotifyplayer/models/RecentPlayed.dart';

class Playlist extends StatefulWidget {
  final String playlistId;
  const Playlist({required this.playlistId});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool isLoading = false;
  late String playListName;
  late Future<PlaylistModel> playlist;
  late String playListArtImage;
  Color imagePaletteColor = Colors.black45;

  @override
  void initState() {
    super.initState();
    playlist = getPlayListItems();
    playlist.then((value) {
      setState(() {
        playListName = value.name;
        playListArtImage = value.images[0].url!;
      });
      _updateBackgroundColor();
    });
  }

  Future<PlaylistModel> getPlayListItems() async {
    setState(() {
      isLoading = true;
    });

    try {
      final value = await spotifyRequests.getRequests(
        enpoint: "v1/playlists/${widget.playlistId}",
      );
      print("@@@@@@@@@@@@@@22$value======================");

      if (value["success"]) {
        setState(() {
          isLoading = false;
        });
        Map<String, dynamic> json = value["rsp"];

        final PlaylistModel plm = PlaylistModel.fromJson(json);

        return plm;
      } else {
        throw Exception("get PlayList items  ${value["rsp"]}");
      }
    } catch (e) {
      print("PlayList items error: $e");
      throw Exception("PlayList items $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _updateBackgroundColor() async {
    final ImageProvider imageProvider = NetworkImage(playListArtImage);

    try {
      final PaletteGenerator paletteGenerator =
          await PaletteGenerator.fromImageProvider(
        imageProvider,
        size: const Size(200, 200), // Smaller size for faster processing
      );

      if (mounted) {
        setState(() {
          imagePaletteColor =
              paletteGenerator.dominantColor?.color.withOpacity(0.9) ??
                  Colors.black87;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          imagePaletteColor = Colors.black87;
          isLoading = false;
        });
      }
    }
  }

  Widget TopAndSearchBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_back, color: Colors.white, size: 24),
        SizedBox(
          height: 12,
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1), // Transparent effect
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.white, size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Find in ${playListName.toLowerCase()}",
                          hintStyle: GoogleFonts.albertSans(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 12),
            Container(
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15), // Transparent effect
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  "Sort",
                  style: GoogleFonts.albertSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(

            // color: Colors.black,

            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.centerRight,
                colors: [
              Color.fromARGB(255, 138, 166, 202),
              imagePaletteColor,
              Colors.black87,
              Colors.black
            ])),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green, size: 40)
            : FutureBuilder<PlaylistModel>(
                future: playlist,
                builder: (context, snapshot) {
                  final data = snapshot.data;
                  return Stack(children: [
                    Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 12.0),
                            // height: MediaQuery.of(context).size.height * 0.4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TopAndSearchBar(),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Image.network(
                                    fit: BoxFit.cover,
                                    data!.images[0].url!,
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 200,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  data.name,
                                  style: GoogleFonts.albertSans(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                            height: 20,
                                            width: 20,
                                            spotifyUser.images![0].url!)),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      spotifyUser.displayName!,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Total Tracks",
                                      style: GoogleFonts.abel(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      data.tracks.total.toString(),
                                      style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.35,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: data.tracks.items.length,
                                      itemBuilder: (context, index) {
                                        return playListTile(
                                            track: data
                                                .tracks.items[index].track!);
                                      }),
                                )
                              ],
                            ))),
                  ]);
                }),
      ),
    );
  }
}

class playListTile extends StatelessWidget {
  final Track track;

  const playListTile({required this.track});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black87,
      ),
      child: Row(
        children: [
          // Album Art
          Image.network(
            track.album.images[0].url!,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),

          // Song Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  track.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (false)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'LYRICS',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        track.artists[0].name,
                        style: GoogleFonts.albertSans(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Right side icons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.green,
                size: 24,
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.more_vert,
                color: Colors.white.withOpacity(0.7),
                size: 24,
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
