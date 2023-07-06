import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teste/firebase_options.dart';
import 'package:teste/routes/route_paths.dart';
import 'package:teste/screens/movie_list.dart';
import 'package:teste/screens/register_screen.dart';
import 'package:teste/screens/sign_in_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(BoraCinema());
}

class BoraCinema extends StatelessWidget {
  const BoraCinema({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        RoutePaths.SIGNINSCREEN: (context) => SignInScreen(),
        RoutePaths.MOVIELIST: (context) => MovieList(),
        RoutePaths.REGISTER: (context) => RegisterScreen(),
      },
    );
  }
}

