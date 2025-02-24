import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

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

  // Instancia de Firebase Authentication
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void dispose() {
    _descriptionController.dispose();
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
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = "${position.latitude}, ${position.longitude}";
      });
    } catch (e) {
      print("Error obteniendo ubicación: $e");
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reportar Incidente',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Vista previa de la imagen seleccionada
            _imageFile != null
                ? Image.file(_imageFile!, height: 200, fit: BoxFit.cover)
                : Placeholder(fallbackHeight: 200, color: Colors.grey.shade300),

            // Botones para seleccionar medios
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

            // Campo de texto para la descripción del incidente
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Descripción del incidente',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),

            // Botón para obtener la ubicación actual
            ElevatedButton(
              onPressed: _getLocation,
              child: Text(
                _location != null
                    ? "Ubicación: $_location"
                    : "Obtener Ubicación",
                style: TextStyle(color: Colors.black),
              ),
            ),
            SizedBox(height: 16.0),

            // Botón para enviar el reporte
            ElevatedButton(
              onPressed: _uploadReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Enviar Reporte',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
