import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_application/model/NoteModel.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note ;
  final Color color ;
  final int index ;
  const NoteCard({super.key ,required this.note , required this.color  , required this.index });

  @override
  Widget build(BuildContext context) {
    final title = note.title;
    final date = DateFormat.yMMMd().format(note.date);
    final minHeight = getMinHeight(index);
    return Card(
      color: color,
      child: Container(
        constraints: BoxConstraints(minHeight: minHeight),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: TextStyle(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 100;
      case 1:
        return 150;
      case 2:
        return 150;
      case 3:
        return 100;
      default:
        return 100;
    }
  }
}
