import 'package:flutter/material.dart';

class WeatherError extends StatelessWidget {
  const WeatherError({
    required this.error,
    super.key,
  });

  factory WeatherError.object(Object error) => WeatherError(error: error);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.error,
            color: Colors.red,
          ),
          const SizedBox(height: 20),
          Text(error.toString()),
        ],
      ),
    );
  }
}
