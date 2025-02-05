class SpotifyUser {
  String? country;
  String? displayName;
  String? email;
  ExplicitContent? explicitContent;
  ExternalUrls? externalUrls;
  Followers? followers;
  String? href;
  String? id;
  List<SpotifyImage>? images;
  String? product;
  String? type;
  String? uri;

  SpotifyUser({
    this.country,
    this.displayName,
    this.email,
    this.explicitContent,
    this.externalUrls,
    this.followers,
    this.href,
    this.id,
    this.images,
    this.product,
    this.type,
    this.uri,
  });


  void initialize(Map<String, dynamic> json) {
    country = json['country'] as String? ?? country;
    displayName = json['display_name'] as String? ?? displayName;
    email = json['email'] as String? ?? email;
    
    if (json['explicit_content'] != null) {
      explicitContent = explicitContent?.update(json['explicit_content']) 
          ?? ExplicitContent.fromJson(json['explicit_content']);
    }
    
    if (json['external_urls'] != null) {
      externalUrls = externalUrls?.update(json['external_urls']) 
          ?? ExternalUrls.fromJson(json['external_urls']);
    }
    
    if (json['followers'] != null) {
      followers = followers?.update(json['followers']) 
          ?? Followers.fromJson(json['followers']);
    }
    
    href = json['href'] as String? ?? href;
    id = json['id'] as String? ?? id;
    
    if (json['images'] != null) {
      images = (json['images'] as List)
          .map((i) => SpotifyImage.fromJson(i))
          .toList();
    }
    
    product = json['product'] as String? ?? product;
    type = json['type'] as String? ?? type;
    uri = json['uri'] as String? ?? uri;
  }

  factory SpotifyUser.fromJson(Map<String, dynamic> json) {
    return SpotifyUser(
      country: json['country'] as String?,
      displayName: json['display_name'] as String?,
      email: json['email'] as String?,
      explicitContent: json['explicit_content'] != null
          ? ExplicitContent.fromJson(json['explicit_content'])
          : null,
      externalUrls: json['external_urls'] != null
          ? ExternalUrls.fromJson(json['external_urls'])
          : null,
      followers: json['followers'] != null
          ? Followers.fromJson(json['followers'])
          : null,
      href: json['href'] as String?,
      id: json['id'] as String?,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((i) => SpotifyImage.fromJson(i))
              .toList()
          : null,
      product: json['product'] as String?,
      type: json['type'] as String?,
      uri: json['uri'] as String?,
    );
  }


  void printDetails() {
    print('Country: $country');
    print('Display Name: $displayName');
    print('Email: $email');
    print('Explicit Content: ${explicitContent?.toJson()}');
    print('External URLs: ${externalUrls?.toJson()}');
    print('Followers: ${followers?.toJson()}');
    print('Href: $href');
    print('ID: $id');
    print('Images: ${images?.map((i) => i.toJson()).toList()}');
    print('Product: $product');
    print('Type: $type');
    print('URI: $uri');
  }



  Map<String, dynamic> toJson() {
    return {
      'country': country,
      'display_name': displayName,
      'email': email,
      'explicit_content': explicitContent?.toJson(),
      'external_urls': externalUrls?.toJson(),
      'followers': followers?.toJson(),
      'href': href,
      'id': id,
      'images': images?.map((i) => i.toJson()).toList(),
      'product': product,
      'type': type,
      'uri': uri,
    };
  }
}



class ExplicitContent {
  bool? filterEnabled;
  bool? filterLocked;

  ExplicitContent({
    this.filterEnabled,
    this.filterLocked,
  });

  ExplicitContent update(Map<String, dynamic> json) {
    filterEnabled = json['filter_enabled'] as bool? ?? filterEnabled;
    filterLocked = json['filter_locked'] as bool? ?? filterLocked;
    return this;
  }

  factory ExplicitContent.fromJson(Map<String, dynamic> json) {
    return ExplicitContent(
      filterEnabled: json['filter_enabled'] as bool?,
      filterLocked: json['filter_locked'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter_enabled': filterEnabled,
      'filter_locked': filterLocked,
    };
  }
}

// Update ExternalUrls class
class ExternalUrls {
  String? spotify;

  ExternalUrls({
    this.spotify,
  });

  ExternalUrls update(Map<String, dynamic> json) {
    spotify = json['spotify'] as String? ?? spotify;
    return this;
  }

  factory ExternalUrls.fromJson(Map<String, dynamic> json) {
    return ExternalUrls(
      spotify: json['spotify'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'spotify': spotify,
    };
  }
}

// Update Followers class
class Followers {
  String? href;
  int? total;

  Followers({
    this.href,
    this.total,
  });

  Followers update(Map<String, dynamic> json) {
    href = json['href'] as String? ?? href;
    total = json['total'] as int? ?? total;
    return this;
  }

  factory Followers.fromJson(Map<String, dynamic> json) {
    return Followers(
      href: json['href'] as String?,
      total: json['total'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'total': total,
    };
  }
}

// Update SpotifyImage class
class SpotifyImage {
  int? height;
  String? url;
  int? width;

  SpotifyImage({
    this.height,
    this.url,
    this.width,
  });

  SpotifyImage update(Map<String, dynamic> json) {
    height = json['height'] as int? ?? height;
    url = json['url'] as String? ?? url;
    width = json['width'] as int? ?? width;
    return this;
  }

  factory SpotifyImage.fromJson(Map<String, dynamic> json) {
    return SpotifyImage(
      height: json['height'] as int?,
      url: json['url'] as String?,
      width: json['width'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'height': height,
      'url': url,
      'width': width,
    };
  }
}