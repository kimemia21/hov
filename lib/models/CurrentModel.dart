
// Track model
import 'package:spotifyplayer/models/Device.dart';
import 'package:spotifyplayer/models/RecentPlayed.dart';



class CurrentPlayModel {
  final Device device;
  final bool shuffleState;
  final bool smartShuffle;
  final String repeatState;
  final int timestamp;
  final Context context;
  final int progressMs;
  final Track item;
  final String currentlyPlayingType;
  final Map<String, dynamic> actions;
  final bool isPlaying;

  CurrentPlayModel({
    required this.device,
    required this.shuffleState,
    required this.smartShuffle,
    required this.repeatState,
    required this.timestamp,
    required this.context,
    required this.progressMs,
    required this.item,
    required this.currentlyPlayingType,
    required this.actions,
    required this.isPlaying,
  });

  factory CurrentPlayModel.fromJson(Map<String, dynamic> json) {
    return CurrentPlayModel(
      device: Device.fromJson(json['device']),
      shuffleState: json['shuffle_state'] ?? false,
      smartShuffle: json['smart_shuffle'] ?? false,
      repeatState: json['repeat_state'] ?? '',
      timestamp: json['timestamp'] ?? 0,
      context: Context.fromJson(json["context"]),
      progressMs: json['progress_ms'] ?? 0,
      item: Track.fromJson(json['item']),
      currentlyPlayingType: json['currently_playing_type'] ?? '',
      actions: json['actions'] ?? {},
      isPlaying: json['is_playing'] ?? false,
    );
  }
}