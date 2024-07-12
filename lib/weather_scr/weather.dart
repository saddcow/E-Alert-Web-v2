
// ignore_for_file: library_private_types_in_public_api
import 'dart:convert';
import 'package:e_alert/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class WeatherForecastWidget extends StatefulWidget {
  const WeatherForecastWidget({super.key});

  @override
  _WeatherForecastWidgetState createState() => _WeatherForecastWidgetState();
}


class _WeatherForecastWidgetState extends State<WeatherForecastWidget> {
  late Future<List<WeatherData>> weatherDataFuture;
  late Future<Map<String, dynamic>> currentWeatherFuture;

  @override
  void initState() {
    super.initState();
    weatherDataFuture = fetchWeatherData();
  }

  Future<List<WeatherData>> fetchWeatherData() async {
    const String apiKey = '6378430bc45061aaccd4a566a86c25df';
    const String baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';
    const String city = 'Naga';

    final response = await http.get(Uri.parse('$baseUrl?q=$city&appid=$apiKey'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];

      final filteredList = forecastList.where((item) {
        final DateTime dateTime = DateTime.parse(item['dt_txt']);
        return dateTime.hour == 12 && dateTime.minute == 0;
      }).toList();

      return filteredList.map((item) => WeatherData.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Forecast Weather
        FutureBuilder<List<WeatherData>>(
          future: weatherDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No forecast weather data available'));
            } else {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: snapshot.data!.map((weatherData) {
                  return Column(
                    children: [
                      Text(
                        weatherData.day,
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        '${weatherData.month}  ${weatherData.date}',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Image.network(weatherData.iconUrl),
                      Text(
                        '${weatherData.temperature}°C',
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w300,
                          fontSize: 30,
                        ),
                      ),
                      Text(
                        weatherData.weatherDescription.toUpperCase(),
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}

