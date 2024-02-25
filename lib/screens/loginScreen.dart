import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/cubit/auth_cubit.dart';
import 'package:weatherapp/screens/signupScreen.dart';
import 'package:weatherapp/screens/weather_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: passController,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () {
                  if (emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Email can not be empty")));
                    return;
                  }
                  if (passController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("password can not be empty")));
                    return;
                  }
                  context
                      .read<AuthBloc>()
                      .signIn(emailController.text.trim(),
                          passController.text.trim())
                      .then((value) {
                    return Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const WeatherScreen()),
                        (route) => false);
                  });
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Colors.blue),
                  child: const Center(
                    child: Text("Login"),
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignUpScreen()));
                  },
                  child: const Text('SignUp'))
            ],
          ),
        ),
      ),
    );
  }
}
