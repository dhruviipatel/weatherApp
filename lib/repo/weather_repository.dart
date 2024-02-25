import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weatherapp/models/allWeatherDataModel.dart';
import 'package:weatherapp/services/data_provider.dart';

class WeatherRepository {
  final WeatherDataProvider weatherDataProvider;

  WeatherRepository(this.weatherDataProvider);

  getCurrentWeather(cityName) async {
    try {
      final weather = await weatherDataProvider.getCurrentWeather(cityName);
      final data = jsonDecode(weather);

      print(weather);

      if (data['cod'] != '200') {
        throw 'unexpected error occur';
      }

      return AllWeatherData.fromJson(data);
    } catch (e) {
      throw e.toString();
    }
  }

  getCurrentWeatherLocationwise() async {
    var sp = await SharedPreferences.getInstance();
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      var currentLocation =
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}';

      print(currentLocation);

      final weather = await weatherDataProvider.getCurrentLocationWeather(
          position.latitude, position.longitude);

      final data = jsonDecode(weather);
      final cityName = data['name'];
      sp.setString('cityname', cityName);
      print(cityName);
      print(weather);

      final weather1 = await weatherDataProvider.getCurrentWeather(cityName);
      final data1 = jsonDecode(weather1);

      return AllWeatherData.fromJson(data1);

      // return myw;
    } catch (e) {
      throw e.toString();
    }
  }
}
