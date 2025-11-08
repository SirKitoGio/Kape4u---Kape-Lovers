import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/coffee_shop.dart';
import '../services/google_places_service.dart';

class CoffeeDetailScreen extends StatefulWidget {
  final CoffeeShop shop;

  const CoffeeDetailScreen({Key? key, required this.shop}) : super(key: key);

  @override
  State<CoffeeDetailScreen> createState() => _CoffeeDetailScreenState();
}

class _CoffeeDetailScreenState extends State<CoffeeDetailScreen> {
  final GooglePlacesService _placesService = GooglePlacesService();
  CoffeeShop? _detailedShop;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final details = await _placesService.getPlaceDetails(widget.shop.placeId);
    setState(() {
      _detailedShop = details ?? widget.shop;
      _isLoading = false;
    });
  }

  Future<void> _openMaps() async {
    final url =
        'https://www.google.com/maps/search/?api=1&query=${widget.shop.latitude},${widget.shop.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final shop = _detailedShop ?? widget.shop;

    return Scaffold(
      appBar: AppBar(
        title: Text(shop.name),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // TODO: Add to favorites
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroImage(),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(shop),
                        const SizedBox(height: 16),
                        _buildActionButtons(),
                        const SizedBox(height: 24),
                        _buildInfoSection(shop),
                        const SizedBox(height: 24),
                        if (shop.reviews.isNotEmpty) _buildReviewsSection(shop),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeroImage() {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF6F4E37).withOpacity(0.1),
      ),
      child: const Center(
        child: Icon(Icons.coffee, size: 80, color: Color(0xFF6F4E37)),
      ),
    );
  }

  Widget _buildHeader(CoffeeShop shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          shop.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              '${shop.rating}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              ' (${shop.userRatingsTotal} reviews)',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const Spacer(),
            if (shop.priceLevel != null)
              Text(
                shop.priceLevel!,
                style: const TextStyle(
                  fontSize: 18,
                  color: Color(0xFF6F4E37),
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.location_on, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                shop.address,
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
          ],
        ),
        if (shop.openNow != null) ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: shop.openNow! ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: shop.openNow! ? Colors.green : Colors.red,
                width: 1,
              ),
            ),
            child: Text(
              shop.openNow! ? '🟢 Open Now' : '🔴 Closed',
              style: TextStyle(
                color: shop.openNow!
                    ? Colors.green.shade700
                    : Colors.red.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _openMaps,
            icon: const Icon(Icons.directions),
            label: const Text('Directions'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6F4E37),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              // TODO: Implement call
            },
            icon: const Icon(Icons.phone),
            label: const Text('Call'),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF6F4E37),
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Color(0xFF6F4E37)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoSection(CoffeeShop shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildInfoRow(Icons.category, 'Type', shop.types.take(3).join(', ')),
        if (shop.priceLevel != null)
          _buildInfoRow(Icons.attach_money, 'Price Level', shop.priceLevel!),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF6F4E37)),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text(value, style: TextStyle(color: Colors.grey.shade700)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection(CoffeeShop shop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...shop.reviews.take(5).map((review) => _buildReviewCard(review)),
      ],
    );
  }

  Widget _buildReviewCard(Review review) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xFF6F4E37),
                  child: Text(
                    review.author[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.author,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (index) => Icon(
                              index < review.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            review.getTimeAgo(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(review.text, style: TextStyle(color: Colors.grey.shade800)),
          ],
        ),
      ),
    );
  }
}
