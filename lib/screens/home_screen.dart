import 'package:flutter/material.dart';
import 'package:taskmind/database/database_helper.dart';

import '../models/task.dart';
import '../theme/app_theme.dart';
import '../widgets/task_card.dart';
import 'task_form_screen.dart';
import '../services/ai_service.dart';
import '../widgets/summary_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  late final AiService _aiService = AiService();
  String? _aiRecommendation;
  bool _aiLoading = false;

  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTask();
  }

  Future<void> _fetchAiRecommendation() async {
    if (_tasks.isEmpty) return;

    setState(() {
      _aiLoading = true;
      _aiRecommendation = null;
    });

    final recommendation = await _aiService.getRecommendation(_tasks);

    if (!mounted) return;

    setState(() {
      _aiRecommendation = recommendation;
      _aiLoading = false;
    });
  }

  Future<void> _loadTask() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final tasks = await DatabaseHelper.instance.getTask();

      if (!mounted) return;

      setState(() {
        _tasks = tasks;
        _isLoading = false;
      });

      if (_tasks.isNotEmpty) {
        _fetchAiRecommendation();
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  int get _pendingTasks => _tasks.where((task) => !task.isComplete).length;

  int get _completedTasks => _tasks.where((task) => task.isComplete).length;

  Future<void> _openTaskForm({Task? task}) async {
    final result = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
    );

    if (result == null || !mounted) return;

    try {
      if (task == null) {
        await DatabaseHelper.instance.insertTask(result);
      } else {
        await DatabaseHelper.instance.updateTask(result);
      }
      await _loadTask();
    } catch (e) {
      if (!mounted) return;

      _showMessage('No se puede guardar la tarea: $e');
    }
  }

  Future<void> _toggleTask(Task task) async {
    final updatedTask = task.copyWhith(isComplete: !task.isComplete);

    try {
      await DatabaseHelper.instance.updateTask(updatedTask);
      await _loadTask();
    } catch (e) {
      if (!mounted) return;

      _showMessage('No se pudo actualizar la tarea.');
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: const Text('Eliminar tarea'),
        content: Text('¿Deseas eliminar"${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: AppTheme.danger),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await DatabaseHelper.instance.deleteTask(task.id!);
      await _loadTask();
    } catch (e) {
      if (!mounted) return;

      _showMessage('No se pudo eliminar la tarea');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final sortedTask = List<Task>.from(_tasks)
      ..sort((a, b) => a.duaDate.compareTo(b.duaDate));

    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primary),
              )
            : _error != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsetsGeometry.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline, color: AppTheme.danger),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: _loadTask,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TASKMIND',
                              style: TextStyle(
                                color: AppTheme.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 7),
                            const Text(
                              '¡Hola!',
                              style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Organiza tu día y alcanza tus metas.',
                              style: TextStyle(
                                color: AppTheme.textsecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: AppTheme.secondary,
                          child: Icon(
                            Icons.person_outline,
                            color: AppTheme.primary,
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Tu actividad',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        SummaryCard(
                          title: 'Pendientes',
                          count: _pendingTasks,
                          icon: Icons.pending_actions,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 12),
                        SummaryCard(
                          title: 'Completadas',
                          count: _completedTasks,
                          icon: Icons.task_alt,
                          color: AppTheme.success,
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mis tareas',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_tasks.length} en total',
                          style: const TextStyle(
                            color: AppTheme.textsecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    if (sortedTask.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: AppTheme.surface,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.task_alt,
                              color: AppTheme.success,
                              size: 40,
                            ),
                            SizedBox(height: 12),
                            Text(
                              '¡Todo al día!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'No tienes tareas pendientes.',
                              style: TextStyle(
                                color: AppTheme.textsecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...sortedTask.map(
                        (task) => TaskCard(
                          task: task,
                          onToggle: () => _toggleTask(task),
                          onEdit: () => _openTaskForm(task: task),
                          onDelete: () => _deleteTask(task),
                        ),
                      ),

                    const SizedBox(height: 25),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppTheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: AppTheme.primary,
                              ),
                              const SizedBox(width: 9),
                              const Text(
                                'TaskMind AI',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              if (_aiLoading)
                                const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              else
                                IconButton(
                                  onPressed: _fetchAiRecommendation,
                                  icon: const Icon(Icons.refresh, size: 2),
                                ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _aiRecommendation ?? 'Presiona el boton de actualizar para recibir recomendación inteligente sobre tus tareas.',
                            style: const TextStyle(
                              color: AppTheme.textsecondary,
                              height: 1.5,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                  ],
                ),
              ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        onPressed: () => _openTaskForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
