
import 'package:flutter/material.dart';
import 'package:note_application/controller/NoteDB.dart';
import 'package:note_application/model/NoteModel.dart';
import 'package:note_application/view/showNote.dart';
import 'package:note_application/view/widgets/NoteCard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'addNote.dart';
final _lightColors = [
  Colors.amber.shade300,
  Colors.lightGreen.shade300,
  Colors.lightBlue.shade300,
  Colors.orange.shade300,
  Colors.pinkAccent.shade100,
  Colors.tealAccent.shade100
];

class showNotes extends StatefulWidget {
  @override
  State<showNotes> createState() => _showNotesState();
}

class _showNotesState extends State<showNotes> {
  List<NoteModel> notes = [];
  bool isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // NoteDB.instance.deleteNotesDatabase();
    refreshNotes();

    // NoteDB.instance.dropTable();
  }


  @override
  void dispose() {
    NoteDB.instance.close();
    super.dispose();
  }


  Future refreshNotes() async {
    setState(() => isLoading = true);

    notes = await NoteDB.instance.queryAll();

    setState(() => isLoading = false);


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
           await Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditAdd()));
           refreshNotes();
        },
        backgroundColor: Theme.of(context).hintColor,
        child: const Icon(Icons.add),
      ),

      body: Padding(
          padding: const EdgeInsets.all(10.0),
          child:
          StaggeredGrid.count(
            // itemCount: notes.length,
            // staggeredTileBuilder: (index) => StaggeredTile.fit(2),
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: List.generate(
              notes.length,
              (index) {
                return StaggeredGridTile.fit(
                  crossAxisCellCount: 1,
                  child: GestureDetector(
                    onTap: () async{
                        await Navigator.push(context, MaterialPageRoute(builder: (context)=> showNote(noteId: notes[index].id! )));
                        refreshNotes();
                    },
                    child: NoteCard(
                      note: notes[index],
                      index:  index,
                      color:   _lightColors[index % _lightColors.length] ,
                    ),
                  ),
                );
              },
            ),
          ),
          // GridView.custom(
          //   gridDelegate: SliverStairedGridDelegate(
          //     crossAxisSpacing: 12,
          //     mainAxisSpacing: 15,
          //     startCrossAxisDirectionReversed: true,
          //     pattern: [
          //       StairedGridTile(0.5, 1),
          //       StairedGridTile(0.5, 3 / 4),
          //       StairedGridTile(1.0, 10 / 4),
          //     ],
          //   ),
          //   childrenDelegate: SliverChildBuilderDelegate(
          //     childCount: notes.length,
          //         (context, index) =>NoteCard(
          //       title: notes[index].title ,
          //       color:   _lightColors[index % _lightColors.length] ,
          //     ),
          //   ),
          // )

          // GridView.custom(
          //   gridDelegate: SliverWovenGridDelegate.count(
          //     crossAxisCount: 2,
          //     mainAxisSpacing: 2,
          //     crossAxisSpacing: 2,
          //     pattern: [
          //       WovenGridTile(1),
          //       const WovenGridTile(
          //         5 / 7,
          //         crossAxisRatio: 0.9,
          //         alignment: AlignmentDirectional.centerEnd,
          //       ),
          //     ],
          //   ),
          //   childrenDelegate: SliverChildBuilderDelegate(
          //     childCount: notes.length,
          //         (context, index) =>NoteCard(
          //           index: index  ,
          //       title: notes[index].title ,
          //       color:   _lightColors[index % _lightColors.length] ,
          //     ),
          //   ),
          // )
      ),
    );
  }
}
