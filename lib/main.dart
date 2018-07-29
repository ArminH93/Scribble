import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scribble/db/database_helper.dart';
import 'package:scribble/ui/scribble_notes.dart';
import 'package:scribble/util/date_formatter.dart';
import 'package:scribble/util/date_months.dart';

void main() => runApp(new MyApp());

// Same as App Icon Color
Color hexColor = const Color.fromRGBO(28, 189, 194, 1.0);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Scribble',
        home: new ScribbleList());
  }
}

class ScribbleList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ScribbleListState();
  }
}

class ScribbleListState extends State<ScribbleList> {
  final DbManager manager = new DbManager();
  List<Note> notes;
  //int dueToDate = new DateTime.now().millisecondsSinceEpoch;
  GlobalKey<ScaffoldState> _scaffoldHomeState = new GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    super.dispose();
    manager.closeDb();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Note>>(
      future: manager.getNotes(),
      builder: (context, snapshot) => new Scaffold(
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: hexColor,
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (_) => new ScribbleDetailsWidget(manager))),
              icon: Icon(Icons.note_add),
              label: new Text("Notiz schreiben"),
              heroTag: false,
            ),
            key: _scaffoldHomeState,
            appBar: new AppBar(
              backgroundColor: hexColor,
              centerTitle: true,
              title: new Text("Scribble"),
              elevation: 0.0,
            ),
            body: new Center(child: buildScribbleList(snapshot)),
          ),
    );
  }

  Widget buildScribbleList(AsyncSnapshot<List<Note>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return new CircularProgressIndicator();
      default:
        if (snapshot.hasError) {
          return new Text("Unerwarteter Fehler: ${snapshot.error}");
        }
        notes = snapshot.data;
        return new ListView.builder(
          itemBuilder: (BuildContext context, int index) => _createItem(index),
          itemCount: notes.length,
        );
    }
  }

  Widget _createItem(int index) {
    return Dismissible(
      background: new Container(
        color: Colors.redAccent,
        child: new ListTile(
          leading: new Icon(
            Icons.delete,
            color: Colors.white,
          ),
          trailing: new Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      key: new UniqueKey(),
      onDismissed: (direction) {
        manager.deleteNote(notes[index].id);
        showSnackbar(_scaffoldHomeState, "Erledigt");
      },
      child: new ListTile(
        trailing: new Text(dateFormatted()),
        title: new Text(
          notes[index].title,
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        subtitle: new Text(
          notes[index].description.length > 50
              ? notes[index].description.substring(0, 50) + "..."
              : notes[index].description,
          style: new TextStyle(
            fontSize: 16.0,
          ),
        ),
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (_) =>
                  new ScribbleDetailsWidget(manager, note: notes[index])));
        },
      ),
    );
  }

  showSnackbar(GlobalKey<ScaffoldState> scaffoldState, String message,
      {MaterialColor materialColor}) {
    if (message.isEmpty) return;
    // Find the Scaffold in the Widget tree and use it to show a SnackBar
    scaffoldState.currentState.showSnackBar(new SnackBar(
        content: new Text(message), backgroundColor: materialColor));
  }
}
