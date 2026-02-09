import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({Key? key}) : super(key: key);

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  List<Map<String, dynamic>> _promos = [];
  bool _isLoading = true;
  
  // This controller allows the "Next Card" to peek in from the right side
  final PageController _pageController = PageController(viewportFraction: 0.85);

  // Temporary list of images to make the design look good immediately
  final List<String> _promoImages = [
    'https://images.unsplash.com/photo-1511920170033-f8396924c348?w=800',
    'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd?w=800',
    'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800',
    'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=800',
  ];

  @override
  void initState() {
    super.initState();
    _loadPromos();
  }

  Future<void> _loadPromos() async {
    final data = await ApiService.getPromos();
    if (mounted) {
      setState(() {
        _promos = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Colors from your image
    final Color creamBackground = const Color(0xFFFFF8E1); // Light cream
    final Color darkBrown = const Color(0xFF3E2723);

    return Scaffold(
      backgroundColor: Colors.white, // White bg to match the clean look
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false, // Left align as per design
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today 2026",
              style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text(
                  "Discounted Coffee Deals",
                  style: TextStyle(
                    color: darkBrown,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.confirmation_number_outlined, color: Colors.brown, size: 20),
              ],
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.brown))
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _promos.length,
                itemBuilder: (context, index) {
                  final promo = _promos[index];
                  // Cycle through our fake images
                  final String image = _promoImages[index % _promoImages.length];

                  return _buildModernPromoCard(promo, image);
                },
              ),
            ),
    );
  }

  Widget _buildModernPromoCard(Map<String, dynamic> promo, String imageUrl) {
    return Container(
      margin: const EdgeInsets.only(right: 16, bottom: 20), // Spacing between cards
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // 1. The Glass/Gradient Overlay (To make text readable)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            top: 150, // Starts partially down to show image at top
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.0), // Transparent at top
                    Colors.white.withOpacity(0.5), // Foggy middle
                    Colors.white.withOpacity(0.9), // Solid white at bottom
                    Colors.white,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          ),

          // 2. The Text Content
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title (e.g., PICK UP COFFEE)
                Text(
                  (promo['title'] ?? "PROMO").toUpperCase(),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4E342E), // Dark Brown
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 20),

                // Label 1
                _buildLabel("PROMO TYPE"),
                Text(
                  promo['code'] ?? "Discount",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Label 2
                _buildLabel("DISCOUNT/ VALUE DETAILS"),
                Text(
                  promo['subtitle'] ?? "See details in store",
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 16),

                // Label 3
                _buildLabel("AREA"),
                Text(
                  "Makati, Mandaluyong, Pasig, Manila", // Hardcoded for style or add to JSON later
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(
          color: const Color(0xFF8D6E63), // Light Brown Label
          fontWeight: FontWeight.bold,
          fontSize: 12,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}