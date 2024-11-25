import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'create_match_screen.dart';
import 'match_details_screen.dart';
import 'player_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';  // Importa la nueva pantalla de configuración

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MicroFútbol'),
        backgroundColor: const Color(0xFF007AFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Get.to(() => const SettingsScreen());  // Navegar a la pantalla de configuración
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // GridView de los menús
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildMenuItem(
                    icon: Icons.person,
                    label: 'Mi Perfil',
                    onTap: () {
                      Get.to(() => const ProfileScreen());
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.add_circle_outline,
                    label: 'Crear Partido',
                    onTap: () {
                      Get.to(() => const CreateMatchScreen());
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.sports_soccer,
                    label: 'Mis Partidos',
                    onTap: () {
                      // Aquí puedes añadir la lógica para redirigir a la pantalla de partidos
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.group,
                    label: 'Jugadores',
                    onTap: () {
                      Get.to(() => const PlayersScreen());
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Título "Partidos"
              const Text(
                'Partidos',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Lista de partidos
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('partidos').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final partidos = snapshot.data!.docs;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: partidos.length,
                    itemBuilder: (context, index) {
                      final partido = partidos[index];
                      final partidoId = partido.id; // Obtenemos el ID del partido
                      final nombre = partido['nombre'];
                      final tipoPartido = partido['tipo_partido'];
                      final fecha = partido['fecha'].toDate();

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('$tipoPartido - ${DateFormat('dd/MM/yyyy').format(fecha)}'),
                          onTap: () {
                            // Navegar a la pantalla de detalles del partido
                            Get.to(() => MatchDetailScreen(partidoId: partidoId));
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget para construir las opciones del menú
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: const Color(0xFF007AFF),
              ),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF007AFF),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
