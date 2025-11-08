import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/coffee_shop.dart';

class GooglePlacesService {
  // TODO: Replace with your actual Google Places API key
  static const String apiKey = 'AIzaSyBRJUV_zRgED0Jn-mtuShLycg4hn9YTyP8';
  static const String baseUrl = 'https://maps.googleapis.com/maps/api/place';

  Future<List<CoffeeShop>> findCoffeeShopsNearby({
    required double latitude,
    required double longitude,
    int radius = 5000,
    String keyword = '',
  }) async {
    final keywordParam = keyword.isNotEmpty ? '+$keyword' : '';
    final url = Uri.parse(
      '$baseUrl/nearbysearch/json?location=$latitude,$longitude'
      '&radius=$radius&type=cafe&keyword=coffee$keywordParam&key=$apiKey',
    );
    print('Searching Google Places: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List;
        return results.map((json) => CoffeeShop.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load coffee shops');
      }
    } catch (e) {
      print('Error finding coffee shops: $e');
      return [];
    }
  }

  Future<List<CoffeeShop>> searchCoffeeShopsByArea(String area) async {
    final geocodeUrl = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?address=$area&key=$apiKey',
    );
    print('Searching geocode for area: $area, url: $geocodeUrl');

    try {
      final geoResponse = await http.get(geocodeUrl);

      if (geoResponse.statusCode == 200) {
        final geoData = jsonDecode(geoResponse.body);
        print('Geocode results: $geoData');

        if (geoData['results'].isNotEmpty) {
          final location = geoData['results'][0]['geometry']['location'];
          final lat = location['lat'];
          final lng = location['lng'];

          return findCoffeeShopsNearby(
            latitude: lat,
            longitude: lng,
            radius: 10000,
            keyword: area,
          );
        }
      }
      return [];
    } catch (e) {
      print('Error searching by area: $e');
      return [];
    }
  }

  Future<CoffeeShop?> getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      '$baseUrl/details/json?place_id=$placeId&fields=name,rating,formatted_address,reviews,geometry,photos,opening_hours,price_level&key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final result = data['result'];

        var shop = CoffeeShop.fromJson(result);

        if (result['reviews'] != null) {
          final reviews = (result['reviews'] as List)
              .map((r) => Review.fromJson(r))
              .toList();
          shop = CoffeeShop(
            placeId: shop.placeId,
            name: shop.name,
            address: shop.address,
            latitude: shop.latitude,
            longitude: shop.longitude,
            rating: shop.rating,
            userRatingsTotal: shop.userRatingsTotal,
            types: shop.types,
            photoReference: shop.photoReference,
            reviews: reviews,
            openNow: shop.openNow,
            priceLevel: shop.priceLevel,
          );
        }
        return shop;
      }
      return null;
    } catch (e) {
      print('Error getting place details: $e');
      return null;
    }
  }

  String getPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$baseUrl/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=$apiKey';
  }
}
