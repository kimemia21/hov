import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:spotifyplayer/creditials.dart';
import 'package:spotifyplayer/models/Playlistmodel.dart';

class Playlist extends StatefulWidget {
  final String playlistId;
  const Playlist({required this.playlistId});

  @override
  State<Playlist> createState() => _PlaylistState();
}

class _PlaylistState extends State<Playlist> {
  bool isLoading = false;
  late Future<PlaylistModel> playlist;

  @override
  void initState() {
    super.initState();
    playlist = getPlayListItems();
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

  Widget TopAndSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
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
                            hintText: "Find in liked songs",
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(color: Colors.black),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.green, size: 40)
            : FutureBuilder<PlaylistModel>(
              future: playlist,
              builder: (context, snapshot) {
                return Stack(children: [
                    Positioned(
                        top: 20, left: 0, right: 0, child: Container(
                          
                      height: MediaQuery.of(context).size.height*0.4,
                      
                      decoration: BoxDecoration(color: Colors.grey,
                      borderRadius: BorderRadius.circular(10)),
                          child: TopAndSearchBar())),
                    Center(
                      child: Text("PlayList items"),
                    ),
                  ]);
              }
            ),
      ),
    );
  }
}
