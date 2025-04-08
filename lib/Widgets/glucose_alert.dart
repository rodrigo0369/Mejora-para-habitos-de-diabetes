import 'package:flutter/material.dart';

class GlucoseAlert extends StatelessWidget {
  final double value;

  const GlucoseAlert({required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    String message = '';
    Color color = Colors.transparent;

    if (value < 70) {
      message = 'Glucosa muy baja!';
      color = Colors.redAccent;
    } else if (value > 180) {
      message = 'Glucosa muy alta!';
      color = Colors.orange;
    }

    if (message.isEmpty) return const SizedBox();

    return Container(
      color: color,
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(child: Text(message, style: const TextStyle(color: Colors.white))),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Esto simplemente oculta el alerta al hacer setState en el padre
            },
          ),
        ],
      ),
    );
  }
}
