import 'package:flutter/material.dart';
import '../services/glucose_service.dart';

class GlucoseScreen extends StatefulWidget {
  @override
  State<GlucoseScreen> createState() => _GlucoseScreenState();
}

class _GlucoseScreenState extends State<GlucoseScreen> {
  final _controller = TextEditingController();
  List<double> history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final data = await GlucoseService().getHistory();
    setState(() {
      history = data;
    });
  }

  Future<void> _saveValue() async {
    final value = double.tryParse(_controller.text);
    if (value != null) {
      await GlucoseService().saveValue(value);
      _controller.clear();
      _loadHistory();
    }
  }

  Future<void> _deleteValue(int index) async {
    await GlucoseService().deleteValue(index);
    _loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar glucosa')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nivel de glucosa',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _saveValue,
              child: const Text('Guardar'),
            ),
            const SizedBox(height: 20),
            const Text('Historial:', style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${history[index]} mg/dL'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteValue(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
