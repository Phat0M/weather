import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:weather/home_layout.dart';
import 'package:weather/src/features/location/bloc/location_bloc.dart';
import 'package:weather/src/features/location/data/location_repository.dart';
import 'package:weather/src/features/weather/bloc/weather_bloc.dart';
import 'package:weather/src/features/weather/data/weather_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider<ILocationRepository>(
      create: (context) => LocationRepository(
        sharedPreferences: Provider.of(context, listen: false),
        dio: Provider.of(context, listen: false),
      ),
      child: MultiProvider(
        providers: [
          Provider(
            create: (context) => LocationBloc(
              repository: Provider.of(context, listen: false),
            )..add(const LocationEvent.init()),
          ),
          Provider<WeatherBloc>(
            create: (context) => WeatherBloc(
              weatherRepository: WeatherRepository(dio: context.read()),
            ),
          ),
        ],
        child: BlocListener<LocationBloc, LocationState>(
          listener: (context, state) {
            final location = state.currentLocation;
            if (location != null) {
              context
                  .read<WeatherBloc>()
                  .add(WeatherEvent.updateLocation(location: location));
            }
          },
          child: const HomeLayout(),
        ),
      ),
    );
  }
}
