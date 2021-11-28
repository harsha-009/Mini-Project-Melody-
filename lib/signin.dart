import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Albums.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() => runApp(SignIn());

class SignIn extends StatelessWidget {
  // This widget is the root of your application.
  String user_name;

  //SignIn(this.user_name);
  final _auth = FirebaseAuth.instance;
  String e_mail;
  String pass_word;
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return MaterialApp(
        home: Scaffold(
            //backgroundImage: AssetImage('assets/download.jpg'),
            resizeToAvoidBottomInset: false,
            body: Container(
                height: queryData.size.height,
                margin: EdgeInsets.fromLTRB(0, 15.0, 0, 0),
                padding: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  image: DecorationImage(
                    image: AssetImage("images/background.jpg"),
                    //               ColoredBox(
                    //   color: Colors.black.withOpacity(0.5), // 0: Light, 1: Dark
                    // ),
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.7), BlendMode.dstATop),
                  ),
                ),
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Flexible(
                      child: CircleAvatar(
                        radius: 50.0,
                        backgroundImage: AssetImage('images/logo.jpg'),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "MELODY",
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      height: (queryData.size.height * 3) / 5,
                      width: queryData.size.width,
                      color: Colors.transparent,
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 30.0, right: 30.0, top: 30.0),
                          decoration: BoxDecoration(
                              color: Colors.green[800],
                              //border: BorderRadius.only(topLeft: 30.0 ),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50.0),
                                topRight: Radius.circular(50.0),
                                bottomLeft: Radius.circular(50.0),
                                bottomRight: Radius.circular(50.0),
                              )),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "SIGN IN",
                                style: TextStyle(
                                    fontSize: 35, color: Colors.white),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellowAccent, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Email',
                                ),
                                onChanged: (value) {
                                  //Do something with the user input.
                                  e_mail = value;
                                  user_name = e_mail.split("@")[0];
                                },
                              ),
                              TextField(
                                obscureText: true,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.redAccent, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.yellowAccent, width: 2.0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: 'Password',
                                ),
                                onChanged: (value) {
                                  //Do something with the user input.
                                  pass_word = value;
                                },
                              ),
                              // TextField(
                              //   decoration: InputDecoration(
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //           color: Colors.redAccent, width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //           color: Colors.yellowAccent, width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     fillColor: Colors.white,
                              //     filled: true,
                              //     hintText: 'username',
                              //   ),
                              // ),
                              // TextField(
                              //   decoration: InputDecoration(
                              //     focusedBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //           color: Colors.redAccent, width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     enabledBorder: OutlineInputBorder(
                              //       borderSide: BorderSide(
                              //           color: Colors.yellowAccent, width: 2.0),
                              //       borderRadius: BorderRadius.circular(10.0),
                              //     ),
                              //     fillColor: Colors.white,
                              //     filled: true,
                              //     hintText: 'Confirm password',
                              //   ),
                              // ),
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                onPressed: () async {
                                  // Validate will return true if the form is valid, or false if
                                  // the form is invalid.
                                  //if (_formKey.currentState!.validate()) {
                                  // Process data.
                                  try {
                                    final user =
                                        await _auth.signInWithEmailAndPassword(
                                            email: e_mail, password: pass_word);
                                    if (user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Albums(user_name, e_mail)),
                                      );
                                    }
                                  } catch (e) {
                                    print(e);
                                  }
                                },
                                child: const Text(
                                  'SUBMIT',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    //backgroundColor: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                )))));
  }
}
