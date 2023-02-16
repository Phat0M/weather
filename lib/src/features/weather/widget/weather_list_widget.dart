import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:weather/src/features/weather/model/weather.dart';
import 'package:weather/src/features/weather/widget/weather_widget.dart';

class WeatherListWidget extends StatelessWidget {
  const WeatherListWidget({
    required this.weatherList,
    super.key,
  });

  factory WeatherListWidget.list(IList<Weather> weatherList) =>
      WeatherListWidget(weatherList: weatherList);

  final IList<Weather> weatherList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: weatherList.length,
        itemBuilder: (context, index) => WeatherWidget(
          weather: weatherList[index],
        ),
      ),
    );
  }
}
