import 'package:flutter/material.dart';
import 'package:movie_app/helpers/http_helper.dart';
import 'package:movie_app/models/theme_object.dart';
import 'package:movie_app/providers/auth_provider.dart';
import 'package:movie_app/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'providers/movie_provider.dart';

void main() {
  const bearer =
      'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiOGQ3Zjc2OTQ3OTA0YTAxMTI4NmRjNzMyYzU1MjM0ZSIsInN1YiI6IjYwMzM3ODBiMTEzODZjMDAzZjk0ZmM2YiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XYuIrLxvowrkevwKx-KhOiOGZ2Tn-R8tEksXq842kX4';

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(bearer),
        ),
        ChangeNotifierProvider<MovieProvider>(
          create: (context) => MovieProvider(apiService: ApiService(
              bearer:
                  Provider.of<AuthProvider>(context, listen: false).bearerToken,
            ),),
        ),
        ChangeNotifierProvider<MovieProvider>(
          create: (context) => MovieProvider(
            apiService: ApiService(
              bearer:
                  Provider.of<AuthProvider>(context, listen: false).bearerToken,
            ),
          )..initialize(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Movies',
      theme: appTheme,
      home: const SplashScreen(),
    );
  }
}
