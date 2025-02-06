import 'package:spotifyplayer/models/RecentPlayed.dart';
import 'package:spotifyplayer/models/UserAccount.dart';

class PlaylistModel {
  final bool collaborative;
  final String description;
  final ExternalUrls externalUrls;
  final Followers followers;
  final String href;
  final String id;
  final List<SpotifyImage> images;
  final String name;
  final Owner owner;
  final String? primaryColor;
  final bool public;
  final String snapshotId;
  final PlaylistTracks tracks;
  final String type;
  final String uri;

  PlaylistModel({
    required this.collaborative,
    required this.description,
    required this.externalUrls,
    required this.followers,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    this.primaryColor,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory PlaylistModel.fromJson(Map<String, dynamic> json) {
    return PlaylistModel(
      collaborative: json['collaborative'] ?? false,
      description: json['description'] ?? '',
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      followers: Followers.fromJson(json['followers']),
      href: json['href'],
      id: json['id'],
      images: (json['images'] as List).map((image) => SpotifyImage.fromJson(image)).toList(),
      name: json['name'],
      owner: Owner.fromJson(json['owner']),
      primaryColor: json['primary_color'],
      public: json['public'] ?? false,
      snapshotId: json['snapshot_id'],
      tracks: PlaylistTracks.fromJson(json['tracks']),
      type: json['type'],
      uri: json['uri'],
    );
  }
}

class PlaylistTracks {
  final String href;
  final List<PlaylistItem> items;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;

  PlaylistTracks({
    required this.href,
    required this.items,
    required this.limit,
    this.next,
    required this.offset,
    this.previous,
    required this.total,
  });

  factory PlaylistTracks.fromJson(Map<String, dynamic> json) {
    return PlaylistTracks(
      href: json['href'],
     items: (json['items'] as List).map((item) => PlaylistItem.fromJson(item)).toList(),
      limit: json['limit'],
      next: json['next'],
      offset: json['offset'],
      previous: json['previous'],
      total: json['total'],
    );
  }
}

class PlaylistItem {
  final String? addedAt;
  final Owner ?addedBy;
  final bool? isLocal;
  final Track? track;

  PlaylistItem({
     this.addedAt,
    this.addedBy,
   this.isLocal,
     this.track,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json) {
    return PlaylistItem(
      addedAt: json['added_at'],
      addedBy: Owner.fromJson(json['added_by']),
      // isLocal: json['is_local'],
        track: Track.fromJson(json['track']),
    );
  }
}

class Owner {
  final String? displayName;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final String type;
  final String uri;

  Owner({
     this.displayName,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
    displayName: json['display_name'] as String?,
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}


