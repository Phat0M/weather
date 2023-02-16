import 'package:freezed_annotation/freezed_annotation.dart';

part 'current_position_result.freezed.dart';
part 'current_position_result.g.dart';

@freezed
class CurrentPositionResult with _$CurrentPositionResult {
  const CurrentPositionResult._();

  const factory CurrentPositionResult({
    required CurrentLocation location,
  }) = _CurrentPositionResult;

  factory CurrentPositionResult.fromJson(Map<String, Object?> json) =>
      _$CurrentPositionResultFromJson(json);
}

@freezed
class CurrentLocation with _$CurrentLocation {
  const CurrentLocation._();

  const factory CurrentLocation({
    required CurrentCountry country,
    required String city,
    required double latitude,
    required double longitude,
  }) = _CurrentLocation;

  factory CurrentLocation.fromJson(Map<String, Object?> json) =>
      _$CurrentLocationFromJson(json);
}

@freezed
class CurrentCountry with _$CurrentCountry {
  const CurrentCountry._();

  const factory CurrentCountry({
    required String name,
  }) = _CurrentCountry;

  factory CurrentCountry.fromJson(Map<String, Object?> json) =>
      _$CurrentCountryFromJson(json);
}
