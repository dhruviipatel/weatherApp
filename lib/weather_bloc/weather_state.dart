part of 'weather_bloc.dart';

@immutable
sealed class WeatherState {}

final class WeatherInitial extends WeatherState {}

final class WeatherSuccess extends WeatherState {
  final AllWeatherData allWeatherData;

  WeatherSuccess({required this.allWeatherData});
  //final List weatherlist;

  // WeatherSuccess({required this.weatherlist});
}

final class WeatherFailure extends WeatherState {
  final String error;

  WeatherFailure(this.error);
}

final class WeatherLoading extends WeatherState {}
