import 'package:flutter/material.dart';
import '../services/kape_ai_service.dart';
import '../services/google_places_service.dart';
import '../models/coffee_shop.dart';
import 'coffee_detail_screen.dart';

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({Key? key}) : super(key: key);

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  final KapeAIService _aiService = KapeAIService();
  final GooglePlacesService _placesService = GooglePlacesService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  List<CoffeeShop>? _lastSearchResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  void _addWelcomeMessage() {
    _messages.add(ChatMessage(
      text: '''Hi! ☕ I'm your AI coffee companion. Ask me things like:

• "Where's the most aesthetic coffee shop in Makati?"
• "Find the best Spanish latte in BGC"
• "I need a quiet place to study"

What are you looking for?''',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> _handleUserMessage(String message) async {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        text: message,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();

    try {
      // Check if user is asking for coffee shops in a location
      final lowerMessage = message.toLowerCase();

      if (lowerMessage.contains('bgc') ||
          lowerMessage.contains('bonifacio') ||
          lowerMessage.contains('makati') ||
          lowerMessage.contains('salcedo')) {
        // Use mock coffee shop data
        final mockShops = [
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

        // Get AI recommendation based on mock shops
        final aiResponse = await _aiService.recommendCoffeeShops(
          userQuery: message,
          coffeeShops: mockShops,
        );

        setState(() {
          _lastSearchResults = mockShops;
          _messages.add(ChatMessage(
            text: aiResponse,
            isUser: false,
            timestamp: DateTime.now(),
            coffeeShops: mockShops,
          ));
          _isLoading = false;
        });
      } else {
        // General coffee question
        final response = await _aiService.answerCoffeeQuestion(message);

        setState(() {
          _messages.add(ChatMessage(
            text: response,
            isUser: false,
            timestamp: DateTime.now(),
          ));
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error: $e',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isLoading = false;
      });
    }

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Coffee Assistant'),
        backgroundColor: const Color(0xFF6F4E37),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _messages.clear();
                _lastSearchResults = null;
                _addWelcomeMessage();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(width: 16),
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  SizedBox(width: 12),
                  Text('AI is thinking...'),
                ],
              ),
            ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: message.isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser
                    ? const Color(0xFF6F4E37)
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black87,
                  fontSize: 15,
                ),
              ),
            ),
            if (message.coffeeShops != null && message.coffeeShops!.isNotEmpty)
              ...message.coffeeShops!.map((shop) => _buildCoffeeShopCard(shop)),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeShopCard(CoffeeShop shop) {
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF6F4E37),
          child: Icon(Icons.coffee, color: Colors.white, size: 20),
        ),
        title: Text(shop.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('⭐ ${shop.rating} • ${shop.address}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CoffeeDetailScreen(shop: shop),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask about coffee shops...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onSubmitted: _handleUserMessage,
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF6F4E37),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => _handleUserMessage(_messageController.text),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final List<CoffeeShop>? coffeeShops;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.coffeeShops,
  });
}
