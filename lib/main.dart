import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubit/auth_cubit.dart';
import 'package:weatherapp/firebase_options.dart';
import 'package:weatherapp/repo/weather_repository.dart';
import 'package:weatherapp/screens/splashScreen.dart';
import 'package:weatherapp/services/auth_services.dart';
import 'package:weatherapp/services/data_provider.dart';
import 'package:weatherapp/weather_bloc/weather_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(AuthService())),
          BlocProvider(
              create: (_) =>
                  WeatherBloc(WeatherRepository(WeatherDataProvider()))),
          RepositoryProvider(
            create: (_) => WeatherRepository(WeatherDataProvider()),
            child: BlocProvider(
              create: (_) =>
                  WeatherBloc(WeatherRepository(WeatherDataProvider())),
            ),
          )
        ],
        child: const MaterialApp(
            debugShowCheckedModeBanner: false, home: SplashScreen()),
      ),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;
  const DismissKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}
