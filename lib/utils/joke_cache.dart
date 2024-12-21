import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String cachedJokesKey = 'cachedJokes';

/// Save jokes to cache as JSON
Future<void> saveJokesToCache(List<Map<String, String>> jokes) async {
  final prefs = await SharedPreferences.getInstance();
  final jokesJson = json.encode(jokes);
  await prefs.setString(cachedJokesKey, jokesJson);
}

/// Load jokes from cache and parse them
Future<List<Map<String, String>>> loadCachedJokes() async {
  final prefs = await SharedPreferences.getInstance();
  final jokesJson = prefs.getString(cachedJokesKey);

  if (jokesJson != null) {
    final jokesList = json.decode(jokesJson) as List;
    return jokesList.map((joke) => Map<String, String>.from(joke)).toList();
  }

  return [];
}
