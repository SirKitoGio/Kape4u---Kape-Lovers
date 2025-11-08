import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/google_places_service.dart';
import '../models/coffee_shop.dart';
import 'coffee_detail_screen.dart';
import 'dart:math' show asin, sqrt, cos;  

class CoffeeListScreen extends StatefulWidget {
  const CoffeeListScreen({Key? key}) : super(key: key);

  @override
  State<CoffeeListScreen> createState() => _CoffeeListScreenState();
}

class _CoffeeListScreenState extends State<CoffeeListScreen> {
  final GooglePlacesService _placesService = GooglePlacesService();
  final TextEditingController _searchController = TextEditingController();
  List<CoffeeShop> _coffeeShops = [];
  Position? _currentPosition;
  bool _isLoading = true;
  String _sortBy = 'rating'; // rating, distance

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() => _currentPosition = position);

      final shops = await _placesService.findCoffeeShopsNearby(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      setState(() {
        _coffeeShops = shops;
        _isLoading = false;
      });
      _sortShops();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchArea(String area) async {
    if (area.isEmpty) return;

    setState(() => _isLoading = true);

    final shops = await _placesService.searchCoffeeShopsByArea(area);

    setState(() {
      _coffeeShops = shops;
      _isLoading = false;
    });
    _sortShops();
  }

  void _sortShops() {
    setState(() {
      if (_sortBy == 'rating') {
        _coffeeShops.sort((a, b) => b.rating.compareTo(a.rating));
      } else if (_sortBy == 'distance' && _currentPosition != null) {
        _coffeeShops.sort((a, b) {
          final distA = _calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            a.latitude,
            a.longitude,
          );
          final distB = _calculateDistance(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            b.latitude,
            b.longitude,
          );
          return distA.compareTo(distB);
        });
      }
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  final a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) *
      (1 - cos((lon2 - lon1) * p)) / 2;
  return (12742 * asin(sqrt(a))).toDouble();
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Browse Coffee Shops'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildSortButtons(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _coffeeShops.isEmpty
                    ? _buildEmptyState()
                    : _buildCoffeeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFFF5F5DC),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search area (e.g., Makati, BGC)',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              _loadData();
            },
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: _searchArea,
      ),
    );
  }

  Widget _buildSortButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Text('Sort by: ',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Rating'),
            selected: _sortBy == 'rating',
            onSelected: (selected) {
              if (selected) {
                setState(() => _sortBy = 'rating');
                _sortShops();
              }
            },
            selectedColor: const Color(0xFF6F4E37),
            labelStyle: TextStyle(
              color: _sortBy == 'rating' ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          ChoiceChip(
            label: const Text('Distance'),
            selected: _sortBy == 'distance',
            onSelected: (selected) {
              if (selected) {
                setState(() => _sortBy = 'distance');
                _sortShops();
              }
            },
            selectedColor: const Color(0xFF6F4E37),
            labelStyle: TextStyle(
              color: _sortBy == 'distance' ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No coffee shops found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching a different area',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildCoffeeList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _coffeeShops.length,
      itemBuilder: (context, index) {
        final shop = _coffeeShops[index];
        return _buildCoffeeCard(shop);
      },
    );
  }

  Widget _buildCoffeeCard(CoffeeShop shop) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeDetailScreen(shop: shop),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo placeholder
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF6F4E37).withOpacity(0.1),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: Center(
                child: Icon(
                  Icons.coffee,
                  size: 48,
                  color: const Color(0xFF6F4E37).withOpacity(0.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${shop.rating}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' (${shop.userRatingsTotal} reviews)'),
                      const Spacer(),
                      if (shop.priceLevel != null)
                        Text(
                          shop.priceLevel!,
                          style: const TextStyle(
                            color: Color(0xFF6F4E37),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          shop.address,
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 12),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  if (_currentPosition != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '📍 ${shop.getDistanceText(_currentPosition?.latitude, _currentPosition?.longitude)}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6F4E37)),
                    ),
                  ],
                  if (shop.openNow != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: shop.openNow!
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        shop.openNow! ? '🟢 Open Now' : '🔴 Closed',
                        style: TextStyle(
                          fontSize: 12,
                          color: shop.openNow!
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
