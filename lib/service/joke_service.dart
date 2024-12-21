import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/joke.dart';

class JokeService {
  static const _jokesApiUrl = 'https://official-joke-api.appspot.com/jokes/ten';

  /// Fetch jokes from the API
  Future<List<Joke>> fetchJokes() async {
    try {
      final response = await http.get(Uri.parse(_jokesApiUrl));
      if (response.statusCode == 200) {
        final jokes = json.decode(response.body) as List;
        return jokes.take(5).map((joke) => Joke.fromJson(joke)).toList();
      } else {
        throw Exception('Failed to load jokes');
      }
    } catch (e) {
      throw Exception('Error fetching jokes: $e');
    }
  }
}
