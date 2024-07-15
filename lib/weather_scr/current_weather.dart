import 'dart:convert';
import 'package:e_alert/models/weather_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class CurrentWeatherApi {
  static Future<Map<String, dynamic>> fetchCurrentWeather(
    String apiKey, String city) async {
  try {
    final String currentWeatherUrl =
    'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey';
    final response = await http.get(Uri.parse(currentWeatherUrl));

    if (response.statusCode == 200) {
      final List<dynamic> forecastData = json.decode(response.body)['list'];

      // Find the forecast data for 12 PM
      final Map<String, dynamic> currentWeatherData =
          forecastData.firstWhere((data) {
        final DateTime dateTime =
            DateTime.parse(data['dt_txt']);
        return dateTime.hour == 12 && dateTime.minute == 0;
      });

      return currentWeatherData;
    } else {
      throw Exception('Failed to load current weather data');
    }
  } catch (error) {
    throw Exception('Failed to load current weather data: $error');
  }
  }
}

class CurrentWeatherCard extends StatefulWidget {
  const CurrentWeatherCard({Key? key}) : super(key: key);

  @override
  _CurrentWeatherCardState createState() => _CurrentWeatherCardState();
}

class _CurrentWeatherCardState extends State<CurrentWeatherCard> {
  WeatherData? currentWeather;

  @override
  void initState() {
    super.initState();
    // Fetch current weather data when the widget is initialized
    fetchCurrentWeatherData();
  }

  Future<void> fetchCurrentWeatherData() async {
    try {
      final apiKey = 'your_api_key_here';
      final city = 'Naga'; // Replace with dynamic city input or parameter
      final data = await WeatherApi.fetchWeather(apiKey, city);
      setState(() {
        currentWeather = data;
      });
    } catch (error) {
      print('Error fetching current weather data: $error');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        child: Column(
          children: [
            if (currentWeather != null)
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      currentWeather!.day,
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      '${currentWeather!.month} ${currentWeather!.date}',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Image.network(currentWeather!.iconUrl),
                    Text(
                      '${currentWeather!.temperature}°C',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w300,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      currentWeather!.weatherDescription.toUpperCase(),
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.w400,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
            if (currentWeather == null)
              const Text(
                'Loading current weather...',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

class WeatherApi {
  static Future<WeatherData> fetchWeather(String apiKey, String city) async {
    try {
      final String currentWeatherUrl =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey';
      final response = await http.get(Uri.parse(currentWeatherUrl));

      if (response.statusCode == 200) {
        final List<dynamic> forecastData = json.decode(response.body)['list'];

        // Find the forecast data for 12 PM
        final Map<String, dynamic> currentWeatherData = forecastData.firstWhere(
          (data) {
            final DateTime dateTime = DateTime.parse(data['dt_txt']);
            return dateTime.hour == 12 && dateTime.minute == 0;
          },
        );

        return WeatherData.fromJson(currentWeatherData);
      } else {
        throw Exception('Failed to load current weather data');
      }
    } catch (error) {
      throw Exception('Failed to load current weather data: $error');
    }
  }
}