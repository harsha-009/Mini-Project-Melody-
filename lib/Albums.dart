import 'package:flutter/material.dart';
import 'package:music_player_app/screens/Home.dart';

class Albums extends StatefulWidget {
  //const Albums({Key key}) : super(key: key);
  String user_name, e_mail;

  Albums(this.user_name, this.e_mail);
  @override
  _AlbumsState createState() => _AlbumsState(user_name, e_mail);
}

class _AlbumsState extends State<Albums> {
  String user_name;
  String e_mail;
  _AlbumsState(this.user_name, this.e_mail);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome $user_name"),
          //actionsIconTheme: IconThemeData(color: Colors.yellow),
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.pushNamed(context, 'profile');
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => profile(user_name, e_mail)),
                // );
              },
            )
          ]),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Love',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      // setState(() {

                      // }
                      //Home("Love");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home("Love", user_name)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Divine',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Home("Divine", user_name)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Old',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'DJ',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Sad',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Mass',
                      style: TextStyle(fontSize: 24),
                    ),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      fixedSize: Size.fromRadius(70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
