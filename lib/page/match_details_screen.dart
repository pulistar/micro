import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart'; // Para formatear fechas

class MatchDetailScreen extends StatelessWidget {
  final String partidoId;

  const MatchDetailScreen({super.key, required this.partidoId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Partido'),
        backgroundColor: const Color(0xFF007AFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Detalles del partido
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('partidos')
                    .doc(partidoId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final partido = snapshot.data!;
                  final nombre = partido['nombre'];
                  final ubicacion = partido['ubicacion'];
                  final tipoPartido = partido['tipo_partido'];
                  final genero = partido['genero'];
                  final fecha = partido['fecha'].toDate();
                  final apuesta = partido['apuesta'];
                  final comentario = partido['comentario'];
                  final whatsapp = partido['whatsapp']; // Obtener el número de WhatsApp

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Título con nombre del partido
                      Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            nombre,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF007AFF),
                            ),
                          ),
                        ),
                      ),

                      // Detalles del partido
                      _buildDetailCard('Ubicación', ubicacion, Icons.location_on),
                      _buildDetailCard('Tipo de Partido', tipoPartido, Icons.sports_soccer),
                      _buildDetailCard('Género', genero, Icons.group),
                      _buildDetailCard(
                        'Fecha',
                        DateFormat('dd/MM/yyyy').format(fecha),
                        Icons.calendar_today,
                      ),
                      _buildDetailCard(
                        'Hora',
                        DateFormat('HH:mm').format(fecha),
                        Icons.access_time,
                      ),
                      _buildDetailCard('Apuesta', '\$${apuesta.toStringAsFixed(2)}', Icons.monetization_on),
                      _buildDetailCard('Comentario', comentario, Icons.comment),

                      // Mostrar el número de WhatsApp si está disponible
                      if (whatsapp != null && whatsapp.isNotEmpty)
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                // Ícono de WhatsApp usando font_awesome_flutter
                                Icon(FontAwesomeIcons.whatsapp, color: Colors.green, size: 30),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    'Número de WhatsApp: $whatsapp',
                                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir las tarjetas de detalle
  Widget _buildDetailCard(String title, String value, IconData icon) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 30, color: const Color(0xFF007AFF)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
