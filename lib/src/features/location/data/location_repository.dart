import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/src/features/location/data/dto/current_position_result.dart';
import 'package:weather/src/features/location/model/location.dart';

abstract class ILocationRepository {
  Future<Location> getCurrentLocation();

  Future<void> saveLocation(Location location);
}

class LocationRepository implements ILocationRepository {
  static const _locationKey = 'location-key';

  LocationRepository({
    required SharedPreferences sharedPreferences,
    required Dio dio,
  })  : _dio = dio,
        _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;
  final Dio _dio;

  @override
  Future<Location> getCurrentLocation() {
    final savedData = _sharedPreferences.getString(_locationKey);

    if (savedData == null) {
      return _calculateCurrentLocation();
    }

    final json = jsonDecode(savedData);

    final result = Location.fromJson(json);

    return Future.value(result);
  }

  Future<Location> _calculateCurrentLocation() async {
    final response = await _dio.get('https://api.ipregistry.co?key=tryout');

    if (response.statusCode != 200) {
      // TODO: create typed exceptions.
      throw Exception('Ошибка вычисления текущей геопозиции');
    }
    final json = (response.data as Map<String, dynamic>);

    final currentPosition = CurrentPositionResult.fromJson(json);

    final currentLocation = currentPosition.location;

    return Location(
      city: currentLocation.city,
      fullName: '${currentLocation.city}, ${currentLocation.country.name}',
      latitude: currentLocation.latitude,
      longitude: currentLocation.longitude,
    );
  }

  @override
  Future<void> saveLocation(Location location) async {
    final data = jsonEncode(location.toJson());

    final result = await _sharedPreferences.setString(_locationKey, data);

    // TODO: if result is false - throw error.
  }
}
