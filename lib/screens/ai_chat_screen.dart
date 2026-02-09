import 'package:flutter/material.dart';

class AiChatScreen extends StatefulWidget {
  final String shopName;

  const AiChatScreen({Key? key, required this.shopName}) : super(key: key);

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = []; // Empty start
  bool _isTyping = false;

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({"sender": "User", "text": text});
      _isTyping = true;
    });
    _controller.clear();

    // Simulate Mocha Thinking
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isTyping = false;
          _messages.add({
            "sender": "Mocha", 
            "text": _getSimulatedResponse(text)
          });
        });
      }
    });
  }

  String _getSimulatedResponse(String question) {
    question = question.toLowerCase();
    if (question.contains("wifi") || question.contains("internet")) {
      return "The WiFi here is rated 4.5/5! 🚀 Speed tests show around 50Mbps.";
    } else if (question.contains("quiet") || question.contains("noise")) {
      return "It's generally quiet during the day, perfect for focus.";
    } else if (question.contains("best") || question.contains("recommend")) {
      return "You must try the **Spanish Latte**! 🥛 It's their bestseller.";
    } else {
      return "That's a great question about ${widget.shopName}! People generally love the vibe here.";
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. COLORS FROM YOUR DESIGN
    final Color sandColor = const Color(0xFFE5CF98); // The Background
    final Color darkBrown = const Color(0xFF795548); // The Text/Icons
    
    return Scaffold(
      backgroundColor: sandColor, // Solid Sand Background
      body: SafeArea(
        child: Column(
          children: [
            // --- HEADER (Back Button + KAPE4U Badge) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back Button
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: darkBrown),
                    onPressed: () => Navigator.pop(context),
                  ),
                  
                  // KAPE4U Badge (Top Center)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9E7F56), // Bronze/Gold badge
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: const [
                        Text(
                          "KAPE4U",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Courier',
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.coffee, color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                  
                  // Invisible Spacer to balance the row
                  const SizedBox(width: 48), 
                ],
              ),
            ),

            // --- MAIN CONTENT AREA ---
            Expanded(
              child: _messages.isEmpty 
                // A. EMPTY STATE (Show the Big "Mocha Here!" Card)
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Color(0xFF9E7F56), // Lighter Brown
                                Color(0xFF5D4037), // Dark Brown
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      "Mocha here!",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Your AI Caffeine companion. To find what to savor the most!",
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Location Pin Icon
                              const Icon(
                                Icons.location_on_rounded, 
                                size: 50, 
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                
                // B. CHAT MESSAGES (If user started chatting)
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final msg = _messages[index];
                      final isMe = msg['sender'] == "User";
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.white : const Color(0xFF5D4037),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            msg['text']!,
                            style: TextStyle(
                              color: isMe ? Colors.black87 : Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            ),

            // --- INPUT CAPSULE ---
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // The Brown "+" Button
                    Container(
                      height: 40,
                      width: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFF8D6E63), // Brown
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    
                    // Text Field
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: "Type a message.",
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}