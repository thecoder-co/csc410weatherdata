// To parse this JSON data, do
//
//     final weatherData = weatherDataFromJson(jsonString);

import 'dart:convert';

List<WeatherData> weatherDataFromJson(String str) => List<WeatherData>.from(
    json.decode(str).map((x) => WeatherData.fromJson(x)));

String weatherDataToJson(List<WeatherData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WeatherData {
  DateTime? timestamp;
  String? temperature;
  String? pressure;
  String? seaLevelPressure;

  WeatherData({
    this.timestamp,
    this.temperature,
    this.pressure,
    this.seaLevelPressure,
  });

  WeatherData copyWith({
    DateTime? timestamp,
    String? temperature,
    String? pressure,
    String? seaLevelPressure,
  }) =>
      WeatherData(
        timestamp: timestamp ?? this.timestamp,
        temperature: temperature ?? this.temperature,
        pressure: pressure ?? this.pressure,
        seaLevelPressure: seaLevelPressure ?? this.seaLevelPressure,
      );

  factory WeatherData.fromJson(Map<String, dynamic> json) => WeatherData(
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
        temperature: json["temperature"],
        pressure: json["pressure"],
        seaLevelPressure: json["sea_level_pressure"],
      );

  Map<String, dynamic> toJson() => {
        "timestamp": timestamp?.toIso8601String(),
        "temperature": temperature,
        "pressure": pressure,
        "sea_level_pressure": seaLevelPressure,
      };
}
