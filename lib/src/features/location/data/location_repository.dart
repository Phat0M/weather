import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather/src/features/location/data/dto/current_position_result.dart';
import 'package:weather/src/features/location/data/dto/location_search_result.dart';
import 'package:weather/src/features/location/model/location.dart';

abstract class ILocationRepository {
  Future<Location> getCurrentLocation();

  Stream<Location> searchLocations({String query = ''});

  Future<void> saveLocation(Location location);
}

class LocationRepository implements ILocationRepository {
  static const _locationKey = 'location-key';
  static const _cityToken =
      'pk.eyJ1IjoicGhhdDBtIiwiYSI6ImNsZHR2d3cyZDA1YXEzcnBqbWowd25rbXUifQ.CrNFHvyUkX9XN9-Z8u0IYA';

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

  @override
  Stream<Location> searchLocations({String query = ''}) async* {
    if (query.isEmpty) {
      yield* const Stream.empty();
      return;
    }

    final response = await _dio.get(
      'https://api.mapbox.com/geocoding/v5/mapbox.places/$query.json',
      queryParameters: {
        'access_token': _cityToken,
        'autocomplete': true,
        'language': 'ru',
        'limit': 20,
      },
    );

    if (response.statusCode != 200) {
      // TODO: create typed exceptions.
      throw Exception('Ошибка поиска');
    }
    final json = (response.data as Map<String, dynamic>);

    final result = LocationSearchResult.fromJson(json);

    yield* Stream.fromIterable(
      result.features,
    )
        .map(
      (item) => Location(
        city: item.name,
        fullName: item.fullName,
        latitude: item.geometry.coordinates[1],
        longitude: item.geometry.coordinates[0],
      ),
    )
        .handleError((error) {
      // TODO: handle to crashlytic
      debugPrint(error);
    });
  }
}
