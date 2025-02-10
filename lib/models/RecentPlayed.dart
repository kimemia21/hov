import 'package:spotifyplayer/models/UserAccount.dart';

class RecentlyPlayedResponse {
  final List<RecentlyPlayedItem> items;
  final String next;
  final Cursors cursors;
  final int limit;
  final String href;

  RecentlyPlayedResponse({
    required this.items,
    required this.next,
    required this.cursors,
    required this.limit,
    required this.href,
  });

  factory RecentlyPlayedResponse.fromJson(Map<String, dynamic> json) {
    print("this is the recent plays $json");
    return RecentlyPlayedResponse(
      items: (json['items'] as List)
          .map((item) => RecentlyPlayedItem.fromJson(item))
          .toList(),
      next: json['next'],
      cursors: Cursors.fromJson(json['cursors']),
      limit: json['limit'],
      href: json['href'],
    );
  }
}

class RecentlyPlayedItem {
  final Track track;
  final String playedAt;
  final Context context;

  RecentlyPlayedItem({
    required this.track,
    required this.playedAt,
    required this.context,
  });

  factory RecentlyPlayedItem.fromJson(Map<String, dynamic> json) {
    return RecentlyPlayedItem(
      track: Track.fromJson(json['track']),
      playedAt: json['played_at'],
      context: Context.fromJson(json['context']),
    );
  }
}

class Track {
  final Album album;
  final List<Artist> artists;
  final int discNumber;
  final int durationMs;
  final bool explicit;
  final ExternalIds externalIds;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final bool isLocal;
  final String name;
  final int popularity;
  final String? previewUrl;
  final int trackNumber;
  final String type;
  final String uri;

  Track({
    required this.album,
    required this.artists,
    required this.discNumber,
    required this.durationMs,
    required this.explicit,
    required this.externalIds,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.isLocal,
    required this.name,
    required this.popularity,
    this.previewUrl,
    required this.trackNumber,
    required this.type,
    required this.uri,
  });

  factory Track.fromJson(Map<String, dynamic> json) {

    return Track(
      album: Album.fromJson(json['album']),
      artists: (json['artists'] as List)
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      discNumber: json['disc_number'],
      durationMs: json['duration_ms'],
      explicit: json['explicit'],
      externalIds: ExternalIds.fromJson(json['external_ids']),
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      isLocal: json['is_local'],
      name: json['name'],
      popularity: json['popularity'],
      previewUrl: json['preview_url'],
      trackNumber: json['track_number'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}

class Album {
  final String albumType;
  final List<Artist> artists;
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final List<SpotifyImage> images;
  final String name;
  final String releaseDate;
  final String releaseDatePrecision;
  final int totalTracks;
  final String type;
  final String uri;

  Album({
    required this.albumType,
    required this.artists,
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.releaseDatePrecision,
    required this.totalTracks,
    required this.type,
    required this.uri,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      albumType: json['album_type'],
      artists: (json['artists'] as List)
          .map((artist) => Artist.fromJson(artist))
          .toList(),
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      images: (json['images'] as List)
          .map((image) => SpotifyImage.fromJson(image))
          .toList(),
      name: json['name'],
      releaseDate: json['release_date'],
      releaseDatePrecision: json['release_date_precision'],
      totalTracks: json['total_tracks'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}

class Artist {
  final ExternalUrls externalUrls;
  final String href;
  final String id;
  final String name;
  final String type;
  final String uri;

  Artist({
    required this.externalUrls,
    required this.href,
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory Artist.fromJson(Map<String, dynamic> json) {
    return Artist(
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      name: json['name'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}

class ExternalIds {
  final String isrc;

  ExternalIds({required this.isrc});

  factory ExternalIds.fromJson(Map<String, dynamic> json) {
    return ExternalIds(isrc: json['isrc']);
  }
}

class Context {
  final String type;
  final String href;
  final ExternalUrls externalUrls;
  final String uri;

  Context({
    required this.type,
    required this.href,
    required this.externalUrls,
    required this.uri,
  });

  factory Context.fromJson(Map<String, dynamic> json) {
    return Context(
      type: json['type'],
      href: json['href'],
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      uri: json['uri'],
    );
  }
}

class Cursors {
  final String after;
  final String before;

  Cursors({
    required this.after,
    required this.before,
  });

  factory Cursors.fromJson(Map<String, dynamic> json) {
    return Cursors(
      after: json['after'],
      before: json['before'],
    );
  }
}
