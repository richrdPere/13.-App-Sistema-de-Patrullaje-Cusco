import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  File? _selectedImage;
  String? _imageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar datos del usuario desde Firebase Firestore
  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _lastNameController.text = doc['lastName'] ?? '';
          _bioController.text = doc['bio'] ?? '';
          _phoneController.text = doc['phone'] ?? '';
          _imageUrl = doc['profileImage'];
        });
      }
    }
  }

  // Seleccionar imagen de la galería
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // Subir imagen a Firebase Storage
  Future<String> _uploadImage(File image) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '';
    final storageRef = FirebaseStorage.instance.ref().child(
        'profileImages/${user.uid}_${DateTime.now().millisecondsSinceEpoch}');
    final uploadTask = storageRef.putFile(image);
    final snapshot = await uploadTask.whenComplete(() {});
    return await snapshot.ref.getDownloadURL();
  }

  // Guardar cambios en Firestore
  Future<void> _saveChanges() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String? updatedImageUrl = _imageUrl;

      // Subir nueva imagen si se seleccionó
      if (_selectedImage != null) {
        updatedImageUrl = await _uploadImage(_selectedImage!);
      }

      // Actualizar Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .update({
        'name': _nameController.text,
        'lastName': _lastNameController.text,
        'bio': _bioController.text,
        'phone': _phoneController.text,
        'profileImage': updatedImageUrl,
      });

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil actualizado con éxito')),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Editar Perfil',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _saveChanges,
            icon: const Icon(Icons.check, color: Colors.blue),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : _imageUrl != null
                              ? NetworkImage(_imageUrl!) as ImageProvider
                              : null,
                      child: _selectedImage == null && _imageUrl == null
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Nombre', _nameController),
                  const SizedBox(height: 10),
                  _buildTextField('Apellido', _lastNameController),
                  const SizedBox(height: 10),
                  _buildTextField('Biografía', _bioController, maxLines: 3),
                  const SizedBox(height: 10),
                  _buildTextField('Teléfono', _phoneController,
                      keyboardType: TextInputType.phone),
                ],
              ),
            ),
    );
  }

  // Widget para crear campos de texto
  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
