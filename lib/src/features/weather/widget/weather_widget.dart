import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pure/pure.dart';
import 'package:weather/src/features/weather/model/weather.dart';

class WeatherWidget extends StatelessWidget {
  static const _degree = '°';

  const WeatherWidget({
    required this.weather,
    super.key,
  });

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final formatter = DateFormat('dd.MM.yyyy');
    return Card(
      child: ListTile(
        title: Row(
          children: [
            Expanded(child: Text('${weather.temp}$_degree')),
            Text(
              formatter.format(weather.date),
              style: textTheme.labelSmall,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: weather.description?.pipe(Text.new) ??
                  const SizedBox.shrink(),
            ),
            Text('мин: ${weather.tempMin}$_degree'),
            const SizedBox(width: 20),
            Text('макс: ${weather.tempMax}$_degree'),
          ],
        ),
      ),
    );
  }
}
