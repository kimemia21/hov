import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("PlayList items"),
      ),
    );
  }
}
