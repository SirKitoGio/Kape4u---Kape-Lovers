import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  static const String apiKey = 'AIzaSyCBNbR0nFXoeE1uDtX0g6H3e2sgqeC52T4';
  late final GenerativeModel model;

  GeminiService() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: apiKey,
    );
  }

  // Generate a daily journaling prompt
  Future<String> generateDailyPrompt() async {
    final prompt = 'Generate a single thoughtful, inspiring journaling prompt that encourages self-reflection and personal growth. Keep it under 15 words.';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'What made today meaningful?';
    } catch (e) {
      return 'What are you grateful for today?';
    }
  }

  // Analyze mood from journal entry
  Future<String> analyzeMood(String entry) async {
    final prompt = 'Based on this journal entry, identify the primary emotion in one word: "$entry"';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text?.toLowerCase() ?? 'neutral';
    } catch (e) {
      return 'neutral';
    }
  }

  // Generate insights from journal entry
  Future<String> generateInsight(String entry) async {
    final prompt = 'Read this journal entry and provide a brief, supportive insight (2-3 sentences): "$entry"';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Thank you for sharing your thoughts.';
    } catch (e) {
      return 'Keep reflecting on your experiences.';
    }
  }

  // Suggest themes/tags for the entry
  Future<List<String>> suggestTags(String entry) async {
    final prompt = 'Based on this journal entry, suggest 3 relevant tags or themes (one word each, comma separated): "$entry"';
    
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      final tags = response.text?.split(',').map((e) => e.trim()).toList() ?? [];
      return tags.take(3).toList();
    } catch (e) {
      return ['reflection', 'thoughts', 'personal'];
    }
  }
}
