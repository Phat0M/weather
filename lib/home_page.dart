import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/home_layout.dart';
import 'package:weather/src/features/location/bloc/location_bloc.dart';
import 'package:weather/src/features/location/data/location_repository.dart';

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
      child: Provider(
        create: (context) => LocationBloc(
          repository: Provider.of(context, listen: false),
        )..add(const LocationEvent.init()),
        child: const HomeLayout(),
      ),
    );
  }
}
