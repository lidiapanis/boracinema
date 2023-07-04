import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:teste/firebase_options.dart';
import 'package:teste/routes/route_paths.dart';
import 'package:teste/screens/movie_list.dart';
import 'package:teste/screens/register_screen.dart';
import 'package:teste/screens/sign_in_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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

Future<void> findNearestCinema() async {
  Position position = await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );

  String latitude = position.latitude.toString();
  String longitude = position.longitude.toString();

  final mapsUrl = Uri.https(
      'https://www.google.com/maps/search/cinema/@$latitude,$longitude');
  if (await canLaunchUrl(mapsUrl)) {
    await launchUrl(mapsUrl);
  } else {
    throw 'Could not launch $mapsUrl';
  }
}
