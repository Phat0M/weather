import 'package:freezed_annotation/freezed_annotation.dart';

part 'location_search_result.freezed.dart';
part 'location_search_result.g.dart';

@freezed
class LocationSearchResult with _$LocationSearchResult {
  const factory LocationSearchResult({
    required List<LocationSearchItem> features,
  }) = _LocationSearchResult;

  factory LocationSearchResult.fromJson(Map<String, dynamic> json) =>
      _$LocationSearchResultFromJson(json);
}

@freezed
class LocationSearchItem with _$LocationSearchItem {
  const factory LocationSearchItem({
    @JsonKey(name: 'text_ru') required String name,
    @JsonKey(name: 'place_name_ru') required String fullName,
    required LocationCoordinates geometry,
  }) = _LocationSearchItem;

  factory LocationSearchItem.fromJson(Map<String, dynamic> json) =>
      _$LocationSearchItemFromJson(json);
}

@freezed
class LocationCoordinates with _$LocationCoordinates {
  const factory LocationCoordinates({
    required List<double> coordinates,
  }) = _LocationCoordinates;

  factory LocationCoordinates.fromJson(Map<String, dynamic> json) =>
      _$LocationCoordinatesFromJson(json);
}
