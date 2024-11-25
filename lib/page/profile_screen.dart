import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GetStorage storage = GetStorage();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController(); // Controlador para el número de WhatsApp
  String? _userName;
  String? _userEmail;
  String? _userNickname;
  String? _userPosition;
  String? _userDescription;
  String? _userWhatsapp;
  bool _isOwner = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Cargar los datos del usuario desde el almacenamiento local
  _loadUserData() {
    var userData = storage.read('loggedInUser');
    if (userData != null) {
      setState(() {
        _userName = userData['nombre']; // Nombre del usuario
        _userEmail = userData['correo']; // Correo del usuario
        _userNickname = userData['apodo']; // Apodo del usuario
        _userPosition = userData['posicion']; // Posición del usuario
        _userDescription = userData['descripcion'] ?? ''; // Descripción
        _userWhatsapp = userData['whatsapp']; // Número de WhatsApp
        _descriptionController.text = _userDescription ?? '';
        _whatsappController.text = _userWhatsapp ?? '';
        _isOwner = userData['id'] == userData['id']; // Verifica si es el dueño
      });
    }
  }

  // Guardar la descripción y el número de WhatsApp
  _saveProfile() async {
    var userData = storage.read('loggedInUser');
    if (userData != null) {
      String userId = userData['id'];
      await FirebaseFirestore.instance.collection('usuarios').doc(userId).update({
        'descripcion': _descriptionController.text,
        'whatsapp': _whatsappController.text, // Guardar el número de WhatsApp
      });

      // Actualiza los datos en el almacenamiento local
      userData['descripcion'] = _descriptionController.text;
      userData['whatsapp'] = _whatsappController.text;
      storage.write('loggedInUser', userData);

      Get.snackbar('Éxito', 'Perfil actualizado', snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: const Color(0xFF007AFF), // Azul en lugar del verde
      ),
      body: SingleChildScrollView( // Usamos SingleChildScrollView para que el contenido se desplace
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Card para todo el contenido
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 5,
                color: Colors.white, // Fondo blanco para la Card
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Avatar de perfil (Icono como foto de perfil)
                      CircleAvatar(
                        radius: 60, // Tamaño del avatar
                        backgroundColor: const Color.fromARGB(255, 168, 57, 57), // Color de fondo
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.white,
                        ), // Ícono de la foto de perfil
                      ),
                      const SizedBox(height: 20),

                      // Nombre del usuario
                      _userName != null
                          ? Text(
                              _userName!,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black, // Texto negro
                              ),
                            )
                          : const CircularProgressIndicator(),
                      const SizedBox(height: 10),

                      // Apodo y posición
                      _userNickname != null
                          ? Text(
                              'Apodo: $_userNickname',
                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(height: 5),
                      _userPosition != null
                          ? Text(
                              'Posición: $_userPosition',
                              style: const TextStyle(fontSize: 18, color: Colors.black54),
                            )
                          : const SizedBox.shrink(),

                      const SizedBox(height: 20),

                      // Descripción
                      const Text(
                        'Descripción:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black, // Color de texto negro
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Mostrar descripción solo si es el dueño del perfil
                      _isOwner
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    hintText: 'Escribe una descripción...',
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white, // Fondo blanco para el campo de texto
                                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  ),
                                  maxLines: 5,
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _saveProfile,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                                    backgroundColor: const Color(0xFF007AFF), // Azul en lugar de verde
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: const Text('Guardar Perfil'),
                                ),
                              ],
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                _userDescription ?? 'No hay descripción disponible',
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            ),

                      const SizedBox(height: 20),

                      // Mostrar el número de WhatsApp (solo lectura)
                      _isOwner
                          ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                'Número de WhatsApp: ${_userWhatsapp ?? 'No disponible'}',
                                style: const TextStyle(fontSize: 16, color: Colors.black),
                              ),
                            )
                          : const SizedBox.shrink(), // No mostrar si no es el dueño
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
