class Joke {
  final String setup;
  final String punchline;

  Joke({required this.setup, required this.punchline});

  /// Factory method to create a `Joke` object from a JSON map
  factory Joke.fromJson(Map<String, dynamic> json) {
    String setup = json['setup'];
    String punchline = json['punchline'];

    // Ensure the setup ends with a question mark if applicable
    if (setup.contains('?')) {
      final parts = setup.split('?');
      setup = '${parts[0]}?';
    }

    return Joke(setup: setup, punchline: punchline);
  }

  /// Converts a `Joke` object to a JSON map
  Map<String, String> toJson() {
    return {
      'setup': setup,
      'punchline': punchline,
    };
  }
}
