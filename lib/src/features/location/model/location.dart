import 'package:freezed_annotation/freezed_annotation.dart';

part 'location.freezed.dart';
part 'location.g.dart';

@freezed
class Location with _$Location {
  const Location._();

  const factory Location({
    required String city,
    required String fullName,
    required Geolocation geolocation,
  }) = _Location;

  factory Location.fromJson(Map<String, Object?> json) =>
      _$LocationFromJson(json);
}

@freezed
class Geolocation with _$Geolocation {
  const Geolocation._();

  const factory Geolocation({
    required double latitude,
    required double longitude,
  }) = _Geolocation;

  factory Geolocation.fromJson(Map<String, Object?> json) =>
      _$GeolocationFromJson(json);
}
