import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_audio_query/flutter_audio_query.dart';
//import 'package:music_player/music_player.dart';
import 'package:audio_manager/audio_manager.dart';
//import 'package:just_audio/just_audio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../frd.dart';
import 'package:flutter/services.dart';

class Songspage extends StatefulWidget {
  String song_name, artist_name, song_url, image_url, user_name, albumname;
  int i;
  double slider_value;
  //var audioManagerInstance;
  List list;
  Songspage({
    this.song_name,
    this.artist_name,
    this.song_url,
    this.image_url,
    this.list,
    this.i,
    this.user_name,
    this.albumname,
    this.slider_value,
    //this.audioManagerInstance,
  });
  @override
  SongspageState createState() => SongspageState(
        list,
        song_name,
        artist_name,
        song_url,
        image_url,
        i,
        user_name,
        albumname,
        slider_value,
      );
}

class SongspageState extends State<Songspage> {
  List list;
  int i;
  double slider_value;
  AsyncSnapshot<QuerySnapshot> snapshot;

  String song_name, artist_name, song_url, image_url, user_name, albumname;
  SongspageState(
    this.list,
    this.song_name,
    this.artist_name,
    this.song_url,
    this.image_url,
    this.i,
    this.user_name,
    this.albumname,
    this.slider_value,
  );
  //MusicPlayer musicPlayer;
  bool isplaying1 = false;
  String platformVersion = 'Unknown';
  var audioManagerInstance = AudioManager.instance;
  // if((AudioManager.instance).isPlaying())
  // {
  //    AudioManager.instance.release();
  // }
  // else
  // {
  //      audioManagerInstance=AudioManager.instance;
  // }

