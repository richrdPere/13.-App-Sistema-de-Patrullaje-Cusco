import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:patrullaje_serenazgo_cusco/screens/auth/ForgotPasswordScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/auth/LoginScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/auth/RegisterScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/home/HomeScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/home/SplashScreen.dart';
import 'package:patrullaje_serenazgo_cusco/screens/profile/EditProfileScreen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistema de Patrullajes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Cambia la pantalla inicial a SplashScreen
      // initialRoute: 'login',
      routes: {
        'home': (BuildContext context) => HomeScreen(),
        'login': (BuildContext context) => LoginScreen(),
        'register': (BuildContext context) => // Define la ruta de login
            RegisterScreen(), // Define la ruta de registro
        'forgot-password': (BuildContext context) =>
            ForgotPasswordScreen(), //  Define la ruta de olvidaste contraseña
        'profile/edit': (BuildContext context) =>
            const EditProfileScreen(), //  Define la ruta de editar perfil
      },
    );
  }
}
