import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:l/l.dart';

class LoggingBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    l.i('${bloc.runtimeType}: Change -> $change');
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);

    l.i('${bloc.runtimeType}: close');
  }

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);

    l.i('${bloc.runtimeType}: create');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    l.e('${bloc.runtimeType}: Error -> $error');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);

    l.i('${bloc.runtimeType}: Event -> $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);

    l.i('${bloc.runtimeType}: Transition -> $transition');
  }
}
