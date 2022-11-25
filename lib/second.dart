import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:on_audio_query_platform_interface/details/on_audio_query_helper.dart';

class second extends StatefulWidget {
  List<SongModel> songs;
  int index;

  second(this.songs, this.index);

  @override
  State<second> createState() => _secondState();
}

class _secondState extends State<second> {
  List<SongModel> songs = [];
  int index = 0;
  bool isplay = true;
  final player = AudioPlayer();
  double cur_pos = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    songs = widget.songs;
    index = widget.index;

    player.onPositionChanged.listen((Duration p) {
      print('Current position: $p');
      setState(() {
        cur_pos = p.inMilliseconds.toDouble();
      });
    });

    player.onPlayerComplete.listen((event) async {
      if (index != songs.length - 1) {
        await player.stop();
        index = index + 1;
        cur_pos = 0;
        isplay = true;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        toolbarHeight: 60,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text("${songs[index].displayName}",
            style: TextStyle(color: Colors.black), maxLines: 1),
      ),
      body: Center(
        child: Container(
          height: 450,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    offset: Offset(5.0, 5.0),
                    blurRadius: 9),
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 190,
                width: 190,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 2),
                    image: DecorationImage(
                        image: AssetImage("myimage/dance-music.gif"))),
              ),
              ListTile(
                title: Text(
                  "${songs[index].title}",
                  maxLines: 1,
                ),
                subtitle: Text(printDuration(
                    Duration(milliseconds: songs[index].duration!))),
              ),
              Slider(
                activeColor: Colors.black,
                inactiveColor: Colors.black26,
                thumbColor: Colors.black,
                value: cur_pos,
                min: 0,
                max: songs[index].duration!.toDouble(),
                onChanged: (value) async {
                  // setState(() {
                  //   cur_pos = value;
                  // });
                  await player.seek(Duration(milliseconds: value.toInt()));
                },
              ),
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        printDuration(Duration(milliseconds: cur_pos.toInt()))),
                    Text(printDuration(
                        Duration(milliseconds: songs[index].duration!))),
                  ],
                ),
              ),
              Container(
                width: 250,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          offset: Offset(5.0, 5.0),
                          blurRadius: 9),
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if (index != 0) {
                            await player.stop();
                            index = index - 1;
                            cur_pos = 0;
                            isplay = true;
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.arrow_back_ios)),
                    IconButton(
                        onPressed: () async {
                          if (isplay) {
                            await player
                                .play(DeviceFileSource(songs[index].data));
                          } else {
                            await player.pause();
                          }
                          setState(() {
                            isplay = !isplay;
                          });
                        },
                        icon: Icon(
                          (isplay) ? Icons.play_arrow : Icons.pause,
                          size: 32,
                        )),
                    IconButton(
                        onPressed: () async {
                          if (index != songs.length - 1) {
                            await player.stop();
                            index = index + 1;
                            cur_pos = 0;
                            isplay = true;
                            setState(() {});
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
