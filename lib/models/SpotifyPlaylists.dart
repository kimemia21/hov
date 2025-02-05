import 'package:spotifyplayer/models/UserAccount.dart';

class SpotifyPlaylistResponse {
  final String href;
  final int limit;
  final String? next;
  final int offset;
  final String? previous;
  final int total;
  final List<SpotifyPlaylist>items;

  SpotifyPlaylistResponse({
    required this.href,
    required this.limit,
    required this.next,
    required this.offset,
    required this.previous,
    required this.total,
    required this.items,
  });

  factory SpotifyPlaylistResponse.fromJson(Map<String, dynamic> json) {
    return SpotifyPlaylistResponse(
      href: json['href'] ?? '',
      limit: json['limit'] ?? 0,
      next: json['next'],
      offset: json['offset'] ?? 0,
      previous: json['previous'],
      total: json['total'] ?? 0,
      items: (json['items'] as List?)
              ?.map((item) => SpotifyPlaylist.fromJson(item))
              .toList() ??
          [],
    );
  }
}

class SpotifyPlaylist {
  final bool collaborative;
  final String description;
  final Map<String, String> externalUrls;
  final String href;
  final String id;
  final List<SpotifyImage> images;
  final String name;
  final PlaylistOwner owner;
  final String? primaryColor;
  final bool public;
  final String snapshotId;
  final PlaylistTracks tracks;
  final String type;
  final String uri;

  SpotifyPlaylist({
    required this.collaborative,
    required this.description,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.owner,
    required this.primaryColor,
    required this.public,
    required this.snapshotId,
    required this.tracks,
    required this.type,
    required this.uri,
  });

  factory SpotifyPlaylist.fromJson(Map<String, dynamic> json) {
    return SpotifyPlaylist(
      collaborative: json['collaborative'] ?? false,
      description: json['description'] ?? '',
      externalUrls: Map<String, String>.from(json['external_urls'] ?? {}),
      href: json['href'] ?? '',
      id: json['id'] ?? '',
      images: (json['images'] as List?)
              ?.map((image) => SpotifyImage.fromJson(image))
              .toList() ??
          [],
      name: json['name'] ?? '',
      owner: PlaylistOwner.fromJson(json['owner'] ?? {}),
      primaryColor: json['primary_color'],
      public: json['public'] ?? false,
      snapshotId: json['snapshot_id'] ?? '',
      tracks: PlaylistTracks.fromJson(json['tracks'] ?? {}),
      type: json['type'] ?? '',
      uri: json['uri'] ?? '',
    );
  }
}

class PlaylistOwner {
  final String displayName;
  final Map<String, String> externalUrls;
  final String href;
  final String id;
  final String type;
  final String uri;

  PlaylistOwner({
    required this.displayName,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.type,
    required this.uri,
  });

  factory PlaylistOwner.fromJson(Map<String, dynamic> json) {
    return PlaylistOwner(
      displayName: json['display_name'] ?? '',
      externalUrls: Map<String, String>.from(json['external_urls'] ?? {}),
      href: json['href'] ?? '',
      id: json['id'] ?? '',
      type: json['type'] ?? '',
      uri: json['uri'] ?? '',
    );
  }
}

class PlaylistTracks {
  final String href;
  final int total;

  PlaylistTracks({
    required this.href,
    required this.total,
  });

  factory PlaylistTracks.fromJson(Map<String, dynamic> json) {
    return PlaylistTracks(
      href: json['href'] ?? '',
      total: json['total'] ?? 0,
    );
  }
}