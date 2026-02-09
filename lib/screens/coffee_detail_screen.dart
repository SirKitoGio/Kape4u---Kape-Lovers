import 'package:flutter/material.dart';
import '../models/coffee_shop.dart';
import 'ai_chat_screen.dart';

class CoffeeDetailScreen extends StatelessWidget {
  final CoffeeShop shop;

  const CoffeeDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 1. THE COLOR PALETTE
    final Color creamBackground = const Color(0xFFFFF8E1);
    final Color darkBrown = const Color(0xFF3E2723);
    final Color lightBrown = const Color(0xFFD7CCC8);

    // FIX: Use 'shop.image' directly from the API
    final List<String> galleryImages = [
      shop.image, 
      'https://images.unsplash.com/photo-1509042239860-f550ce710b93', 
      'https://images.unsplash.com/photo-1511920170033-f8396924c348', 
    ];

    return Scaffold(
      backgroundColor: creamBackground,
      appBar: AppBar(
        backgroundColor: creamBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: darkBrown, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
             Text(
              shop.name,
              style: TextStyle(
                color: darkBrown,
                fontWeight: FontWeight.bold,
                fontSize: 20,
                fontFamily: 'Serif', 
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PHOTO STACK
            ...galleryImages.map((url) => Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.network(
                  url,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(height: 250, color: lightBrown),
                ),
              ),
            )).toList(),

            const SizedBox(height: 10),
            
            // DESCRIPTION FROM API
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                shop.description, // <--- NOW USES API DESCRIPTION
                style: TextStyle(color: Colors.brown.shade900, height: 1.5),
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => AiChatScreen(shopName: shop.name)));
                },
                icon: const Icon(Icons.auto_awesome, color: Colors.white),
                label: const Text("Ask Mocha"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBrown,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}