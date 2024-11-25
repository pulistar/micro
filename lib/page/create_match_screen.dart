import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

import 'home_screen.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({super.key});

  @override
  _CreateMatchScreenState createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  final TextEditingController _matchNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController(); // Controlador para el número de WhatsApp
  
  DateTime? _matchDate;
  TimeOfDay? _matchTime;

  String? _matchType = 'Micro'; // Valor por defecto
  String? _gender = 'Masculino'; // Valor por defecto

  // Función para seleccionar la fecha
  _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      setState(() {
        _matchDate = selectedDate;
      });
    }
  }

  // Función para seleccionar la hora
  _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        _matchTime = selectedTime;
      });
    }
  }

  // Función para crear el partido en Firestore
  _createMatch() async {
    if (_matchNameController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _matchDate == null ||
        _matchTime == null ||
        _betController.text.isEmpty ||
        _commentController.text.isEmpty ||
        _whatsappController.text.isEmpty) { // Verificar si el número de WhatsApp está vacío
      Get.snackbar('Error', 'Por favor, completa todos los campos.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final matchData = {
      'nombre': _matchNameController.text,
      'ubicacion': _locationController.text,
      'fecha': Timestamp.fromDate(DateTime(
        _matchDate!.year,
        _matchDate!.month,
        _matchDate!.day,
        _matchTime!.hour,
        _matchTime!.minute,
      )),
      'tipo_partido': _matchType,
      'genero': _gender,
      'apuesta': double.tryParse(_betController.text) ?? 0.0,
      'comentario': _commentController.text,
      'whatsapp': _whatsappController.text, // Guardar el número de WhatsApp
      'creado_por': 'usuarioId', // Aquí debes agregar el ID del usuario
    };

    try {
      // Guardar el partido en Firestore
      await FirebaseFirestore.instance.collection('partidos').add(matchData);

      // Mostrar el mensaje de éxito y redirigir
      Get.snackbar('Éxito', 'Partido creado con éxito',
          snackPosition: SnackPosition.BOTTOM);
      Get.off(() => const HomeScreen()); // Redirige a HomeScreen
    } catch (e) {
      Get.snackbar('Error', 'Hubo un error al crear el partido',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Partido'),
        backgroundColor: const Color(0xFF007AFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Campo de nombre del partido
              TextField(
                controller: _matchNameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre del Partido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de ubicación
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Selector de fecha
              Row(
                children: [
                  Text(
                    _matchDate == null
                        ? 'Fecha: No seleccionada'
                        : 'Fecha: ${DateFormat('dd/MM/yyyy').format(_matchDate!)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectDate,
                    child: const Text('Seleccionar Fecha'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector de hora
              Row(
                children: [
                  Text(
                    _matchTime == null
                        ? 'Hora: No seleccionada'
                        : 'Hora: ${_matchTime!.format(context)}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _selectTime,
                    child: const Text('Seleccionar Hora'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Selector de tipo de partido
              DropdownButtonFormField<String>(
                value: _matchType,
                items: const [
                  DropdownMenuItem(child: Text('Micro'), value: 'Micro'),
                  DropdownMenuItem(child: Text('Fútbol 8'), value: 'Fútbol 8'),
                  DropdownMenuItem(child: Text('Fútbol 11'), value: 'Fútbol 11'),
                ],
                onChanged: (value) {
                  setState(() {
                    _matchType = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Tipo de Partido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Selector de género
              DropdownButtonFormField<String>(
                value: _gender,
                items: const [
                  DropdownMenuItem(child: Text('Masculino'), value: 'Masculino'),
                  DropdownMenuItem(child: Text('Femenino'), value: 'Femenino'),
                  DropdownMenuItem(child: Text('Mixto'), value: 'Mixto'),
                ],
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Género',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo de apuesta
              TextField(
                controller: _betController,
                decoration: const InputDecoration(
                  labelText: 'Apuesta',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: 16),

              // Campo de comentario
              TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: 'Comentario (Opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Campo para el número de WhatsApp
              TextField(
                controller: _whatsappController,
                decoration: const InputDecoration(
                  labelText: 'Número de WhatsApp',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone, // Tipo de teclado para números
              ),
              const SizedBox(height: 20),

              // Botón para crear el partido
              Center(
                child: ElevatedButton(
                  onPressed: _createMatch,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    backgroundColor: const Color(0xFF007AFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Crear Partido'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
