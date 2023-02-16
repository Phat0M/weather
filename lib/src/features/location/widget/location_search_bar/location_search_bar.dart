import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/src/features/location/bloc/location_bloc.dart';
import 'package:weather/src/features/location/bloc/location_search_bloc.dart';
import 'package:weather/src/features/location/widget/location_search_bar/location_search_field.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => LocationSearchBloc(
        locationRepository: Provider.of(context, listen: false),
      ),
      child: Builder(builder: (context) {
        return LocationSearchField(
          onSelected: (location) {
            Provider.of<LocationBloc>(context, listen: false)
                .add(LocationEvent.save(location));
          },
          onSubmitted: (query) {
            Provider.of<LocationSearchBloc>(context, listen: false)
                .add(LocationSearchEvent.updateQuery(query));
          },
        );
      }),
    );
  }
}
