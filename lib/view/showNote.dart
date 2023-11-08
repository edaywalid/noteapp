import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_application/controller/NoteDB.dart';
import 'package:note_application/model/NoteModel.dart';

import 'addNote.dart';

class showNote extends StatefulWidget {
  final int noteId;

  const showNote({super.key, required this.noteId});

  @override
  State<showNote> createState() => _showNoteState();
}

class _showNoteState extends State<showNote> {
   bool isLoading = false ;
   late NoteModel note ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshNote();
  }

  Future refreshNote() async {
    setState(() => isLoading = true);

    note = await NoteDB.instance.readNote(widget.noteId);

    setState(() => isLoading = false);

  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return const Center(child: CircularProgressIndicator(),);
    }

    return Scaffold(
      appBar: AppBar(
        actions: [buildDelete(context), buildEdit(context, note)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              note.title,
              style: const  TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              DateFormat.yMMMd().format(note.date),
              style: const TextStyle(color: Colors.white38),
            ),
            const SizedBox(height: 16),
            Text(
              note.description,
              style: const TextStyle(color: Colors.white60, fontSize: 18),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDelete(BuildContext context) {
    return IconButton(
        onPressed: () async {
          await NoteDB.instance.delete(note.id!);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.delete));
  }

  Widget buildEdit(BuildContext context, NoteModel note) {
    return IconButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteEditAdd(
                note: note,
              ),
            ),
          );
          refreshNote();
        },
        icon: const Icon(Icons.edit));
  }
}
