import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CompleteProfileScreen extends StatelessWidget {
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController(); // Controlador para el número de WhatsApp
  final RxString _gender = ''.obs;
  final RxString _position = ''.obs;
  final GetStorage storage = GetStorage();

  CompleteProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completar Perfil'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)], // Azul oscuro
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Completar Perfil',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          labelText: 'Apodo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Campo para el número de WhatsApp
                      TextField(
                        controller: _whatsappController,
                        decoration: InputDecoration(
                          labelText: 'Número de WhatsApp',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          prefixIcon: const Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone, // Para números
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Género',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            RadioListTile<String>(
                              title: const Text('Masculino'),
                              value: 'Masculino',
                              groupValue: _gender.value,
                              onChanged: (value) => _gender.value = value ?? '',
                            ),
                            RadioListTile<String>(
                              title: const Text('Femenino'),
                              value: 'Femenino',
                              groupValue: _gender.value,
                              onChanged: (value) => _gender.value = value ?? '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Posición',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            RadioListTile<String>(
                              title: const Text('Jugador'),
                              value: 'Jugador',
                              groupValue: _position.value,
                              onChanged: (value) => _position.value = value ?? '',
                            ),
                            RadioListTile<String>(
                              title: const Text('Arquero'),
                              value: 'Arquero',
                              groupValue: _position.value,
                              onChanged: (value) => _position.value = value ?? '',
                            ),
                            RadioListTile<String>(
                              title: const Text('Ambos'),
                              value: 'Ambos',
                              groupValue: _position.value,
                              onChanged: (value) => _position.value = value ?? '',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 15),
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    String nickname = _nicknameController.text.trim();
    String whatsapp = _whatsappController.text.trim(); // Capturar número de WhatsApp
    String gender = _gender.value;
    String position = _position.value;

    if (nickname.isEmpty || gender.isEmpty || position.isEmpty || whatsapp.isEmpty) {
      Get.snackbar(
        'Error',
        'Por favor, completa todos los campos.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // Obtén los datos del usuario logueado desde el almacenamiento local
      Map<String, dynamic> loggedInUser =
          storage.read('loggedInUser') as Map<String, dynamic>;

      // Actualiza los datos del perfil en Firestore
      await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(loggedInUser['id']) // Usa el ID del documento del usuario
          .update({
        'apodo': nickname,
        'genero': gender,
        'posicion': position,
        'whatsapp': whatsapp, // Agregar el número de WhatsApp
      });

      Get.snackbar(
        'Éxito',
        'Perfil completado correctamente.',
        snackPosition: SnackPosition.BOTTOM,
      );

      // Redirigir a la página principal (HomeScreen o similar)
      Get.offAllNamed('/home');
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo completar el perfil: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
