import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:weatherapp/aditional_info_item.dart';
import 'package:weatherapp/cubit/auth_cubit.dart';
import 'package:weatherapp/screens/loginScreen.dart';
import 'package:weatherapp/weather_bloc/weather_bloc.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  String selectedCity = '';

  @override
  void initState() {
    context.read<WeatherBloc>().add(WeatherFetch(cityName: 'London'));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PopupMenuButton(
                child: Icon(Icons.more_vert),
                itemBuilder: (context) => [
                      PopupMenuItem(
                          onTap: () {
                            context
                                .read<WeatherBloc>()
                                .add(AgainWeatherFetch(cityName: selectedCity));
                          },
                          child: Text("Refresh")),
                      PopupMenuItem(
                          onTap: () {
                            context.read<AuthBloc>().signOut().then((value) =>
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen())));
                          },
                          child: Text("Logout"))
                    ]),
          ),
        ],
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (context, state) {
          if (state is WeatherFailure) {
            return Text(state.error);
          }
          if (state is! WeatherSuccess) {
            return const Center(child: CircularProgressIndicator());
          }

          var mydata = state.allWeatherData;

          var data = mydata.list;
          var currentcity = mydata.city.name;
          var currentTemp = data[0].main.temp;
          var currentSky = data[0].weather[0].main;

          var currentHumidity = data[0].main.humidity;
          var currentWindSpeed = data[0].wind.speed;
          var currentPressure = data[0].main.pressure;
          selectedCity = currentcity;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: DropdownButton(
                      underline: Container(),
                      isExpanded: true,
                      hint: Text(currentcity),
                      items: [
                        DropdownMenuItem(
                            value: "$currentcity", child: Text("$currentcity")),
                        DropdownMenuItem(value: "Surat", child: Text("Surat")),
                        DropdownMenuItem(
                            value: "Ahmedabad", child: Text("Ahmedabad")),
                        DropdownMenuItem(
                            value: "Manali", child: Text("Manali")),
                        DropdownMenuItem(
                            value: "London", child: Text("London")),
                        DropdownMenuItem(value: "Paris", child: Text("Paris")),
                        DropdownMenuItem(
                            value: "Canada", child: Text("Canada")),
                      ],
                      onChanged: (val) {
                        selectedCity = val as String;
                        context
                            .read<WeatherBloc>()
                            .add(AgainWeatherFetch(cityName: selectedCity));
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                // main card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                '$currentTemp K',
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                currentSky == 'Clouds'
                                    ? Icons.cloud
                                    : currentSky == 'Rain'
                                        ? Icons.cloudy_snowing
                                        : Icons.sunny,
                                size: 64,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                currentSky.toString(),
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                const Text(
                  'Hourly Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    itemCount: 5,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data[index + 1];
                      final hourlySky = data[index + 1].weather[0].main;
                      final hourlyTemp = hourlyForecast.main.temp.toString();
                      final time =
                          DateTime.parse(hourlyForecast.dtTxt.toString());
                      return HourlyForecastItem(
                        time: DateFormat.j().format(time),
                        temperature: "$hourlyTemp K",
                        icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
