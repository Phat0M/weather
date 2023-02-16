import 'package:flutter/foundation.dart';

@immutable
class Weather {
  final DateTime date;
  final double temp;
  final double tempMax;
  final double tempMin;
  final String? description;

  const Weather({
    required this.date,
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.description,
  });
}
