// ignore: file_names
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class LocationHelper {
  static final FlutterSecureStorage _storage = FlutterSecureStorage();
  static Future<void> saveApiKey(String key) async {
    await _storage.write(key: 'GOOGLE_API_KEY', value: key);
  }
  static Future<String?> getApiKey() async {
    return await _storage.read(key: 'GOOGLE_API_KEY');
  }
  static Future<String> generateLocationImage({
    required double latitude,
    required double longitude,
  }) async {
    final apiKey = await getApiKey();
    if (apiKey == null) {
      throw Exception('API Key is missing! Please save it first.');
    }
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude'
        '&zoom=13&size=300x200&maptype=roadmap'
        '&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$apiKey';
  }
  static Future<String> getLocationAddress(double lat, double lng) async {
    final apiKey = await getApiKey();
    if (apiKey == null) {
      throw Exception('API Key is missing! Please save it first.');
    }
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch location. Status Code: ${response.statusCode}');
      }
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      } else {
        throw Exception('No address found for the given location');
      }
    } catch (error) {
      print('Error fetching location: $error');
      rethrow;
    }
  }
}