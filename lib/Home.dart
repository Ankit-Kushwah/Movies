// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_player/video_player.dart';
import 'package:movie/util/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'models/Movies.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Home> {

  //Google Auth

  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FilePickerResult result;

  //Google Auth
  final _formKey = GlobalKey<FormState>();
  Map<int, VideoPlayerController> _controllers = Map();
  VideoPlayerController controller ;

  // VideoPlayerController _controller;
  final _ctrlName = TextEditingController();
  final _ctrlDirector = TextEditingController();
  var darkBlueColor = Color(0xff486579);
  Movie _movie = Movie();
  List<Movie> _movies = [];
  DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    _refreshContactList();

  }
  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
      _ctrlName.clear();
      _ctrlDirector.clear();
      _movie.id = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading:
        IconButton(
          color: darkBlueColor,
          icon: const Icon(Icons.logout ,),
          onPressed: () async{
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => MyHomePage(),
              ),
                  (route) => false,
            );
            _googleSignIn.signOut().then((value) {
                prefs.setBool('_isLoggedIn', false);
            }).catchError((e) {});
            },
        ),
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            "MY MOVIES COLLECTION",
            style: TextStyle(color: darkBlueColor),
          ),
        ),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[_list()],
          )),

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: darkBlueColor,
        onPressed: () {
          _showpopup();
        },
      ),
    );
  }


  _showpopup(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content:
            Container(
              height: MediaQuery.of(context).size.height*0.4,
              width: MediaQuery.of(context).size.width*0.8,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Positioned(
                    right: -40.0,
                    top: -40.0,
                    child: InkResponse(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                  Form(
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
                        TextButton(onPressed: (){
                          pickImageFromGallery();
                        }, child: Text('Pick Movie')),
                        SizedBox(
                          height: 200.0,
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
                  )
                ],
              ),
            ),
          );
        });
  }

  pickImageFromGallery() async {
   result = await FilePicker.platform.pickFiles();
   setState(() {
    if(result != null) {
      PlatformFile file = result.files.first;
      // controller = _controllers[0];
      _movie.movi=file.path;
    }
   });
  }


  _list() {

    return Expanded(
    child: Card(
        margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
        child:
        // _movies.length!=0?
        Scrollbar(
          child: _movies.length!=0?ListView.builder(
            itemCount: _movies.length??0,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index)  {
              print('_movies[index].movi ${_movies[index].movi}');
                File file = File(_movies[index].movi);
                _controllers[index] = VideoPlayerController.file(file);
                try {
                  /// This line load video in memory and is the source of the problem.
                  //// if commented, obviously no crash
                   _controllers[index].initialize();
                } catch (e) {
                  print(e.toString());
                }
              VideoPlayerController controller = _controllers[index];
              return Column(
                children: <Widget>[
              !_controllers[index].value.isPlaying?Container(
                    height: MediaQuery.of(context).size.height*0.37,
                     width: MediaQuery.of(context).size.width*0.75,
                    child: AspectRatio(
                      aspectRatio: controller.value.aspectRatio,
                      child: VideoPlayer(controller),
                    ),
                  ): Container(),
                  ListTile(
                    leading:IconButton(
                      color: Colors.blueGrey,
                      icon: _controllers[index].value.isPlaying ? Icon(Icons.pause):Icon(Icons.play_arrow) ,
                      onPressed: (){
                        setState(() {
                          _controllers[index].value.isPlaying
                              ? _controllers[index].pause()
                              : _controllers[index].play();
                        });
                      },

                    ),
                    title: Text(
                      _movies[index].name.toUpperCase(),
                      style: TextStyle(
                          color: darkBlueColor, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_movies[index].director),
                    trailing: Container(
                      child: Column(
                        children: [
                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: darkBlueColor,
                              ),
                              onPressed: () async {

                                setState(() {
                                  _movie = _movies[index];
                                  _ctrlName.text = _movies[index].name;
                                  _ctrlDirector.text = _movies[index].director;
                                });
                                _showpopup();
                              },
                            ),
                          ),

                          Expanded(
                            child: IconButton(
                              icon: Icon(
                                Icons.delete_outlined,
                                color: darkBlueColor,
                              ),
                              onPressed: () async {
                                await _dbHelper.deleteMovie(_movies[index].id);
                                _resetForm();
                                _refreshContactList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _controllers[index].initialize();
                          setState(() {
                            _controllers[index].value.isPlaying
                                ? _controllers[index].pause()
                                : _controllers[index].play();
                          });
                        },
                      ),
                  Divider(
                    height: 5.0,
                  ),
                ],
              );
            },
          ):Center(),
        )
    ),
  );
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    print(_movie.id);
    print(_movie.name);
    print(_movie.director);
    emailID();
    if (form.validate()) {
      form.save();
      if (_movie.id == null)
        await _dbHelper.insertMovie(_movie);
      else
        await _dbHelper.updateMovie(_movie);

      _resetForm();
      await _refreshContactList();
    }
  }

  _refreshContactList() async {
    emailID();
    print("Email of user ${_movie.email}");
    List<Movie> x = await _dbHelper.fetchMovies(_movie);
    setState(() {
      _movies = x;
    });
  print('_movies.length  ${_movies.length}');
  }
  emailID()async {
    print('emailID');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _email = prefs.getString('email');
    setState(() {
      if(_email!=null)
        _movie.email= _email;
    });
  }
}
