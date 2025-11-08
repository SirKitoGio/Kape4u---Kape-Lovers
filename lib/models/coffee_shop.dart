import 'dart:math' show asin, sqrt, cos;

class CoffeeShop {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int userRatingsTotal;
  final List<String> types;
  final String? photoReference;
  final List<Review> reviews;
  final bool? openNow;
  final String? priceLevel;

  CoffeeShop({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.userRatingsTotal,
    required this.types,
    this.photoReference,
    this.reviews = const [],
    this.openNow,
    this.priceLevel,
  });

  factory CoffeeShop.fromJson(Map<String, dynamic> json) {
    return CoffeeShop(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['vicinity'] ?? json['formatted_address'] ?? '',
      latitude: json['geometry']['location']['lat'] ?? 0.0,
      longitude: json['geometry']['location']['lng'] ?? 0.0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      userRatingsTotal: json['user_ratings_total'] ?? 0,
      types: List<String>.from(json['types'] ?? []),
      photoReference: json['photos'] != null && json['photos'].isNotEmpty 
          ? json['photos'][0]['photo_reference'] 
          : null,
      openNow: json['opening_hours']?['open_now'],
      priceLevel: _getPriceLevel(json['price_level']),
    );
  }

  static String? _getPriceLevel(int? level) {
    if (level == null) return null;
    return '\$' * level;
  }

  String getDistanceText(double? userLat, double? userLng) {
    if (userLat == null || userLng == null) return '';
    final distance = _calculateDistance(userLat, userLng, latitude, longitude);
    return distance < 1 
        ? '${(distance * 1000).toInt()}m away' 
        : '${distance.toStringAsFixed(1)}km away';
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 - 
        cos((lat2 - lat1) * p) / 2 + 
        cos(lat1 * p) * cos(lat2 * p) * 
        (1 - cos((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class Review {
  final String author;
  final double rating;
  final String text;
  final int time;

  Review({
    required this.author,
    required this.rating,
    required this.text,
    required this.time,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      author: json['author_name'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      text: json['text'] ?? '',
      time: json['time'] ?? 0,
    );
  }

  String getTimeAgo() {
    final now = DateTime.now();
    final reviewDate = DateTime.fromMillisecondsSinceEpoch(time * 1000);
    final difference = now.difference(reviewDate);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} years ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else {
      return 'Recently';
    }
  }
}
