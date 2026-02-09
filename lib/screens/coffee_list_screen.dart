import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../models/coffee_shop.dart';
import '../services/api_service.dart'; // Import the service
import 'coffee_detail_screen.dart';

class CoffeeListScreen extends StatefulWidget {
  const CoffeeListScreen({Key? key}) : super(key: key);

  @override
  State<CoffeeListScreen> createState() => _CoffeeListScreenState();
}

class _CoffeeListScreenState extends State<CoffeeListScreen> {
  List<CoffeeShop> _coffeeShops = [];
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // CALL THE API
  Future<void> _loadData() async {
    try {
      final shops = await ApiService.getCoffeeShops();
      setState(() {
        _coffeeShops = shops;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() => _isLoading = false); // Stop loading even if error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // --- HEADER SECTION (Keep your existing header code here) ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFC69C6D),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: const [
                            Text("KAPE4U", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Courier')),
                            SizedBox(width: 4),
                            Icon(Icons.coffee, color: Colors.white, size: 16),
                          ],
                        ),
                      ),
                      Row(
                        children: const [
                          Icon(Icons.settings_outlined, color: Colors.brown, size: 28),
                          SizedBox(width: 15),
                          Icon(Icons.chat_bubble_outline, color: Colors.brown, size: 26),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Text("Trending Cafés", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
                          SizedBox(width: 8),
                          Icon(Icons.local_fire_department, color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // --- GRID SECTION ---
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Colors.brown)) // LOADING SPINNER
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: MasonryGridView.count(
                      padding: const EdgeInsets.only(bottom: 100),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      itemCount: _coffeeShops.length,
                      itemBuilder: (context, index) {
                        return _buildImmersiveCard(_coffeeShops[index], index);
                      },
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImmersiveCard(CoffeeShop shop, int index) {
    final double randomHeight = (index % 2 == 0) ? 280 : 220;
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CoffeeDetailScreen(shop: shop)),
        );
      },
      child: Container(
        height: randomHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.grey.shade200,
          image: DecorationImage(
            image: NetworkImage(shop.image), // Using the API image
            fit: BoxFit.cover,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.brown.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: 0, left: 0, right: 0, height: 120,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16, left: 16, right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      Text(" ${shop.rating}", style: const TextStyle(color: Colors.white, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}