import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:audio_manager/audio_manager.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';

class Songspage extends StatefulWidget {
  String song_name, artist_name, song_url, image_url, user_name, albumname;

  double slider_value;

  List list;
  Songspage({
    this.song_name,
    this.artist_name,
    this.song_url,
    this.image_url,
    this.list,
    this.user_name,
    this.albumname,
    this.slider_value,
  });
  @override
  SongspageState createState() => SongspageState(
        list,
        song_name,
        artist_name,
        song_url,
        image_url,
        user_name,
        albumname,
        slider_value,
      );
}

class SongspageState extends State<Songspage> {
  List list;

  double slider_value;
  AsyncSnapshot<QuerySnapshot> snapshot;

  String song_name, artist_name, song_url, image_url, user_name, albumname;
  SongspageState(
    this.list,
    this.song_name,
    this.artist_name,
    this.song_url,
    this.image_url,
    //this.i,
    this.user_name,
    this.albumname,
    this.slider_value,
  );

  bool isplaying1 = false;
  String platformVersion = 'Unknown';
  int i = -1;
  var audioManagerInstance = AudioManager.instance;
  var firestoreinstance = FirebaseFirestore.instance;
  bool isPlaying = false;
  Duration duration;
  Duration position;
  bool col = false;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    setupAudio();
  }

  void setupAudio() {
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
        case AudioManagerEvents.start:
          print(
              "start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          slider_value = 0;

          AudioManager.instance.updateLrc("audio resource loading....");
          break;
        case AudioManagerEvents.ready:
          print("ready to play");

          position = AudioManager.instance.position;
          duration = AudioManager.instance.duration;
          setState(() {});

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
          i++;
          setState(
            () {
              song_name = list[(i) % (list.length)]["song_name"].toString();

              artist_name = list[(i) % (list.length)]["artist_name"].toString();
              song_url = list[(i) % (list.length)]["song_url"].toString();
              image_url = list[(i) % (list.length)]["image_url"].toString();

              list = list;
            },
          );

          break;
        default:
          break;
      }
    });
  }

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
                child: Image.network(image_url, height: 350.0),
                elevation: 10.0,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.05,
              ),
              Text(
                song_name,
                style: TextStyle(
                  fontSize: 25.0,
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              Text(
                artist_name,
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
    try {
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
                  value: slider_value ?? 0,
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
    } on AssertionError {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    ;
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
                var data = {
                  "song_name": song_name.toString(),
                  "artist_name": artist_name.toString(),
                  "song_url": song_url.toString(),
                  "image_url": image_url.toString(),
                };
                if (col == false) {
                  firestoreinstance
                      .collection("favourites_$user_name")
                      .doc(song_name)
                      .set(data);
                }

                setState(() {
                  col = !col;
                });
              },
              icon: Icon(
                EvaIcons.heart,
                color: col ? Colors.red : Colors.black,
              ),
            ),
            CircleAvatar(
              child: Center(
                child: IconButton(
                    icon: Icon(
                      Icons.skip_previous,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      i--;
                      audioManagerInstance.previous();
                      setState(
                        () {
                          song_name = list[(i + (list.length)) % (list.length)]
                                  ["song_name"]
                              .toString();

                          artist_name =
                              list[(i + (list.length)) % (list.length)]
                                      ["artist_name"]
                                  .toString();
                          song_url = list[(i + (list.length)) % (list.length)]
                                  ["song_url"]
                              .toString();
                          image_url = list[(i + (list.length)) % (list.length)]
                                  ["image_url"]
                              .toString();

                          list = list;
                        },
                      );
                    }),
              ),
              backgroundColor: Colors.blue,
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
              backgroundColor: Colors.blue,
              child: Center(
                child: IconButton(
                  icon: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    i++;
                    audioManagerInstance.next();
                    setState(() {
                      //_slider = 0.0;

                      song_name =
                          list[(i) % (list.length)]["song_name"].toString();

                      artist_name =
                          list[(i) % (list.length)]["artist_name"].toString();
                      song_url =
                          list[(i) % (list.length)]["song_url"].toString();
                      image_url =
                          list[(i) % (list.length)]["image_url"].toString();

                      list = list;
                    });
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "profile");
              },
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
