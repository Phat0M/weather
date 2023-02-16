import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:weather/src/features/location/model/location.dart';
import 'package:weather/src/features/weather/data/dto/weather_result.dart';
import 'package:weather/src/features/weather/model/weather.dart';

abstract class IWeatherRepository {
  Stream<Weather> fetch(Geolocation geolocation);
}

class WeatherRepository implements IWeatherRepository {
  static const _weatherToken = '2541369f2fc4dae48b4952c118683f9f';

  WeatherRepository({
    required Dio dio,
  }) : _dio = dio;

  final Dio _dio;

  @override
  Stream<Weather> fetch(Geolocation geolocation) async* {
    final response = await _dio.get(
      'http://api.openweathermap.org/data/2.5/forecast',
      queryParameters: {
        'lat': geolocation.latitude,
        'lon': geolocation.longitude,
        'cnt': 24,
        'lang': 'ru',
        'units': 'metric',
        'appid': _weatherToken,
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Ошибка загрузки погоды');
    }

    final json = (response.data as Map<String, dynamic>);

    final result = WeatherResult.fromJson(json);

    // API выдает почасовую сводку погоды, нам нужна ежедневная.
    final results = <DateTime, WeatherItem>{};

    for (var element in result.list) {
      final dateTime =
          DateTime.fromMillisecondsSinceEpoch(element.dateTime * 1000);

      results[dateTime.clumpDay] = element;
    }

    yield* Stream.fromIterable(results.entries).map((entry) => Weather(
          date: entry.key,
          temp: entry.value.main.temp,
          tempMax: entry.value.main.tempMax,
          tempMin: entry.value.main.tempMin,
          description: entry.value.weather.firstOrNull?.description,
        ));
  }
}

extension on DateTime {
  DateTime get clumpDay => DateTime(year, month, day);
}
