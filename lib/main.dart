import 'package:flutter/material.dart';
import 'package:music_player_app/screens/Home.dart';
import 'package:music_player_app/screens/Upload.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music_player_app/Albums.dart';
import 'signup.dart';
import 'signin.dart';
import 'profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

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
  StreamSubscription<User> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  // List tabs = [
  //   //Home('songs'),
  //   //profile('ravi', 'ravi@gmail.com'),
  //   SignIn(),
  //   //Albums("ravi", "ravi@gmail.com"),
  //   Upload(),
  // ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Melody",
      debugShowCheckedModeBanner: false,
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "signin" : "albums",

      ///key value pair
      routes: {
        "signin": (context) => SignIn(),
        "albums": (context) => Albums(
            FirebaseAuth.instance.currentUser.email.split("@")[0],
            FirebaseAuth.instance.currentUser.email),
        "signup": (context) => SignUp(),
        "profile": (context) => profile(
            FirebaseAuth.instance.currentUser.email.split("@")[0],
            FirebaseAuth.instance.currentUser.email),

        // Login.id: (context) => Login(),
        // Registration.id: (context) => Registration(),
        // ChatApp.id: (context) => ChatApp(),
      },
      //home: Welcome(),
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      //home: Scaffold(

      //appBar: AppBar(title:Text("Melody"),),
      //body: tabs[currentindex],
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: currentindex,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: "Albums",
      //     ),
      //     // BottomNavigationBarItem(
      //     //   icon: Icon(Icons.cloud_upload),
      //     //   label: "Upload",
      //     // ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.cloud_upload),
      //       label: "Upload",
      //     )
      //   ],
      //   onTap: (index) {
      //     setState(() {
      //       var user =
      //           FirebaseAuth.instance.authStateChanges().listen((user) {
      //         if (user == null) {
      //           print('User is currently signed out!');
      //           //SignIn();
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => SignIn()));
      //         } else {
      //           print('User is signed in!');
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       Albums(user.displayName, user.email)));
      //           //Albums();
      // //           // Navigator.push(
      // //           //     context, MaterialPageRoute(builder: (context) => SignIn()));
      // //         }
      // //       });
      // //       currentindex = index;
      // //     });
      // //   },
      // // ),
      //  var user = FirebaseAuth.instance.authStateChanges().listen((user) {
      //         if (user == null) {
      //           print('User is currently signed out!');
      //           //SignIn();
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => SignIn()));
      //         } else {
      //           print('User is signed in!');
      //           Navigator.push(
      //               context,
      //               MaterialPageRoute(
      //                   builder: (context) =>
      //                       Albums(user.displayName, user.email)));
      //           //Albums();
      //           // Navigator.push(
      //           //     context, MaterialPageRoute(builder: (context) => SignIn()));
      //         }
      // );
      //),
    );
  }
}
