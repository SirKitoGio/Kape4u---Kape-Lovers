import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/google_places_service.dart';
import '../models/coffee_shop.dart';
import 'coffee_detail_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GooglePlacesService _placesService = GooglePlacesService();
  List<CoffeeShop> _coffeeShops = [];
  Position? _currentPosition;
  bool _isLoading = true;
  CoffeeShop? _selectedShop;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Using Makati coordinates for testing
      setState(() {
        _currentPosition = Position(
          latitude: 14.5612,
          longitude: 121.0213,
          timestamp: DateTime.now(),
          accuracy: 1.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );
      });

      _loadCoffeeShops();
    } catch (e) {
      print('Error getting location: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadCoffeeShops() async {
    if (_currentPosition == null) return;

    // MOCK DATA - Makati coffee shopssudo spctl --master-disable

    setState(() {
      _coffeeShops = [
        CoffeeShop(
          placeId: '1',
          name: 'Odd Cafe',
          address: 'Salcedo Village, Makati City',
          latitude: 14.5566,
          longitude: 121.0187,
          rating: 4.7,
          userRatingsTotal: 892,
          types: ['cafe', 'coffee_shop'],
          openNow: true,
          priceLevel: '\$\$',
        ),
        CoffeeShop(
          placeId: '2',
          name: 'Yardstick Coffee',
          address: 'Salcedo Village, Makati City',
          latitude: 14.5562,
          longitude: 121.0192,
          rating: 4.8,
          userRatingsTotal: 1043,
          types: ['cafe', 'coffee_shop', 'specialty_coffee'],
          openNow: true,
          priceLevel: '\$\$',
        ),
        CoffeeShop(
          placeId: '3',
          name: 'Starbucks Greenbelt',
          address: 'Greenbelt 3, Makati City',
          latitude: 14.5528,
          longitude: 121.0200,
          rating: 4.5,
          userRatingsTotal: 1250,
          types: ['cafe', 'coffee_shop'],
          openNow: true,
          priceLevel: '\$\$',
        ),
        CoffeeShop(
          placeId: '4',
          name: 'The Coffee Bean & Tea Leaf',
          address: 'Ayala Avenue, Makati',
          latitude: 14.5558,
          longitude: 121.0244,
          rating: 4.3,
          userRatingsTotal: 890,
          types: ['cafe', 'coffee_shop'],
          openNow: true,
          priceLevel: '\$\$',
        ),
        CoffeeShop(
          placeId: '5',
          name: 'Tim Hortons BGC',
          address: 'Bonifacio Global City',
          latitude: 14.5507,
          longitude: 121.0494,
          rating: 4.2,
          userRatingsTotal: 567,
          types: ['cafe', 'coffee_shop'],
          openNow: false,
          priceLevel: '\$',
        ),
        CoffeeShop(
          placeId: '6',
          name: 'Bo\'s Coffee',
          address: 'Salcedo Village, Makati',
          latitude: 14.5570,
          longitude: 121.0185,
          rating: 4.6,
          userRatingsTotal: 432,
          types: ['cafe', 'coffee_shop'],
          openNow: true,
          priceLevel: '\$\$',
        ),
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Coffee Near You'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentPosition == null
              ? _buildLocationError()
              : Column(
                  children: [
                    _buildMapPlaceholder(),
                    if (_selectedShop != null) _buildSelectedShopCard(),
                    Expanded(child: _buildShopsList()),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        backgroundColor: const Color(0xFF6F4E37),
        child: const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }

  Widget _buildLocationError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.location_off, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('Location access required'),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _getCurrentLocation,
            child: const Text('Enable Location'),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map, size: 64, color: Colors.grey.shade600),
                const SizedBox(height: 8),
                Text(
                  'Google Maps View\n(Requires Maps SDK setup)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 16),
                if (_currentPosition != null)
                  Text(
                    '📍 Your Location: ${_currentPosition!.latitude.toStringAsFixed(4)}, ${_currentPosition!.longitude.toStringAsFixed(4)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedShopCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _selectedShop!.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                  '${_selectedShop!.rating} (${_selectedShop!.userRatingsTotal})'),
              const SizedBox(width: 16),
              Text(_selectedShop!.getDistanceText(
                _currentPosition?.latitude,
                _currentPosition?.longitude,
              )),
            ],
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CoffeeDetailScreen(shop: _selectedShop!),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F4E37),
            ),
            child: const Text('View Details'),
          ),
        ],
      ),
    );
  }

  Widget _buildShopsList() {
    if (_coffeeShops.isEmpty) {
      return const Center(child: Text('No coffee shops found nearby'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _coffeeShops.length,
      itemBuilder: (context, index) {
        final shop = _coffeeShops[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Color(0xFF6F4E37),
              child: Icon(Icons.coffee, color: Colors.white),
            ),
            title: Text(shop.name),
            subtitle: Text(
              '⭐ ${shop.rating} • ${shop.getDistanceText(_currentPosition?.latitude, _currentPosition?.longitude)}',
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              setState(() {
                _selectedShop = shop;
              });
            },
          ),
        );
      },
    );
  }
}
