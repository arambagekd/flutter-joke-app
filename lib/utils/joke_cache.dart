import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String cachedJokesKey = 'cachedJokes';

Future<void> saveJokesToCache(List<Map<String, String>> jokes) async {
  final prefs = await SharedPreferences.getInstance();
  final jokesJson = json.encode(jokes);
  await prefs.setString(cachedJokesKey, jokesJson);
}

Future<List<Map<String, String>>> loadCachedJokes() async {
  final prefs = await SharedPreferences.getInstance();
  final jokesJson = prefs.getString(cachedJokesKey);

  if (jokesJson != null) {
    final jokesList = json.decode(jokesJson) as List;
    return jokesList.map((joke) => Map<String, String>.from(joke)).toList();
  }

  return [];
}
