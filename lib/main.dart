// lib/main.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (kDebugMode) debugPrint('Inicializando Firebase...');
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'TU_API_KEY',
        appId: '1:439496111766:android:b743b97bb24e624129b4b7',
        messagingSenderId: '439496111766',
        projectId: 'taskmind-e0775',
      ),
    );
    if (kDebugMode) debugPrint('Firebase inicializado correctamente');
  } catch (e, stack) {
    // ESTO es clave: si falla, lo verás en la consola
    if (kDebugMode) {
      debugPrint('ERROR al inicializar Firebase: $e');
      debugPrint('$stack');
    }
  }

  runApp(const TaskMindApp());
}

class TaskMindApp extends StatelessWidget {
  const TaskMindApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TaskMind',
      theme: AppTheme.darkTheme,
      home: const HomeScreen(),
    );
  }
}
