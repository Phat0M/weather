import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather/src/features/location/model/location.dart';
import 'package:weather/src/features/weather/data/weather_repository.dart';
import 'package:weather/src/features/weather/model/weather.dart';

part 'weather_bloc.freezed.dart';

@freezed
class WeatherState with _$WeatherState {
  const WeatherState._();

  const factory WeatherState.loading() = LoadingWeatherState;

  const factory WeatherState.data({
    required IList<Weather> weathers,
  }) = DataWeatherState;

  const factory WeatherState.error({
    required Object error,
  }) = ErrorWeatherState;
}

@freezed
class WeatherEvent with _$WeatherEvent {
  const WeatherEvent._();

  const factory WeatherEvent.updateLocation({
    required Location location,
  }) = _UpdateLocation;
}

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc({
    required IWeatherRepository weatherRepository,
  })  : _weatherRepository = weatherRepository,
        super(WeatherState.data(weathers: IList())) {
    on<_UpdateLocation>(
      _onUpdateLocation,
      transformer: (events, mapper) => events.switchMap(mapper),
    );
  }

  final IWeatherRepository _weatherRepository;

  Future<void> _onUpdateLocation(
    _UpdateLocation event,
    Emitter<WeatherState> emitter,
  ) async {
    emitter(const WeatherState.loading());

    try {
      final geolocation = event.location.geolocation;
      final weathers = await _weatherRepository.fetch(geolocation).toList();

      emitter(
        WeatherState.data(
          weathers: weathers.lock,
        ),
      );
    } on Object catch (e) {
      emitter(
        WeatherState.error(error: e),
      );
      rethrow;
    }
  }
}
