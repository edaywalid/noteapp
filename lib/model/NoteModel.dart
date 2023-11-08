class NoteModel {
  int? id;
  String title;
  String description;
  DateTime date;



  NoteModel(
      {this.id, required this.title, required this.description, required this.date});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
    };
  }


  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: DateTime.now()
    );
  }

 

}