import 'package:shared_preferences/shared_preferences.dart';

class GlucoseService {
  Future<void> saveValue(double value) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('glucose') ?? [];
    list.add(value.toString());
    await prefs.setStringList('glucose', list);
  }

  Future<List<double>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('glucose') ?? [];
    return list.map((e) => double.tryParse(e) ?? 0).toList();
  }

  Future<void> deleteValue(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList('glucose') ?? [];
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      await prefs.setStringList('glucose', list);
    }
  }

  Future<double?> getLastValue() async {
    final history = await getHistory();
    if (history.isNotEmpty) return history.last;
    return null;
  }
}
