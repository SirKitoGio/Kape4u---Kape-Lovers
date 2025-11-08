import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://codekada.jagempes.com';
  
  // Test connection to your server
  Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Connected to server successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Server returned status: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Connection failed: $e'
      };
    }
  }
  
  // Save journal entry to server
  Future<Map<String, dynamic>> saveJournalEntry({
    required String title,
    required String content,
    required String mood,
    List<String>? tags,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/journal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'content': content,
          'mood': mood,
          'tags': tags ?? [],
          'timestamp': DateTime.now().toIso8601String(),
        }),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to save: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error saving entry: $e'
      };
    }
  }
  
  // Fetch all journal entries from server
  Future<List<dynamic>> getJournalEntries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/journal'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        throw Exception('Failed to load entries');
      }
    } catch (e) {
      print('Error fetching entries: $e');
      return [];
    }
  }
  
  // Get AI-generated prompt from your server
  Future<String> getAIPrompt() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/prompt'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['prompt'] ?? 'What made today special?';
      } else {
        return 'How are you feeling today?';
      }
    } catch (e) {
      return 'What are you grateful for?';
    }
  }
}
