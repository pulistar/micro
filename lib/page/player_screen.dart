import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'player_details_screen.dart'; // Importa la pantalla de detalles del jugador

class PlayersScreen extends StatelessWidget {
  const PlayersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jugadores'),
        backgroundColor: const Color(0xFF007AFF), // Azul
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('usuarios').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No hay jugadores disponibles.'));
          }

          final players = snapshot.data!.docs;

          return ListView.builder(
            itemCount: players.length,
            itemBuilder: (context, index) {
              var player = players[index];
              var playerName = player['nombre'];
              var playerPosition = player['posicion'];
              var playerDescription = player['descripcion'] ?? 'Sin descripción';
              var playerWhatsapp = player['whatsapp'] ?? 'No disponible';

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 5,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(playerName),
                  subtitle: Text('Posición: $playerPosition'),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(playerName[0]), // Inicial del nombre
                  ),
                  onTap: () {
                    // Navegar a la pantalla de detalles del jugador
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlayerDetailsScreen(
                          playerName: playerName,
                          playerPosition: playerPosition,
                          playerDescription: playerDescription,
                          playerWhatsapp: playerWhatsapp,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
