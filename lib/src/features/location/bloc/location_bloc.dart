import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:weather/src/features/location/data/location_repository.dart';
import 'package:weather/src/features/location/model/location.dart';

part 'location_bloc.freezed.dart';

@freezed
class LocationState with _$LocationState {
  const LocationState._();

  const factory LocationState.idle({
    required Location? currentLocation,
  }) = IdleLocationState;

  const factory LocationState.loading({
    required Location? currentLocation,
  }) = LoadingLocationState;

  const factory LocationState.success({
    required Location currentLocation,
  }) = SuccessLocationState;

  const factory LocationState.error({
    required Location? currentLocation,
    required Object error,
  }) = ErrorLocationState;

  factory LocationState._initial() => const LocationState.idle(
        currentLocation: null,
      );
}

@freezed
class LocationEvent with _$LocationEvent {
  const factory LocationEvent.init() = _Init;

  const factory LocationEvent.save(Location location) = _SaveLocation;
}

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc({required ILocationRepository repository})
      : _repository = repository,
        super(LocationState._initial()) {
    on<_SaveLocation>(_onSave);
    on<_Init>(_onInit);
  }

  final ILocationRepository _repository;

  Future<void> _onSave(_SaveLocation event, Emitter<LocationState> emit) =>
      _makeUpdates(
        () async {
          await _repository.saveLocation(event.location);
          return await _repository.getCurrentLocation();
        },
        emit,
      );

  Future<void> _onInit(_Init event, Emitter<LocationState> emit) =>
      _makeUpdates(
        () => _repository.getCurrentLocation(),
        emit,
      );

  Future<void> _makeUpdates(
    Future<Location> Function() body,
    Emitter<LocationState> emit,
  ) async {
    emit(LocationState.loading(
      currentLocation: state.currentLocation,
    ));

    try {
      final updatedLocation = await body();

      emit(
        LocationState.success(
          currentLocation: updatedLocation,
        ),
      );
    } on Object catch (e) {
      emit(
        LocationState.error(
          currentLocation: state.currentLocation,
          error: e,
        ),
      );
      rethrow;
    } finally {
      emit(
        LocationState.idle(
          currentLocation: state.currentLocation,
        ),
      );
    }
  }
}
