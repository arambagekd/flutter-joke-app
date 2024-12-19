# Joke App

A Flutter-based mobile application that fetches jokes from an online API and displays them to users with a refreshing, visually pleasing interface. Users can view jokes, pull to refresh, and experience smooth navigation throughout the app. Cached jokes ensure the app can function offline for a seamless user experience.

---

## Features

- **Splash Screen**: Engages users with a delightful introduction screen.
- **Joke List Display**: Fetches jokes from a public API and displays them with styled animations.
- **Pull-to-Refresh**: Users can refresh jokes with a swipe-down gesture.
- **Offline Support**: Jokes are cached locally, allowing access even without an internet connection.
- **Responsive UI**: Supports various screen sizes with dynamic and user-friendly design.

---

## File Structure

```
lib/
|-- main.dart                  # Entry point of the app
|-- screens/
|   |-- splash_screen.dart     # Splash screen implementation
|   |-- joke_list_page.dart    # Main page to display jokes
|
|-- widgets/
|   |-- joke_item.dart         # Reusable widget for displaying individual jokes
|
|-- utils/
    |-- joke_cache.dart        # Utility for caching jokes using SharedPreferences
```

---

## Installation and Setup

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/arambagekd/flutter-joke-app
   ```

2. **Install Dependencies**:
   Make sure you have Flutter installed and configured. Then, run:
   ```bash
   flutter pub get
   ```

3. **Run the App**:
   Use the following command to run the app:
   ```bash
   flutter run
   ```

---

## API Used

The app fetches jokes from the **Official Joke API**:
- **Endpoint**: `https://official-joke-api.appspot.com/jokes/ten`
- **Data**: A list of jokes, each containing `setup` and `punchline` fields.

---

## Dependencies

- **http**: For making API requests.
- **shared_preferences**: For caching jokes locally.
- **flutter/material.dart**: For building the UI.

Add these dependencies in the `pubspec.yaml` file:
```yaml
dependencies:
   flutter:
      sdk: flutter
   http: ^0.15.0
   shared_preferences: ^2.0.0
```

---

## How it Works

1. The app starts with a **Splash Screen**, shown for 2 seconds.
2. It navigates to the **Joke List Page**, which:
   - Fetches jokes from the API.
   - Displays cached jokes if the API call fails.
   - Allows users to refresh jokes via pull-to-refresh or the refresh button.
3. Each joke is displayed with a stylish **Joke Item** widget.

---


## Contribution

Feel free to contribute to the project by submitting issues or pull requests:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes and push them to your fork.
4. Submit a pull request to the main repository.

---

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
