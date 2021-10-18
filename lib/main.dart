import 'package:flutter/material.dart';
import 'package:music_player_app/screens/Home.dart';
import 'package:music_player_app/screens/Upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_player_app/Albums.dart';
import 'signup.dart';
import 'signin.dart';
import 'profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentindex = 0;
  List tabs = [
    //Home('songs'),
    //profile('ravi', 'ravi@gmail.com'),
    SignIn(),
    Upload(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Music Player App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          body: tabs[currentindex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentindex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "Profile",
              ),
              // BottomNavigationBarItem(
              //   icon: Icon(Icons.cloud_upload),
              //   label: "Upload",
              // ),
              BottomNavigationBarItem(
                icon: Icon(Icons.cloud_upload),
                label: "Upload",
              )
            ],
            onTap: (index) {
              setState(() {
                currentindex = index;
              });
            },
          ),
        ));
  }
}
