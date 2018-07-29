import 'package:flutter/material.dart';
import 'package:scribble/db/database_helper.dart';
import 'package:flutter/foundation.dart'; //new

Color hexColor = const Color.fromRGBO(28, 189, 194, 1.0);

class ScribbleDetailsWidget extends StatefulWidget {
  final DbManager _manager;
  final Note note;

  ScribbleDetailsWidget(this._manager, {this.note});

  @override
  ScribbleDetailsWidgetState createState() {
    return new ScribbleDetailsWidgetState(_manager, note);
  }
}

class ScribbleDetailsWidgetState extends State<ScribbleDetailsWidget> {
  final DbManager _manager;
  final Note note;
  final _formKey = new GlobalKey<FormState>();

  String _title;
  String _description;

  // FOR LATER USE
  // int dueToDate = new DateTime.now().millisecondsSinceEpoch;

  ScribbleDetailsWidgetState(this._manager, this.note);

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      note == null
          ? _manager
              .insertNote(new Note(title: _title, description: _description))
              .then((id) => Navigator.pop(context))
          : _manager
              .updateNote(new Note(
                  title: _title, description: _description, id: note.id))
              .then((id) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: hexColor,
//        actions: <Widget>[
//          new IconButton(icon: Icon(Icons.send), onPressed: () => print("test"))
//        ],
        elevation: 0.0,
        title: new Text("Notiz bearbeiten"),
        centerTitle: true,
      ),
      body: new Container(
          margin: new EdgeInsets.all(30.0),
          child: new Form(
              key: _formKey,
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "Titel",
                          labelStyle: new TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold),
                          border: InputBorder.none,
                        ),
                        key: new Key("title"),
                        initialValue: note?.title,
                        validator: (val) => val.isNotEmpty
                            ? null
                            : "Der Titel darf nicht leer sein",
                        onSaved: (val) => _title = val,
                      ),
                    ),
                    new Container(
                        child: new Divider(
                      color: hexColor,
                    )),
                    Column(
                      children: <Widget>[
                        new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "Beschreibung",
                            labelStyle: new TextStyle(
                                fontSize: 22.0, fontWeight: FontWeight.bold),
                            border: InputBorder.none,
                          ),
                          key: new Key("description"),
                          initialValue: note?.description,
                          validator: (val) => val.isNotEmpty
                              ? null
                              : "Die Beschreibung darf nicht leer sein",
                          onSaved: (val) => _description = val,
                          keyboardType: TextInputType.multiline,
                          maxLines: 15,
                        ),
                      ],
                    ),
                  ]))),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: hexColor,
        onPressed: () => _submit(),
        icon: Icon(Icons.check),
        label: new Text("Speichern"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

//  FOR LATER USE
//  Future<Null> _selectDate(BuildContext context) async {
//    final DateTime picked = await showDatePicker(
//        context: context, initialDate: new DateTime.now(), firstDate: new DateTime(2015, 8), lastDate: new DateTime(2199));
//    if(picked != null) {
//      setState(() {
//        dueToDate = picked.millisecondsSinceEpoch;
//      });
//    }
//  }
}
