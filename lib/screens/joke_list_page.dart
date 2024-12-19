import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/joke_item.dart';
import '../utils/joke_cache.dart';

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key, required this.title});

  final String title;

  @override
  State<JokeListPage> createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage> {
  List<Map<String, String>> _cachedJokes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCachedJokes();
    _fetchJokes();
  }

  Future<void> _loadCachedJokes() async {
    final cachedJokes = await loadCachedJokes();
    setState(() {
      _cachedJokes = cachedJokes;
    });
  }

  Future<void> _fetchJokes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://official-joke-api.appspot.com/jokes/ten'),
      );

      if (response.statusCode == 200) {
        final jokes = json.decode(response.body) as List;
        final formattedJokes = jokes.map((joke) {
          String setup = joke['setup'];
          String punchline = joke['punchline'];

          if (setup.contains('?')) {
            final parts = setup.split('?');
            setup = '${parts[0]}?';
          }

          return {'setup': setup, 'punchline': punchline};
        }).toList();

        await saveJokesToCache(formattedJokes);
        setState(() {
          _cachedJokes = formattedJokes;
        });
      }
    } catch (e) {
      if (_cachedJokes.isEmpty) {
        setState(() {
          _cachedJokes = [{'setup': 'No jokes available', 'punchline': 'Oops!'}];
        });
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchJokes,
            tooltip: 'Refresh Jokes',
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshIndicator(
            onRefresh: _fetchJokes,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _cachedJokes.isEmpty
                ? const Center(
              child: Text(
                'No jokes available... Oops!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
              itemCount: _cachedJokes.length,
              itemBuilder: (context, index) {
                final joke = _cachedJokes[index];
                return JokeItem(joke: joke);
              },
            ),
          ),
        ],
      ),
    );
  }
}
