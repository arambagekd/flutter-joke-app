import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHomePage();
  }

  Future<void> _navigateToHomePage() async {
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const JokeListPage(title: 'Jokes For You 😊'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Text(
          'Joke App',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class JokeListPage extends StatefulWidget {
  const JokeListPage({super.key, required this.title});

  final String title;

  @override
  State<JokeListPage> createState() => _JokeListPageState();
}

class _JokeListPageState extends State<JokeListPage> {
  List<Map<String, String>> _cachedJokes = [];
  List<Map<String, String>> _displayedJokes = [];
  bool _isLoading = false;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadCachedJokes();
    _fetchJokes();
  }

  Future<void> _loadCachedJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedJokes = prefs.getString('jokes');

    if (cachedJokes != null) {
      setState(() {
        _cachedJokes = List<Map<String, String>>.from(json.decode(cachedJokes));
        _updateDisplayedJokes();
      });
    }
  }

  Future<void> _cacheJokes(List<Map<String, String>> jokes) async {
    final prefs = await SharedPreferences.getInstance();

    // Limit the cache to the latest 50 jokes
    final updatedJokes = jokes.length > 50
        ? jokes.sublist(0, 50)
        : jokes;

    await prefs.setString('jokes', json.encode(updatedJokes));
    setState(() {
      _cachedJokes = updatedJokes;
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

        // Combine new jokes with existing ones, ensuring no duplicates
        final updatedJokes = [
          ...formattedJokes,
          ..._cachedJokes
        ].toSet().toList();

        // Cache the updated list
        await _cacheJokes(updatedJokes);

        // Refresh displayed jokes
        _updateDisplayedJokes();
      }
    } catch (e) {
      // Handle network errors by displaying cached jokes
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updateDisplayedJokes() {
    setState(() {
      _displayedJokes = _cachedJokes.skip(_currentPage * 10).take(10).toList();
    });
  }

  Future<void> _loadNextPage() async {
    if ((_currentPage + 1) * 10 < _cachedJokes.length) {
      setState(() {
        _currentPage++;
        _updateDisplayedJokes();
      });
    } else {
      await _fetchJokes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchJokes,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadNextPage,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _displayedJokes.isEmpty
            ? const Center(
          child: Text(
            'No jokes available... Oops!',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _displayedJokes.length,
          itemBuilder: (context, index) {
            final joke = _displayedJokes[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      joke['setup']!,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      '${joke['punchline']} 😊',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                        fontSize: 14,
                        color: Colors.green[700],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
