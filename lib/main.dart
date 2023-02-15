import 'dart:async';

import 'package:l/l.dart';
import 'package:weather/app.dart';

Future<void>? main() => wrapLoggingCapture(
      () => WeatherAppInitializer.initializeAppAndRun(),
    );

R? wrapLoggingCapture<R>(R Function() body) => runZonedGuarded(
      () => l.capture(body),
      l.e,
    );
