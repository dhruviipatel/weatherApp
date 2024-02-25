import 'package:http/http.dart' as http;

class WeatherDataProvider {
  //Future<String>
  getCurrentWeather(cityName) async {
    try {
      const openWeatherAPIKey = '4af409a4c67493e64a7c44c96d9c51e3';
      var api =
          'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&APPID=$openWeatherAPIKey';
      var response = await http.get(Uri.parse(api));

      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }

  getCurrentLocationWeather(lat, lon) async {
    try {
      const openWeatherAPIKey = '4af409a4c67493e64a7c44c96d9c51e3';
      var api =
          'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openWeatherAPIKey';
      var response = await http.get(Uri.parse(api));
      return response.body;
    } catch (e) {
      throw e.toString();
    }
  }
}

//'https://api.openweathermap.org/data/2.5/forecast?q=London&APPID=4af409a4c67493e64a7c44c96d9c51e3';
