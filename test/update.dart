// @dart=2.9
import 'package:flutter/material.dart';
import 'package:movie/util/database_helper.dart';

import '../lib/models/Movies.dart';

class AddMovie extends StatefulWidget {
  const AddMovie({Key key}) : super(key: key);

  @override
  _AddMovieState createState() => _AddMovieState();
}

class _AddMovieState extends State<AddMovie> {
  final _ctrlName = TextEditingController();
  final _ctrlDirector = TextEditingController();
  var darkBlueColor = Color(0xff486579);
  Movie _movie = Movie();
  List<Movie> _movies = [];
  // var email= _userObj.email;
  // var email="ankitkushwah6@gmail.com";

  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[_form()],
      ),
    );
  }
  final _formKey = GlobalKey<FormState>();

  _form() => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
    child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _ctrlName,
            decoration: InputDecoration(labelText: 'Movie Name'),
            validator: (val) =>
            (val.length == 0 ? 'This field is mandatory' : null),
            onSaved: (val) => setState(() => _movie.name = val),
          ),
          TextFormField(
            controller: _ctrlDirector,
            decoration: InputDecoration(labelText: 'Director'),
            validator: (val) =>
            val.length == 0 ? 'This field is mandatory' : null,
            onSaved: (val) => setState(() => _movie.director = val),
          ),
          Container(
            margin: EdgeInsets.all(10.0),
            child: RaisedButton(
              onPressed: () => _onSubmit(),
              child: Text('Submit'),
              color: darkBlueColor,
              textColor: Colors.white,
            ),
          ),
        ],
      ),
    ),
  );

  _onSubmit() {}
}
