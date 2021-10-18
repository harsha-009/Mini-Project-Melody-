import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'screens/Songspage1.dart';

class frd extends StatefulWidget {
  //const frd({ Key? key }) : super(key: key);
  String collectionname, user_name;
  frd(this.collectionname, this.user_name);
  @override
  _frdState createState() => _frdState(collectionname, user_name);
}

class _frdState extends State<frd> {
  String collectionname, user_name;
  List _list = [];
  _frdState(this.collectionname, this.user_name);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(collectionname)
            .orderBy('song_name')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            _list = snapshot.data.docs;

            return ListView.custom(
                childrenDelegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return buildList(context, _list[index]);
              },
              childCount: _list.length,
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
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Songspage1(
                      song_name:
                          documentSnapshot.data()["song_name"].toString(),

                      artist_name:
                          documentSnapshot.data()["artist_name"].toString(),
                      song_url: documentSnapshot.data()["song_url"].toString(),
                      image_url:
                          documentSnapshot.data()["image_url"].toString(),
                      //index: _list.indexOf(song_name),
                      list: _list,
                      i: 0,
                      // user_name: user_name,
                      // albumname: 'Love',
                    ))),
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
