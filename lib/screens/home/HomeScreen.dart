import 'package:flutter/material.dart';
import 'package:patrullaje_serenazgo_cusco/screens/alerts/IncidentAlertScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/chats/ChatsScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/map/PatrolMapScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/profile/ProfileScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/report/IncidentReportScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/resume/ResumeScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // Lista de widgets que representan las pantallas
  final List<Widget> _screens = [
    Center(child: ResumeScreen()), // Resume
    Center(child: PatrolMapScreen()), // Mapa Interactivo
    //Center(child: Text('Búsqueda', style: TextStyle(fontSize: 24))), // Búsqueda
    Center(child: IncidentReportScreen()), // Publicaciones
    Center(child: ChatsScreen()), // Chats
    Center(child: IncidentAlertScreen()), // Alerta - Notificaciones

    // const Center(
    //   child: ProfileScreen(),
    // ), // Perfil
    // const Center(
    //   child: FeedScreen(),
    // ), // Feed
    // const Center(
    //   child: SearchScreen(),
    // ), // Búsqueda
    // Center(
    //   child: CreatePostScreen(),
    // ), // Publicaciones
    // const Center(
    //   child: ProfileScreen(),
    // ), // Perfil
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sistema de Patrullaje',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        // title: Image.asset(
        //   'assets/img/logo.png', // Cambia por la ruta de tu logo
        //   height: 150,
        // ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        centerTitle: true,
      ),
      body: _screens[_currentIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Principal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.search_outlined),
          //   activeIcon: Icon(Icons.search),
          //   label: 'Buscar',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pages_outlined),
            activeIcon: Icon(Icons.pages),
            label: 'Reportar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            activeIcon: Icon(Icons.notifications),
            label: 'Alertas',
          ),
        ],
      ),
    );
  }
}
