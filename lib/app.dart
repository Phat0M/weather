import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/home_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({
    required this.sharedPreferences,
    super.key,
  });

  final SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: sharedPreferences),
      ],
      child: const MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

extension WeatherAppInitializer on WeatherApp {
  static Future<void> initializeAppAndRun() async {
    final completer = Completer<void>();
    try {
      final binding = WidgetsFlutterBinding.ensureInitialized()
        ..deferFirstFrame();

      // Init dependencies

      final sharedPreferences = await SharedPreferences.getInstance();

      binding.addPostFrameCallback((timeStamp) {
        binding.allowFirstFrame();

        completer.complete();
      });

      runApp(
        WeatherApp(
          sharedPreferences: sharedPreferences,
        ),
      );
    } on Object catch (_) {
      completer.complete();
    }

    return completer.future;
  }
}
