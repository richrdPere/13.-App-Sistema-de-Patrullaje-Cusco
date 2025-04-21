import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeController {
  late GoogleMapController mapController;
  Set<Polygon> polygons = {};
  DateTime? selectedDate;

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _loadPolygons(); // Carga inicial
  }

  void _loadPolygons() {
    polygons = {
      Polygon(
        polygonId: const PolygonId('zonaA'),
        points: [
          LatLng(-13.524, -71.973),
          LatLng(-13.524, -71.971),
          LatLng(-13.526, -71.971),
          LatLng(-13.526, -71.973),
        ],
        fillColor: Colors.green.withOpacity(0.4),
        strokeColor: Colors.green,
        strokeWidth: 2,
        visible: selectedDate == null ||
            selectedDate!.toIso8601String().startsWith("2025-04-13"),
      ),
      Polygon(
        polygonId: const PolygonId('zonaB'),
        points: [
          LatLng(-13.527, -71.974),
          LatLng(-13.527, -71.972),
          LatLng(-13.529, -71.972),
          LatLng(-13.529, -71.974),
        ],
        fillColor: Colors.red.withOpacity(0.4),
        strokeColor: Colors.red,
        strokeWidth: 2,
        visible: selectedDate == null ||
            selectedDate!.toIso8601String().startsWith("2025-04-12"),
      ),
    };
  }

  void filterPolygonsByDate(DateTime date) {
    selectedDate = date;
    _loadPolygons(); // Actualiza visibilidad según la fecha
  }

  Set<Polygon> getPolygons() => polygons;
}
