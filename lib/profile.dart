import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'frd.dart';

class profile extends StatefulWidget {
  //const profile({ Key? key }) : super(key: key);
  String user_name = "";
  String e_mail = "";
  profile(this.user_name, this.e_mail);

  @override
  _profileState createState() => _profileState(user_name, e_mail);
}

List<String> l = [];

class _profileState extends State<profile> {
  String user_name;
  String e_mail;

  //l.append()
  //List list = [e_mail, user_name];
  _profileState(this.user_name, this.e_mail);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("My Profile"),
        ),
        body: Container(
            child: ListView(
          children: [
            ListTile(
              title: InkWell(
                onTap: () {
                  setState(() {
                    // item = items[0];
                    // Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'Email: $e_mail',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  setState(() {
                    // item = items[0];
                    // Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'Username: $user_name',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          frd('favourites_$user_name', user_name),
                    ),
                  );
                  setState(() {
                    // item = items[0];
                    // Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'My Favourites',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          frd('recents_$user_name', user_name),
                    ),
                  );
                  setState(() {
                    // item = items[0];
                    // Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'Recently Played',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          frd('downloads_$user_name', user_name),
                    ),
                  );
                  setState(() {
                    // item = items[0];
                    // Navigator.of(context).pop();
                  });
                },
                child: Text(
                  'My Downloads',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        )
            // child: ListView.custom(
            //   childrenDelegate: SliverChildBuilderDelegate(
            //     (BuildContext context, int index) {
            //       return buildList(context, l[index]);
            //     },
            //     childCount: l.length,
            //   ),
            // ),
            // child: Column(
            //   children: [
            //     ListView.builder(itemBuilder: itemBuilder)(
            //       children: [
            //         Text("Email: $e_mail"),
            //         Text("Username: $user_name"),
            //       ],
            //     )

            //     // DropdownMenuItem(child: widget.list),
            //   ],
            // ),
            ),
      ),
    );
  }
}
