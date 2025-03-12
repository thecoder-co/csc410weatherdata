import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather/weather_data_model.dart';

final weatherProviderRaw = FutureProvider<List<WeatherData>>((ref) async {
  final data = await Dio().get('https://sheetdb.io/api/v1/u6hmify2sgfwc');
  return weatherDataFromJson(json.encode(data.data));
});

final weatherProviderDef = FutureProvider<List<WeatherData>>((ref) async {
  final data = await ref.watch(weatherProviderRaw.future);

  return data
      .where(
        (element) =>
            dateFormat.format(element.timestamp ?? DateTime.now()) ==
            ref.watch(dateProvider),
      )
      .toList();
});

final weatherProvider =
    FutureProvider.family<List<WeatherData>, String>((ref, date) async {
  final data = await ref.watch(weatherProviderRaw.future);

  return data
      .where(
        (element) =>
            dateFormat.format(element.timestamp ?? DateTime.now()) == date,
      )
      .toList();
});

final dateProvider = StateProvider<String>((ref) {
  return dateFormat.format(DateTime.now());
});

final dateFormat = DateFormat('yyyy-MM-dd');
