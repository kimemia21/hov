class Device {
  final String id;
  final bool isActive;
  final bool isPrivateSession;
  final bool isRestricted;
  final String name;
  final bool supportsVolume;
  final String type;
  final int volumePercent;

  Device({
    required this.id,
    required this.isActive,
    required this.isPrivateSession,
    required this.isRestricted,
    required this.name,
    required this.supportsVolume,
    required this.type,
    required this.volumePercent,
  });

  factory Device.fromJson(Map<String, dynamic> json) {
    return Device(
      id: json['id'] ?? '',
      isActive: json['is_active'] ?? false,
      isPrivateSession: json['is_private_session'] ?? false,
      isRestricted: json['is_restricted'] ?? false,
      name: json['name'] ?? 'Unknown Device',
      supportsVolume: json['supports_volume'] ?? false,
      type: json['type'] ?? 'Unknown',
      volumePercent: json['volume_percent'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'is_active': isActive,
      'is_private_session': isPrivateSession,
      'is_restricted': isRestricted,
      'name': name,
      'supports_volume': supportsVolume,
      'type': type,
      'volume_percent': volumePercent,
    };
  }
}
