import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay reminderTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadTime();
  }

  Future<void> _loadTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hour = prefs.getInt('reminderHour') ?? 9;
    final minute = prefs.getInt('reminderMinute') ?? 0;
    setState(() {
      reminderTime = TimeOfDay(hour: hour, minute: minute);
    });
  }

  Future<void> _saveTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('reminderHour', reminderTime.hour);
    await prefs.setInt('reminderMinute', reminderTime.minute);
    Navigator.pop(context);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );
    if (picked != null) {
      setState(() {
        reminderTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: const Text('Hora del recordatorio de glucosa'),
              subtitle: Text('${reminderTime.format(context)}'),
              trailing: const Icon(Icons.timer),
              onTap: _pickTime,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTime,
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
