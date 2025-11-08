import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/coffee_shop.dart';

// ==============
// MAIN SERVICE
// ==============
class KapeAIService {
  static const String apiKey = 'AIzaSyDe54o2J0foVKibhdvfIk2XMK1V9Ktmzh8';
  late final GenerativeModel model;
  late final GenerativeModel visionModel;

  KapeAIService() {
    model = GenerativeModel(
      model: 'models/gemini-2.5-flash',
      apiKey: apiKey,
    );

    visionModel = GenerativeModel(
      model: 'models/gemini-2.5-flash',
      apiKey: apiKey,
    );
  }

  Future<String> recommendCoffeeShops({
    required String userQuery,
    required List<CoffeeShop> coffeeShops,
  }) async {
    final shopsContext = coffeeShops.map((shop) {
      final reviewsText = shop.reviews
          .take(3)
          .map((r) => '"${r.text}" - ${r.author}')
          .join('\n');
      return '''
Shop: ${shop.name}
Rating: ${shop.rating}/5 (${shop.userRatingsTotal} reviews)
Address: ${shop.address}
Recent Reviews:
$reviewsText
---
''';
    }).join('\n');

    final prompt = '''
You are a helpful coffee shop recommendation assistant. A user is asking: "$userQuery"

Here are the available coffee shops in the area with their reviews:

$shopsContext

Based on the user's query and the reviews, recommend the TOP 3 coffee shops that best match what they're looking for. 

For each recommendation:
1. Explain WHY it matches their criteria (use specific quotes from reviews)
2. Include the rating
3. Mention standout features

Format your response in a friendly, conversational way. Keep it concise but helpful.
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ??
          'Sorry, I couldn\'t analyze the coffee shops right now.';
    } catch (e) {
      return 'Error getting recommendations: $e';
    }
  }

  Future<String> answerCoffeeQuestion(String question) async {
    final prompt = '''
You are a knowledgeable barista and coffee expert. Answer this question helpfully:

"$question"

Keep your answer friendly, concise, and informative. If it's about finding coffee shops, ask the user to specify their location.
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Sorry, I couldn\'t answer that right now.';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> analyzeImage(Uint8List imageBytes) async {
    try {
      final response = await visionModel.generateContent([
        Content.multi([
          TextPart(
              'Describe this coffee shop. What\'s the vibe, aesthetic, and atmosphere? Is it cozy, modern, industrial, minimalist, or vintage? What makes it special?'),
          DataPart('image/jpeg', imageBytes),
        ])
      ]);
      return response.text ?? 'Could not analyze image';
    } catch (e) {
      return 'Error analyzing image: $e';
    }
  }

  Future<String> getPersonalizedSuggestions({
    required List<String> userPreferences,
    required List<CoffeeShop> coffeeShops,
  }) async {
    final preferencesText = userPreferences.join(', ');
    final shopsText = coffeeShops.map((s) => s.name).join(', ');

    final prompt = '''
The user likes: $preferencesText

Available coffee shops: $shopsText

Based on their preferences, which coffee shop would you recommend and why? Keep it brief (2-3 sentences).
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'No recommendations available';
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String> compareCoffeeShops({
    required CoffeeShop shop1,
    required CoffeeShop shop2,
  }) async {
    final prompt = '''
Compare these two coffee shops:

**${shop1.name}**
- Rating: ${shop1.rating}/5 (${shop1.userRatingsTotal} reviews)
- Address: ${shop1.address}

**${shop2.name}**
- Rating: ${shop2.rating}/5 (${shop2.userRatingsTotal} reviews)
- Address: ${shop2.address}

Which one would you recommend for:
1. Best coffee quality
2. Best ambiance for studying
3. Best Instagram photos

Keep it concise.
''';

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Could not compare';
    } catch (e) {
      return 'Error: $e';
    }
  }
}
