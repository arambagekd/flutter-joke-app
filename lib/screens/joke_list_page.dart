import 'package:flutter/material.dart';
import '../models/joke.dart';
import '../service/joke_service.dart';
import '../utils/joke_cache.dart';
import '../widgets/joke_item.dart';

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key, required this.title});

  final String title;

  @override
  State<JokeListPage> createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage> {
  List<Joke> _cachedJokes = [];
  final JokeService _jokeService = JokeService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCachedJokes();
    _fetchJokes();
  }

  Future<void> _loadCachedJokes() async {
    final cachedJokesJson = await loadCachedJokes();
    setState(() {
      _cachedJokes = cachedJokesJson.map((j) => Joke.fromJson(j)).toList();
    });
  }

  Future<void> _fetchJokes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jokes = await _jokeService.fetchJokes();
      await saveJokesToCache(jokes.map((joke) => joke.toJson()).toList());
      setState(() {
        _cachedJokes = jokes;
      });
    } catch (e) {
      if (_cachedJokes.isEmpty) {
        setState(() {
          _cachedJokes = [Joke(setup: 'No jokes available...', punchline: 'Please connect internet first time you using the app!')];
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
          style: const TextStyle(
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
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 10.0),
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
