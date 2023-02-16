import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:weather/src/features/location/data/location_repository.dart';
import 'package:weather/src/features/location/model/location.dart';

part 'location_search_bloc.freezed.dart';

@freezed
class QueryResult with _$QueryResult {
  const factory QueryResult({
    required String text,
    required IList<Location> suggestions,
  }) = _QueryResult;
}

@freezed
class LocationSearchState with _$LocationSearchState {
  const LocationSearchState._();

  factory LocationSearchState.initial() => IdleLocationSearchState(
        query: QueryResult(
          text: '',
          suggestions: IList(),
        ),
      );

  const factory LocationSearchState.idle({
    required QueryResult query,
  }) = IdleLocationSearchState;

  const factory LocationSearchState.loading({
    required QueryResult query,
  }) = LoadingLocationSearchState;

  const factory LocationSearchState.success({
    required QueryResult query,
  }) = SuccessLocationSearchState;

  const factory LocationSearchState.error({
    required QueryResult query,
    required Object error,
  }) = ErrorLocationSearchState;

  IList<Location> get suggestions => query.suggestions;
}

@freezed
class LocationSearchEvent with _$LocationSearchEvent {
  const LocationSearchEvent._();

  const factory LocationSearchEvent.updateQuery(String query) =
      _UpdateQueryEvent;
}

class LocationSearchBloc
    extends Bloc<LocationSearchEvent, LocationSearchState> {
  LocationSearchBloc({
    required ILocationRepository locationRepository,
  })  : _locationRepository = locationRepository,
        super(LocationSearchState.initial()) {
    on<_UpdateQueryEvent>(
      _onUpdate,
      transformer: (events, mapper) => events
          .debounce(const Duration(milliseconds: 300))
          .throttle(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
  }

  final ILocationRepository _locationRepository;

  Future<void> _onUpdate(
    _UpdateQueryEvent event,
    Emitter<LocationSearchState> emitter,
  ) async {
    emitter(LocationSearchState.loading(
      query: state.query.copyWith(
        text: event.query,
      ),
    ));

    try {
      final query = event.query;

      final searchResult =
          await _locationRepository.searchLocations(query: query).toList();

      emitter(
        LocationSearchState.success(
          query: QueryResult(
            text: query,
            suggestions: searchResult.lock,
          ),
        ),
      );
    } on Object catch (e) {
      emitter(
        LocationSearchState.error(
          query: state.query.copyWith(suggestions: IList()),
          error: e,
        ),
      );
      rethrow;
    } finally {
      emitter(
        LocationSearchState.idle(
          query: state.query,
        ),
      );
    }
  }
}
