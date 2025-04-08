import 'package:flutter/material.dart';

class HabitTile extends StatelessWidget {
  final String habit;
  final VoidCallback onCompleted;

  const HabitTile({
    required this.habit,
    required this.onCompleted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(habit),
      trailing: IconButton(
        icon: const Icon(Icons.check_circle, color: Colors.green),
        onPressed: onCompleted,
      ),
    );
  }
}
