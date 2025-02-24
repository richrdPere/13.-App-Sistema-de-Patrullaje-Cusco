import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patrullaje_serenazgo_cusco/screens/map/PatrolMapController.dart';
import 'package:permission_handler/permission_handler.dart';

class PatrolMapScreen extends StatefulWidget {
  const PatrolMapScreen({super.key});

  @override
  _PatrolMapScreenState createState() => _PatrolMapScreenState();
}

class _PatrolMapScreenState extends State<PatrolMapScreen> {
  //late GoogleMapController _mapController;
  final _controller = HomeController();

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  // Solicita permisos de ubicación
  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      setState(() {}); // Refresca la UI
    } else if (status.isDenied || status.isPermanentlyDenied) {
      // Muestra un diálogo o lleva al usuario a configuraciones
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa de Patrullaje')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-13.525, -71.972), // Latitud y longitud inicial
          zoom: 15,
        ),
        myLocationEnabled: true, // Habilita la ubicación actual
        myLocationButtonEnabled: true,
        // onMapCreated: (controller) {
        //   _mapController = controller;
        // },
        onMapCreated: _controller.onMapCreated,
      ),
    );
  }
}
