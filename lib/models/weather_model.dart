// weather_model.dart

import 'package:intl/intl.dart';

class WeatherData {
  final String date;
  final String day;
  final String month;
  final String year;
  final int temperature;
  final String weatherDescription;
  final String iconUrl;

  WeatherData({
    required this.date,
    required this.day,
    required this.month,
    required this.year,
    required this.temperature,
    required this.weatherDescription,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final DateTime dateTime = DateTime.parse(json['dt_txt']);
    final String date = DateFormat('dd').format(dateTime);
    final String day = DateFormat('EEEE').format(dateTime);
    final String month = DateFormat('MMMM').format(dateTime);
    final String year = DateFormat('yyyy').format(dateTime);
    final int temperature = (json['main']['temp'] - 273.15).toInt();
    final String weatherDescription = json['weather'][0]['description'];
    final String iconCode = json['weather'][0]['icon'];
    final String iconUrl = 'https://openweathermap.org/img/w/$iconCode.png';

    return WeatherData(
      date: date,
      day: day,
      month: month,
      year: year,
      temperature: temperature,
      weatherDescription: weatherDescription,
      iconUrl: iconUrl,
    );
  }
}
