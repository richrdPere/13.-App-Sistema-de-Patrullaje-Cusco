import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class PositionService {
  /// 📌 Retorna los datos geográficos actuales + dirección
  Future<Map<String, dynamic>> getGeographicData() async {
    final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    final placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    final place = placemarks.first;

    final now = DateTime.now();

    return {
      'timestamp': now,
      'position': position,
      'address':
          "${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''}, ${place.country ?? ''}",
    };
  }
}
