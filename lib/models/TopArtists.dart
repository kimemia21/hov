import 'package:spotifyplayer/models/UserAccount.dart';



class TopArtists {
  final ExternalUrls externalUrls;
  final Followers followers;
  final List<String> genres;
  final String href;
  final String id;
  final List<SpotifyImage> images;
  final String name;
  final int popularity;
  final String type;
  final String uri;

  TopArtists({
    required this.externalUrls,
    required this.followers,
    required this.genres,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.popularity,
    required this.type,
    required this.uri,
  });

  factory TopArtists.fromJson(Map<String, dynamic> json) {
    return TopArtists(
      externalUrls: ExternalUrls.fromJson(json['external_urls']),
      followers: Followers.fromJson(json['followers']),
      genres: json['genres'] == null 
          ? [] 
          : List<String>.from(json['genres']),
      href: json['href'],
      id: json['id'],
      images: (json['images'] as List)
          .map((image) => SpotifyImage.fromJson(image))
          .toList(),
      name: json['name'],
      popularity: json['popularity'],
      type: json['type'],
      uri: json['uri'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'external_urls': externalUrls.toJson(),
      'followers': followers.toJson(),
      'genres': genres,
      'href': href,
      'id': id,
      'images': images.map((image) => image.toJson()).toList(),
      'name': name,
      'popularity': popularity,
      'type': type,
      'uri': uri,
    };
  }
}

class TopArtistsResponse {
  final List<TopArtists> items;
  final int total;
  final int limit;
  final int offset;
  final String href;
  final String? next;
  final String? previous;

  TopArtistsResponse({
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    required this.href,
    this.next,
    this.previous,
  });

  factory TopArtistsResponse.fromJson(Map<String, dynamic> json) {
    return TopArtistsResponse(
      items: (json['items'] as List)
          .map((item) => TopArtists.fromJson(item))
          .toList(),
      total: json['total'],
      limit: json['limit'],
      offset: json['offset'],
      href: json['href'],
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'total': total,
      'limit': limit,
      'offset': offset,
      'href': href,
      'next': next,
      'previous': previous,
    };
  }
}