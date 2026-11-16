import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';

class AiService {
  late final FirebaseAI _ai;
  late final GenerativeModel _model;

  AiService() {
    // Inicializa el servicio de Firebase AI Logic
    _ai = FirebaseAI.googleAI();
    // Elige un modelo de la lista de modelos compatibles.
    // 'gemini-3-flash-preview' es una opción potente y actual.
    // Puedes consultar la lista completa en la documentación de Firebase.
    _model = _ai.generativeModel(
      model: 'gemini-3-flash-preview',
    ); //[reference:7][reference:8]
  }

  Future<String> getRecommendation(List<Task> tasks) async {
    final pendingTasks = tasks.where((t) => !t.isComplete).toList();
    if (pendingTasks.isEmpty) {
      return '¡Felicidades! No tienes tareas pendientes.';
    }

    final taskList = pendingTasks
        .map(
          (t) =>
              '- ${t.title} (Prioridad: ${t.priority}, Fecha: ${t.duaDate.toIso8601String().split('T').first})',
        )
        .join('\n');

    final prompt =
        '''
    Eres un asistente de productividad. El usuario tiene estas tareas pendientes:
    $taskList
    Proporciona un consejo breve (máximo 3 oraciones) sobre cómo priorizar estas tareas.
    ''';

    try {
      final response = await _model.generateContent([Content.text(prompt)]);
      // La respuesta ahora es un objeto 'GenerateContentResponse'
      return response.text ?? 'No se pudo generar una recomendación.';
    } catch (e) {
      // El manejo de errores es más limpio, ya que Firebase gestiona la autenticación.
      debugPrint('Error con Firebase AI: $e');
      return 'Error al conectar con la IA. Revisa la consola para más detalles.';
    }
  }
}