  //audioManagerInstance.audioList=list;
  var firestoreinstance = FirebaseFirestore.instance;
  //double _currentSliderValue = 20;
  int k = 0;
  //double sv = 0;
  //double duration = 250;
  //double _slider;
  bool isPlaying = false;
  Duration duration;
  Duration position;
  //Duration duration=await musicPlayer.onDuration();
  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupAudio();
  }

  // void dispose() {
  //   AudioManager.instance.release();
  //   super.dispose();
  // }
  // @override
  // void dispose() {
  //   AudioManager.instance.release();
  //   super.dispose();
  // }

  void setupAudio() {
//     snapshot = await getDocs(collection(db, albumname));
// snapshot.forEach((doc) => {
//   // doc.data() is never undefined for query doc snapshots
//   //console.log(doc.id, " => ", doc.data());
// });
    @override
    List<AudioInfo> list1 = [];
    list.forEach((item) => list1.add(AudioInfo(item["song_url"],
        title: item["song_name"],
        desc: item["artist_name"],
        coverUrl: item["image_url"])));

    audioManagerInstance.audioList = list1;
    audioManagerInstance.start(song_url, song_name,
        desc: artist_name, cover: image_url);
    slider_value = 0;
    position = AudioManager.instance.position;
    duration = AudioManager.instance.duration;
    audioManagerInstance.onEvents((events, args) {
      switch (events) {
        // case AudioManagerEvents.start:

        //   break;
        case AudioManagerEvents.start:
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          slider_value = 0;
          // setState(() {

          // });
          AudioManager.instance.updateLrc("audio resource loading....");

          //setState(() {});
          break;
        case AudioManagerEvents.ready:
          print("ready to play");
          //_error = null;
          //_sliderVolume = AudioManager.instance.volume;

          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          setState(() {});
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          position = AudioManager.instance.position;
          slider_value = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          break;
        case AudioManagerEvents.playstatus:
          isPlaying = audioManagerInstance.isPlaying;
          setState(() {});
          break;
        case AudioManagerEvents.timeupdate:
          slider_value = audioManagerInstance.position.inMilliseconds /
              audioManagerInstance.duration.inMilliseconds;
          setState(() {});
          audioManagerInstance.updateLrc(args["position"].toString());

          break;
        case AudioManagerEvents.ended:
          audioManagerInstance.next();
          k++;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Songspage(
                        song_name:
                            list[(k) % (list.length)]["song_name"].toString(),

                        // audioManagerInstance=audioManagerInstance.previous();
                        artist_name:
                            list[(k) % (list.length)]["artist_name"].toString(),
                        song_url:
                            list[(k) % (list.length)]["song_url"].toString(),
                        image_url:
                            list[(k) % (list.length)]["image_url"].toString(),
                        //index: _list.indexOf(song_name),
                        list: list,
                        i: k,
                      )));

          // songinfo(
          //   list[audioManagerInstance.curIndex + 1]["song_name"],
          //   list[audioManagerInstance.curIndex + 1]["artist_name"],
          //   list[audioManagerInstance.curIndex + 1]["song_url"],
          //   list[audioManagerInstance.curIndex + 1]["image_url"],
          // );

          //setState(() {});
          break;
        // case AudioManagerEvents.stop:
        //   //audioManagerInstance.stop();
        //   //setState(() {});
        //   break;
        default:
          break;
      }
    });
  }

  // Initializing the Music Player and adding a single [PlaylistItem]
  // Future<void> initPlatformState() async {
  //   musicPlayer = MusicPlayer();
  // }
  Future<void> initPlatformState() async {
    String platformVersion1;
    try {
      platformVersion1 = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion1 = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      platformVersion = platformVersion1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music Player App"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Center(
              child: Column(
            children: <Widget>[
              SizedBox(
                height: 30.0,
              ),
              Card(
                child: Image.network(widget.image_url, height: 350.0),
                elevation: 10.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                widget.song_name,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                widget.artist_name,
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              bottomPanel(),
            ],
          )),
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: Colors.black);
    return Row(
      children: <Widget>[
        Text(
          formatDuration(audioManagerInstance.position),
          style: style,
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbColor: Colors.blueAccent,
                overlayColor: Colors.blue,
                thumbShape: RoundSliderThumbShape(
                  disabledThumbRadius: 5,
                  enabledThumbRadius: 5,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 10,
                ),
                activeTrackColor: Colors.blueAccent,
                inactiveTrackColor: Colors.grey,
              ),
              child: Slider(
                // min: double.negativeInfinity,
                // //max: duration.inMilliseconds.roundToDouble(),
                // max: double.infinity,
                value: slider_value ?? 0,

                // max: 6000000000000000000,
                // min: 0,
                // max: duration.inSeconds.roundToDouble(),
                // divisions: duration.inSeconds.roundToDouble().toInt(),
                //divisions: max,
                onChanged: (value) {
                  setState(() {
                    slider_value = value;
                  });
                },
                onChangeEnd: (value) {
                  if (audioManagerInstance.duration != null) {
                    Duration msec = Duration(
                        milliseconds:
                            (audioManagerInstance.duration.inMilliseconds *
                                    value)
                                .round());
                    audioManagerInstance.seekTo(msec);
                  }
                },
              ),
            ),
          ),
        ),
        Text(
          formatDuration(audioManagerInstance.duration),
          style: style,
        ),
      ],
    );
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () {
                // Stream<QuerySnapshot> stream = FirebaseFirestore.instance
                //     .collection(albumname)
                //     .orderBy('song_name')
                //     .snapshots();
                // firestoreinstance
                //     .collection("favourites_$user_name").doc().
                //     get(data[song_name])
                //     .then((doc) => {if (doc.exists) {}});
//                 var docRef = firestoreinstance.collection(albumname).doc(song_name);

// docRef.get().then((song_name) => {
//     if (song_name.exists) {
//         //console.log("Document data:", doc.data());
//         print("Document already exists"),
//     } else {
//         // doc.data() will be undefined in this case
//         //console.log("No such document!");

//     },
// },
// );
                var data = {
                  "song_name": song_name.toString(),
                  "artist_name": artist_name.toString(),
                  "song_url": song_url.toString(),
                  "image_url": image_url.toString(),
                };

                firestoreinstance
                    .collection("favourites_$user_name")
                    .doc(song_name)
                    .set(data);
              },
              icon: Icon(EvaIcons.heart),
            ),
            CircleAvatar(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        // _slider = 0.0;
                        k = --i;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Songspage(
                                      song_name: list[(k + (list.length)) %
                                              (list.length)]["song_name"]
                                          .toString(),
                                      // audioManagerInstance=audioManagerInstance.previous();
                                      artist_name: list[(k + (list.length)) %
                                              (list.length)]["artist_name"]
                                          .toString(),
                                      song_url: list[(k + (list.length)) %
                                              (list.length)]["song_url"]
                                          .toString(),
                                      image_url: list[(k + (list.length)) %
                                              (list.length)]["image_url"]
                                          .toString(),
                                      //index: _list.indexOf(song_name),
                                      list: list,
                                      i: k,
                                    )));
                        audioManagerInstance.previous();
                        // songinfo(
                        //   list[audioManagerInstance.curIndex - 1]["song_name"],
                        //   list[audioManagerInstance.curIndex - 1]
                        //       ["artist_name"],
                        //   list[audioManagerInstance.curIndex - 1]["song_url"],
                        //   list[audioManagerInstance.curIndex - 1]["image_url"],
                        // );

                        // (audioManagerInstance.curIndex)=(audioManagerInstance.curIndex)-1;
                        // audioManagerInstance.curIndex=list[]
                      });

                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => Songspage(
                      //               song_name: list[
                      //                   audioManagerInstance.curIndex - 1],
                      //               // song_name: documentSnapshot.data()["song_name"],

                      //               // artist_name: documentSnapshot.data()["artist_name"],
                      //               // song_url: documentSnapshot.data()["song_url"],
                      //               // image_url: documentSnapshot.data()["image_url"],
                      //               //index: _list.indexOf(song_name),
                      //               list: list,
                      //             )));
                      // audioManagerInstance
                      //     .audioList[audioManagerInstance.curIndex - 1];
                    }),
              ),
              backgroundColor: Colors.blue,
              //backgroundColor: Colors.cyan.withOpacity(0.3),
            ),
            CircleAvatar(
              radius: 30,
              child: Center(
                child: IconButton(
                  onPressed: () async {
                    var data = {
                      "song_name": song_name.toString(),
                      "artist_name": artist_name.toString(),
                      "song_url": song_url.toString(),
                      "image_url": image_url.toString(),
                    };

                    firestoreinstance
                        .collection("recents_$user_name")
                        .doc(song_name)
                        .set(data);
                    audioManagerInstance.playOrPause();
                  },
                  padding: const EdgeInsets.all(0.0),
                  icon: Icon(
                    audioManagerInstance.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            CircleAvatar(
              //backgroundColor: Colors.cyan.withOpacity(0.3),
              backgroundColor: Colors.blue,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      //_slider = 0.0;
                      k = ++i;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Songspage(
                                    song_name: list[(k) % (list.length)]
                                            ["song_name"]
                                        .toString(),

                                    // audioManagerInstance=audioManagerInstance.previous();
                                    artist_name: list[(k) % (list.length)]
                                            ["artist_name"]
                                        .toString(),
                                    song_url: list[(k) % (list.length)]
                                            ["song_url"]
                                        .toString(),
                                    image_url: list[(k) % (list.length)]
                                            ["image_url"]
                                        .toString(),
                                    //index: _list.indexOf(song_name),
                                    list: list,
                                    i: k,
                                  )));
                      audioManagerInstance.next();
                      // songinfo(
                      //   list[audioManagerInstance.curIndex + 1]["song_name"],
                      //   list[audioManagerInstance.curIndex + 1]["artist_name"],
                      //   list[audioManagerInstance.curIndex + 1]["song_url"],
                      //   list[audioManagerInstance.curIndex + 1]["image_url"],
                      // );
                    });

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => Songspage(
                    //               song_name:
                    //                   list[audioManagerInstance.curIndex + 1],
                    //               // song_name: documentSnapshot.data()["song_name"],

                    //               // artist_name: documentSnapshot.data()["artist_name"],
                    //               // song_url: documentSnapshot.data()["song_url"],
                    //               // image_url: documentSnapshot.data()["image_url"],
                    //               //index: _list.indexOf(song_name),
                    //               list: list,
                    //             )));
                    // audioManagerInstance
                    //     .audioList[audioManagerInstance.curIndex + 1];
                    //Songspage(list[audioManagerInstance.curIndex + 1]);
                    // void next()
                    // {

                    // }
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                var data = {
                  "song_name": song_name.toString(),
                  "artist_name": artist_name.toString(),
                  "song_url": song_url.toString(),
                  "image_url": image_url.toString(),
                };

                firestoreinstance
                    .collection("downloads_$user_name")
                    .doc(song_name)
                    .set(data);
              },
              icon: Icon(Icons.download),
            ),
          ],
        ),
      ),
    ]);
  }
}
