import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weatherapp/cubit/auth_cubit.dart';
import 'package:weatherapp/screens/loginScreen.dart';
import 'package:weatherapp/screens/weather_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Timer(const Duration(seconds: 3), () async {
              if (!(await Permission.location.request().isGranted)) {
                var status = await Permission.location.request();
                if (!status.isGranted) {
                  print('Location permission denied');
                  return;
                }
              }
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()));
            });
          } else {
            Timer(const Duration(seconds: 3), () async {
              if (!(await Permission.location.request().isGranted)) {
                var status = await Permission.location.request();
                if (!status.isGranted) {
                  print('Location permission denied');
                  return;
                }
              }
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const WeatherScreen()));
            });
          }
          return const Center(
            child: Text("Weather"),
          );
        },
      ),
    );
  }
}
