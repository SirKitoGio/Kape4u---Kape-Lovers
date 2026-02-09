class CoffeeShop {
  final String placeId;
  final String name;
  final String address;
  final String description;
  final double rating;
  final int userRatingsTotal;
  final String image; // Simplified from photoReference

  CoffeeShop({
    required this.placeId,
    required this.name,
    required this.address,
    required this.description,
    required this.rating,
    required this.userRatingsTotal,
    required this.image,
  });

  // FACTORY: This converts the JSON from the internet into a Dart Object
  factory CoffeeShop.fromJson(Map<String, dynamic> json) {
    return CoffeeShop(
      placeId: json['placeId'] ?? '0',
      name: json['name'] ?? 'Unknown Cafe',
      address: json['address'] ?? 'Manila',
      description: json['description'] ?? 'No description available.',
      rating: (json['rating'] ?? 0.0).toDouble(),
      userRatingsTotal: json['userRatingsTotal'] ?? 0,
      image: json['image'] ?? 'https://api.npoint.io/953190699f71a62784d3',
    );
  }
}