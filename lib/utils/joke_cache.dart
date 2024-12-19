import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveJokesToCache(List<Map<String, String>> jokes) async {
  final prefs = await SharedPreferences.getInstance();
  final updatedJokes = jokes.length > 5 ? jokes.sublist(0, 5) : jokes;
  await prefs.setString('jokes', json.encode(updatedJokes));
}

Future<List<Map<String, String>>> loadCachedJokes() async {
  final prefs = await SharedPreferences.getInstance();
  final cachedJokes = prefs.getString('jokes');
  if (cachedJokes != null) {
    return List<Map<String, String>>.from(json.decode(cachedJokes));
  }
  return [];
}
