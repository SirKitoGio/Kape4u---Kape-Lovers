import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Center on Manila, Philippines
  final LatLng _center = const LatLng(14.5995, 120.9842);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. THE MAP LAYER
          FlutterMap(
            options: MapOptions(
              initialCenter: _center, // Start at Manila
              initialZoom: 15.0,      // Zoomed in to see streets
            ),
            children: [
              // The Map Tiles (Skin) - We use a light version to match your app
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kape4u.app',
              ),
              
              // The Markers (Pins)
              MarkerLayer(
                markers: [
                  _buildCustomMarker(14.5995, 120.9842, Icons.coffee, Colors.brown), // Standard Cafe
                  _buildCustomMarker(14.6010, 120.9810, Icons.star, Colors.amber),   // Top Rated
                  _buildCustomMarker(14.5980, 120.9860, Icons.local_offer, Colors.orange), // Promo
                ],
              ),
            ],
          ),

          // 2. SEARCH BAR (Floating at the top)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.brown),
                  SizedBox(width: 10),
                  Text("Find coffee near you...", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build your beautiful Custom Pins
  Marker _buildCustomMarker(double lat, double lng, IconData icon, Color color) {
    return Marker(
      point: LatLng(lat, lng),
      width: 50,
      height: 50,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF4E342E), // Dark Coffee Brown Background
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: color, // Gold for star, White for coffee
          size: 24,
        ),
      ),
    );
  }
}