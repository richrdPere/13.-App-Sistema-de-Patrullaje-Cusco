import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:patrullaje_serenazgo_cusco/screens/map/PatrolMapController.dart';
import 'package:patrullaje_serenazgo_cusco/screens/profile/ProfileScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class PatrolMapScreen extends StatefulWidget {
  const PatrolMapScreen({super.key});

  @override
  _PatrolMapScreenState createState() => _PatrolMapScreenState();
}

class _PatrolMapScreenState extends State<PatrolMapScreen> {
  //late GoogleMapController _mapController;
  final _controller = HomeController();
  DateTime? _selectedDate;

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

  void _pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _controller.filterPolygonsByDate(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    //final Color secondaryColor = isDarkMode ? Colors.greenAccent : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mapa de Patrullaje',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickDate,
        label: const Text("Filtrar por Fecha"),
        icon: const Icon(Icons.calendar_today),
        backgroundColor: primaryColor,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(-13.525, -71.972), // Latitud y longitud inicial
          zoom: 15,
        ),
        myLocationEnabled: true, // Habilita la ubicación actual
        myLocationButtonEnabled: true,
        onMapCreated: _controller.onMapCreated,
        polygons: _controller.getPolygons(),
      ),
    );
  }
}
