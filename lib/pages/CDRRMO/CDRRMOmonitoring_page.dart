import 'package:e_alert/weather_scr/weather.dart';
import 'package:flutter/material.dart';

class CDRRMOmonitoringPage extends StatefulWidget {
  const CDRRMOmonitoringPage({super.key});

  @override
  State<CDRRMOmonitoringPage> createState() => _CDRRMOmonitoringPageState();
}

class _CDRRMOmonitoringPageState extends State<CDRRMOmonitoringPage> {
  @override
  Widget build(BuildContext context) {
    return 
        WeatherForecastWidget();
  }
}