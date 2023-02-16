import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/home_page.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({
    required this.sharedPreferences,
    required this.dio,
    super.key,
  });

  final SharedPreferences sharedPreferences;
  final Dio dio;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: sharedPreferences),
        Provider.value(value: dio),
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

      final dio = Dio();
      dio.interceptors.add(PrettyDioLogger());

      runApp(
        WeatherApp(
          sharedPreferences: sharedPreferences,
          dio: dio,
        ),
      );
    } on Object catch (_) {
      completer.complete();
    }

    return completer.future;
  }
}
