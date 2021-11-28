import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music_player_app/screens/Songspage.dart';
import 'package:audio_manager/audio_manager.dart';

class Home extends StatefulWidget {
  final String albumname;
  String user_name;
  Home(this.albumname, this.user_name);
  @override
  _HomeState createState() => _HomeState(albumname, user_name);
}

class _HomeState extends State<Home> {
  String albumname;
  String user_name;
  _HomeState(String albumname, String user_name) {
    this.albumname = albumname;
    this.user_name = user_name;
  }
  var newaudioManagerInstance = AudioManager.instance;
  List list1;
  @override
  void initState() {
    super.initState();
    //initPlatformState();
  }

  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(albumname)
            .orderBy('song_name')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            list1 = snapshot.data.docs;

            return ListView.custom(
                childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return buildList(context, list1[index]);
              },
              childCount: list1.length,
            ));
          }
        },
      ),
    );
  }

  Widget buildList(BuildContext context, DocumentSnapshot documentSnapshot) {
    //var song_name = documentSnapshot.data()["song_name"];
    return Card(
      child: InkWell(
        onTap: () {
          setState(() {
            // if (newaudioManagerInstance.isPlaying) {
            //   AudioManager.instance.release();
            //   //super.dispose();
            // }

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Songspage(
                          song_name: documentSnapshot.data()["song_name"],

                          artist_name: documentSnapshot.data()["artist_name"],
                          song_url: documentSnapshot.data()["song_url"],
                          image_url: documentSnapshot.data()["image_url"],
                          //index: _list.indexOf(song_name),
                          list: list1,
                          i: 0,
                          user_name: user_name,
                          albumname: albumname,
                          slider_value: 0,
                          // audioManagerInstance: newaudioManagerInstance,
                        )));
          });
        },
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              documentSnapshot.data()["song_name"],
              style: TextStyle(fontSize: 20.0),
            ),
          ),
          elevation: 10.0,
        ),
      ),
    );
  }
}
