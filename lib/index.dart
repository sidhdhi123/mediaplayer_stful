import 'package:flutter/material.dart';
import 'package:fp24/second.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class index extends StatefulWidget {
  const index({Key? key}) : super(key: key);

  @override
  State<index> createState() => _indexState();
}

class _indexState extends State<index> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_permission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Music App"),
      ),
      body: FutureBuilder(
        future: get_songs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<SongModel> songs = snapshot.data as List<SongModel>;
              return ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  SongModel s = songs[index];

                  return ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return second(songs, index);
                        },
                      ));
                    },
                    title: Text("${s.title}"),
                    subtitle: Text("${s.artist}"),
                    // leading: Text("${s.fileExtension}"),
                    trailing: Text(
                        printDuration(Duration(milliseconds: s.duration!))),
                  );
                },
              );
            } else {
              return Center(
                child: Text("No Data Yet"),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
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

  Future get_songs() async {
    List<SongModel> songs = await _audioQuery.querySongs();
    if (songs.isEmpty) {
      return null;
    } else {
      return songs;
    }
  }

  get_permission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      Permission.storage.request();
    }
    status = await Permission.storage.status;
    if (status.isGranted) {
      print("We Have Permission");
    }
  }
}
