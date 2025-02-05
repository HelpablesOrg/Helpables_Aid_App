// ignore: file_names
import 'package:http/http.dart' as http;
import 'dart:convert';

const GOOGLE_API_KEY = 'AIzaSyDUdvTcrvbKWmBYBub0rRsZkhSw_SB07Xk';

class LocationHelper {
  static String generateLocationImage(
      {required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=13&size=300x200&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }

  static Future<String> getLocationAddress(double lat, double lng) async {
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY'));
    final data = json.decode(response.body);
    print("data $data");
    if (data['results'] != null && data['results'].isNotEmpty) {
      return data['results'][0]['formatted_address'];
    } else {
      throw Exception('No address found for the given location');
    }
  }
}
