import 'dart:convert';
import 'package:http/http.dart' as http;



 const GOOGLE_API_KEY = "AIzaSyDNZMjI6BykptQrTCZJiPX2iEwBmd9UZUU";
//
// class LocationHelper {
//   static String generateLocationPreviewImage({double latitude, double longitude,}) {
//     return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
//   }
// }

class LocationHelper {
  static String generateLocationPreviewImage({
    required double latitude,
    required double longitude,
  }) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$latitude,$longitude&key=$GOOGLE_API_KEY';
  }



  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$GOOGLE_API_KEY';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['results'].isNotEmpty) {
        return jsonResponse['results'][0]['formatted_address'];
      } else {
        return 'No address found';
      }
    } else {
      throw Exception('Failed to load address');
    }
  }

}