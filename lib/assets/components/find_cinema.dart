import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

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
