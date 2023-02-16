import 'package:flutter/material.dart';
import 'package:weather/src/features/location/model/location.dart';

class LocationWidget extends StatelessWidget {
  const LocationWidget({
    required this.location,
    super.key,
  });

  final Location location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              location.city,
              style: textTheme.titleLarge,
            ),
            Text(
              location.fullName,
              style: textTheme.bodyMedium?.copyWith(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
