import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/src/features/location/bloc/location_bloc.dart';
import 'package:weather/src/features/location/widget/location_search_bar/location_search_bar.dart';
import 'package:weather/src/features/location/widget/location_widget.dart';
import 'package:weather/src/features/weather/bloc/weather_bloc.dart';
import 'package:weather/src/features/weather/widget/weather_error.dart';
import 'package:weather/src/features/weather/widget/weather_list_widget.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const LocationSearchBar(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocBuilder<LocationBloc, LocationState>(
                  builder: (context, state) {
                    final location = state.currentLocation;
                    if (location == null) {
                      return const SizedBox.shrink();
                    } else {
                      return LocationWidget(location: location);
                    }
                  },
                ),
              ),
              Expanded(
                  child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) => state.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  data: WeatherListWidget.list,
                  error: WeatherError.object,
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
