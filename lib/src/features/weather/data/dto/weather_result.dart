import 'package:freezed_annotation/freezed_annotation.dart';

part 'weather_result.freezed.dart';
part 'weather_result.g.dart';

@freezed
class WeatherResult with _$WeatherResult {
  const factory WeatherResult({
    required List<WeatherItem> list,
  }) = _WeatherResult;

  factory WeatherResult.fromJson(Map<String, dynamic> json) =>
      _$WeatherResultFromJson(json);
}

@freezed
class WeatherItem with _$WeatherItem {
  const factory WeatherItem({
    @JsonKey(name: 'dt') required int dateTime,
    required WeatherItemData main,
    required List<WeatherItemDescription> weather,
  }) = _WeatherItem;

  factory WeatherItem.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemFromJson(json);
}

@freezed
class WeatherItemData with _$WeatherItemData {
  const factory WeatherItemData({
    required double temp,
    @JsonKey(name: 'temp_min') required double tempMin,
    @JsonKey(name: 'temp_max') required double tempMax,
  }) = _WeatherItemData;

  factory WeatherItemData.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemDataFromJson(json);
}

@freezed
class WeatherItemDescription with _$WeatherItemDescription {
  const factory WeatherItemDescription({
    required String description,
  }) = _WeatherItemDescription;

  factory WeatherItemDescription.fromJson(Map<String, dynamic> json) =>
      _$WeatherItemDescriptionFromJson(json);
}
