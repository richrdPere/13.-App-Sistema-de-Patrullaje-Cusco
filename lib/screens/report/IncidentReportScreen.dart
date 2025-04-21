import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:patrullaje_serenazgo_cusco/screens/profile/ProfileScreen.dart';
import 'dart:io';

import 'dart:async';

import 'package:patrullaje_serenazgo_cusco/services/AddressService.dart';

class IncidentReportScreen extends StatefulWidget {
  @override
  _IncidentReportScreenState createState() => _IncidentReportScreenState();
}

class _IncidentReportScreenState extends State<IncidentReportScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  // Variables para almacenar las fotos, videos y audios seleccionados
  File? _imageFile;
  File? _videoFile;
  File? _audioFile;

  // Variable para almacenar la ubicación
  String? _location;
  DateTime currentTime = DateTime.now();
  Position? currentPosition;
  String? _direccion;
  Timer? _timer;

  // Variables locales
  String? _Lat;
  String? _Lon;

  // Instancia de Firebase Authentication
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _startClock(); // ⏰ Iniciar reloj en tiempo real
    _getLocation(); // 📍 Obtener ubicación GPS al iniciar
  }

  /// ⏰ Iniciar el temporizador para actualizar la hora cada segundo
  void _startClock() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _timer?.cancel(); // ❌ Detener el temporizador al salir de la pantalla
    super.dispose();
  }

  /// Método para seleccionar imágenes o videos desde la cámara o galería
  Future<void> _pickMedia(ImageSource source, String type) async {
    final picker = ImagePicker();
    XFile? pickedFile;

    // Selección de imagen o video según el tipo especificado
    if (type == 'image') {
      pickedFile = await picker.pickImage(source: source);
    } else if (type == 'video') {
      pickedFile = await picker.pickVideo(source: source);
    }

    if (pickedFile != null) {
      setState(() {
        if (type == 'image') {
          _imageFile = File(pickedFile!.path);
        } else if (type == 'video') {
          _videoFile = File(pickedFile!.path);
        }
      });
    }
  }

  /// Método para obtener la ubicación actual del usuario
  Future<void> _getLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    final pos = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    if (mounted) {
      final addressService = AddressService();
      final direccionObtenida = await addressService.getAddressFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      setState(() {
        currentPosition = pos;
        _direccion = direccionObtenida;
      });
    }
  }

  /// Método para subir los datos del reporte a Firebase
  Future<void> _uploadReport() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    final storage = FirebaseStorage.instance;

    String? imageUrl;
    String? videoUrl;
    String? audioUrl;

    // Subir imagen a Firebase Storage
    if (_imageFile != null) {
      final imageRef = storage
          .ref()
          .child('incident_reports/${user.uid}/images/${DateTime.now()}.jpg');
      await imageRef.putFile(_imageFile!);
      imageUrl = await imageRef.getDownloadURL();
    }

    // Subir video a Firebase Storage
    if (_videoFile != null) {
      final videoRef = storage
          .ref()
          .child('incident_reports/${user.uid}/videos/${DateTime.now()}.mp4');
      await videoRef.putFile(_videoFile!);
      videoUrl = await videoRef.getDownloadURL();
    }

    // Subir audio a Firebase Storage (si existe)
    if (_audioFile != null) {
      final audioRef = storage
          .ref()
          .child('incident_reports/${user.uid}/audios/${DateTime.now()}.mp3');
      await audioRef.putFile(_audioFile!);
      audioUrl = await audioRef.getDownloadURL();
    }

    // Guardar datos en Firestore
    await firestore.collection('incident_reports').add({
      'userId': user.uid,
      'description': _descriptionController.text,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'audioUrl': audioUrl,
      'location': _location,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Mostrar mensaje de éxito
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Reporte enviado con éxito')));

    _clearForm();
  }

  // Formatear los datos
  String _formatDate(DateTime dt) {
    return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} — "
        "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
  }

  /// Método para limpiar el formulario después de enviar el reporte
  void _clearForm() {
    setState(() {
      _descriptionController.clear();
      _imageFile = null;
      _videoFile = null;
      _audioFile = null;
      _location = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color primaryColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    final Color secondaryColor = isDarkMode ? Colors.greenAccent : Colors.green;

    final gps = currentPosition;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reportar Incidente',
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1.- Cuadro con la ubicación actual
            // Fecha
            Text(
              "📅 ${_formatDate(currentTime)}",
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 4),

            // Latitud / Longitud
            if (gps != null)
              Text(
                "📍 Lat: ${gps.latitude.toStringAsFixed(6)}  "
                "Lon: ${gps.longitude.toStringAsFixed(6)}",
                style: const TextStyle(color: Colors.black),
              )
            else
              const Text("📍 Obteniendo ubicación...",
                  style: TextStyle(color: Colors.black)),
            const SizedBox(height: 4),

            // Dirección
            if (_direccion != null)
              Text(
                "📌 Dirección: $_direccion",
                style: const TextStyle(color: Colors.black),
              )
            else
              const Text("📌 Obteniendo dirección...",
                  style: TextStyle(color: Colors.black)),

            SizedBox(height: 16.0),

            // 2.- Campo de texto para la descripción del incidente
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción del incidente',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),

            // 3.- Vista previa de la imagen seleccionada
            _imageFile != null
                ? Image.file(_imageFile!, height: 200, fit: BoxFit.cover)
                : Placeholder(fallbackHeight: 200, color: Colors.grey.shade300),

            // 4.- Botones para seleccionar medios
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () => _pickMedia(ImageSource.camera, 'image'),
                ),
                IconButton(
                  icon: Icon(Icons.image),
                  onPressed: () => _pickMedia(ImageSource.gallery, 'image'),
                ),
                IconButton(
                  icon: Icon(Icons.videocam),
                  onPressed: () => _pickMedia(ImageSource.camera, 'video'),
                ),
              ],
            ),
            SizedBox(height: 16.0),

            // 5.- Botón para enviar el reporte
            // ElevatedButton(
            //   onPressed: _uploadReport,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //   ),
            //   child: Text(
            //     'Enviar Reporte',
            //     style: TextStyle(color: Colors.black),
            //   ),
            // ),
            Center(
              child: GestureDetector(
                onTap: _uploadReport,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.red, // 🔴 Color rojo para emergencia
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'ALERTA',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
