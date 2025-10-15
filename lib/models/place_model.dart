class PlaceModel {
  final String id;
  final String name;
  final String category;
  final double latitude;
  final double longitude;
  final String? address;
  final String? phone;
  final double? rating;
  final int? reviewCount;
  final String? imageUrl;
  final List<String>? photos;
  final bool isOpen;
  final String? openingHours;
  final double? distance;
  final int? estimatedTime;
  final bool isFavorite;

  PlaceModel({
    required this.id,
    required this.name,
    required this.category,
    required this.latitude,
    required this.longitude,
    this.address,
    this.phone,
    this.rating,
    this.reviewCount,
    this.imageUrl,
    this.photos,
    this.isOpen = true,
    this.openingHours,
    this.distance,
    this.estimatedTime,
    this.isFavorite = false,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) {
    return PlaceModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      address: json['address'],
      phone: json['phone'],
      rating: json['rating']?.toDouble(),
      reviewCount: json['reviewCount'],
      imageUrl: json['imageUrl'],
      photos: json['photos'] != null
          ? List<String>.from(json['photos'])
          : null,
      isOpen: json['isOpen'] ?? true,
      openingHours: json['openingHours'],
      distance: json['distance']?.toDouble(),
      estimatedTime: json['estimatedTime'],
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'phone': phone,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'photos': photos,
      'isOpen': isOpen,
      'openingHours': openingHours,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'isFavorite': isFavorite,
    };
  }

  PlaceModel copyWith({
    String? id,
    String? name,
    String? category,
    double? latitude,
    double? longitude,
    String? address,
    String? phone,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    List<String>? photos,
    bool? isOpen,
    String? openingHours,
    double? distance,
    int? estimatedTime,
    bool? isFavorite,
  }) {
    return PlaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      photos: photos ?? this.photos,
      isOpen: isOpen ?? this.isOpen,
      openingHours: openingHours ?? this.openingHours,
      distance: distance ?? this.distance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
