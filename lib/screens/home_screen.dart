import 'package:flutter/material.dart';
import '../services/habit_service.dart';
import '../services/glucose_service.dart';
import '../widgets/habit_tile.dart';
import '../widgets/glucose_alert.dart';
import 'glucose_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> habits = [];
  int completedToday = 0;
  double? lastGlucose;

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _loadGlucose();
  }

  Future<void> _loadHabits() async {
    final list = await HabitService().getHabits();
    final completed = await HabitService().getCompletedTodayCount();
    setState(() {
      habits = list;
      completedToday = completed;
    });
  }

  Future<void> _loadGlucose() async {
    final latest = await GlucoseService().getLastValue();
    setState(() {
      lastGlucose = latest;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DiabetesHabitsApp'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SettingsScreen()),
            ).then((_) => _loadHabits()),
          ),
        ],
      ),
      body: Column(
        children: [
          if (lastGlucose != null)
            GlucoseAlert(value: lastGlucose!),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Hábitos de hoy:', style: TextStyle(fontSize: 18)),
                Text('$completedToday completados'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: habits.length,
              itemBuilder: (context, index) {
                final habit = habits[index];
                return HabitTile(
                  habit: habit,
                  onCompleted: () async {
                    await HabitService().completeHabit(habit);
                    _loadHabits();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bloodtype),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => GlucoseScreen()),
        ).then((_) => _loadGlucose()),
      ),
    );
  }
}
