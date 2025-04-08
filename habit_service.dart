import 'package:shared_preferences/shared_preferences.dart';

class HabitService {
  Future<List<String>> getHabits() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('habits') ?? ['Caminar', 'Tomar agua', 'Medirse glucosa'];
  }

  Future<void> completeHabit(String habit) async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final completed = prefs.getStringList('completed_$today') ?? [];
    if (!completed.contains(habit)) {
      completed.add(habit);
      await prefs.setStringList('completed_$today', completed);
    }
  }

  Future<int> getCompletedTodayCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final completed = prefs.getStringList('completed_$today') ?? [];
    return completed.length;
  }
}
