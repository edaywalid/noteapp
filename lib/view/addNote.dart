import 'package:flutter/material.dart';
import 'package:note_application/controller/NoteDB.dart';
import 'package:note_application/model/NoteModel.dart';
import 'package:note_application/view/widgets/NoteFormWidget.dart';

class NoteEditAdd extends StatefulWidget {
  NoteModel? note;

  NoteEditAdd({super.key, this.note });

  @override
  State<NoteEditAdd> createState() => _NoteEditAddState();
}

class _NoteEditAddState extends State<NoteEditAdd> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    title = widget.note?.title ?? '';
    description = widget.note?.description ?? '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [buildButton(),],

      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: NoteFormWidget(

              title: title,
              description: description,
              onChangedTitle: (newTitle) =>
                  setState(() {
                    title = newTitle;
                  }),
              onChangedDescription: (newDesc) =>
                  setState(() {
                    description = newDesc;
                  }),

            ),
          )
      ),
    );
  }

  Widget buildButton() {
    final isFormValid = title.isNotEmpty && description.isNotEmpty;

    return IconButton(
      onPressed: () {
        addOrUpdateNote();
        Navigator.of(context).pop();
      },
      icon: Icon(Icons.check,),);
  }

  void addOrUpdateNote() async {
    final isValid = _formKey.currentState!.validate();
    bool isUpdate = widget.note != null;
    if (isValid) {
      if (isUpdate) {
        await updateNote();
      } else {
        await addNote();
      }
    }
  }


  Future addNote() async {
    final note = NoteModel(
      title: title,
      description: description,
      date: DateTime.now(),

    );

    await NoteDB.instance.insert(note.toMap());
  }

  Future updateNote() async {
    final note = NoteModel(
      id: widget.note!.id,
      title: title,
      description: description,
      date: DateTime.now(),
    );

    return NoteDB.instance.update(note.toMap());
  }
}







