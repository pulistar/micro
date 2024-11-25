import 'package:flutter/material.dart';

class PlayerDetailsScreen extends StatelessWidget {
  final String playerName;
  final String playerPosition;
  final String playerDescription;
  final String playerWhatsapp;

  // Constructor para recibir los datos del jugador
  const PlayerDetailsScreen({
    super.key,
    required this.playerName,
    required this.playerPosition,
    required this.playerDescription,
    required this.playerWhatsapp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playerName),
        backgroundColor: const Color(0xFF007AFF), // Azul
      ),
      body: Center( // Centrar todo el contenido
        child: SingleChildScrollView( // Permite desplazarse si el contenido es largo
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 8,
              shadowColor: Colors.black.withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar del jugador
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue,
                        child: Text(
                          playerName[0], // Usamos la inicial del nombre del jugador
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Nombre del jugador
                    Center(
                      child: Text(
                        playerName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Posición
                    _buildDetailRow('Posición', playerPosition),
                    const SizedBox(height: 10),

                    // Descripción
                    _buildDetailRow('Descripción', playerDescription),
                    const SizedBox(height: 10),

                    // WhatsApp
                    _buildDetailRow('WhatsApp', playerWhatsapp),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Método para crear una fila con el título y el detalle
  Widget _buildDetailRow(String title, String detail) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title: ',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        Expanded(
          child: Text(
            detail,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
