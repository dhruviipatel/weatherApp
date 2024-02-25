import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherapp/models/allWeatherDataModel.dart';
import 'package:weatherapp/repo/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;
  WeatherBloc(this.weatherRepository) : super(WeatherInitial()) {
    on<WeatherFetch>(_getcurrentweatherLocation);
    on<AgainWeatherFetch>(_getcurrentweather);
  }

  void _getcurrentweather(
      AgainWeatherFetch event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getCurrentWeather(event.cityName);
      emit(WeatherSuccess(allWeatherData: weather));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }

  void _getcurrentweatherLocation(
      WeatherFetch event, Emitter<WeatherState> emit) async {
    emit(WeatherLoading());
    try {
      final weather = await weatherRepository.getCurrentWeatherLocationwise();
      emit(WeatherSuccess(allWeatherData: weather));
    } catch (e) {
      emit(WeatherFailure(e.toString()));
    }
  }
}
