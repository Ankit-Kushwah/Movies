// @dart=2.9
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Movies'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //Google Auth
  bool _isLoggedIn = false;
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  //Google Auth
  var darkBlueColor = Color(0xff486579);

  @override
  void initState() {
    super.initState();
    _googleSignIn.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: Text(
            widget.title??"Movies",
            style: TextStyle(color: darkBlueColor),
          ),
        ),

      ),
      body:Center(
          child: ElevatedButton(
            child: Text("Login with Google"),
            onPressed: () async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              _googleSignIn.signIn().then((userData) {
                setState(() {
                  _userObj = userData;
                  prefs.setString('email', _userObj.email);
                  prefs.setBool('_isLoggedIn', true);
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      Home()), (Route<dynamic> route) => false);
                });
              }).catchError((e) {
                print(e);
              });
            },
          ),
        ),
    );
  }

   // initplateform()async {
   //   SharedPreferences prefs = await SharedPreferences.getInstance();
   //   setState(() {
   //     _isLoggedIn=prefs.getBool('_isLoggedIn')??false;
   //   });
   // }
}
