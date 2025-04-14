import 'package:geocoding/geocoding.dart';

class AddressService {
  /// 📌 Retorna la dirección a partir de coordenadas
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      final placemarks = await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;

        final address = [
          place.street,
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.country
        ].where((part) => part != null && part!.isNotEmpty).join(', ');

        return address;
      } else {
        return "Dirección no disponible";
      }
    } catch (e) {
      print("❌ Error al obtener dirección: $e");
      return "Error al obtener dirección";
    }
  }
}
