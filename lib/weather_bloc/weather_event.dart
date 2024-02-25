part of 'weather_bloc.dart';

@immutable
sealed class WeatherEvent {}

class WeatherFetch extends WeatherEvent {
  final String cityName;

  WeatherFetch({required this.cityName});
}

class AgainWeatherFetch extends WeatherEvent {
  final String cityName;

  AgainWeatherFetch({required this.cityName});
}
