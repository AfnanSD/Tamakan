import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SurahView extends StatefulWidget {
  const SurahView({super.key});

  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  // final player = AudioPlayer();
  var num = 0;
  int x = 0;
  String path =
      'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803';
  String path2 =
      'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A8%D8%A7%D8%A1.mp3?alt=media&token=875c9ed7-1716-42f7-a78b-1a58e5d74d2c';
  List<String> ayahs = List<String>.empty(growable: true);

  //AudioCache audioCache = AudioCache();
  //final player = AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAyahs(''); //update this
    // player.onPlayerComplete.listen((event) {
    //   setState(() {
    //     num++;
    //   });
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // void _playLoopAudio() {
  //   print('object');
  //   int timesPlayed = 0;
  //   const timestoPlay = 3;
  //   //audio.mp3 is the local asset file
  //   audioCache
  //       .play(
  //           'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803')
  //       .then((player) {
  //     player.onPlayerCompletion.listen((event) {
  //       timesPlayed++;
  //       if (timesPlayed >= timestoPlay) {
  //         timesPlayed = 0;
  //         player.stop();
  //       } else {
  //         player.resume();
  //       }
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('data'),
          Text(num.toString()),
          Text('x'),
          Text(x.toString()),
          IconButton(
            onPressed: () {
              List<String> urls = [path, path2];
              repeateSurah(2, 2, ayahs);

              // List<String> arr = [path, path2];
              // // await repeateSurah(2, path);
              // for (var element in arr) {
              //   repeateSurah(1, element);
              // }

              // int timesPlayed = 0;
              // int timesToRepeat = 3; //The audio will repeat 3 times

              //This method gets called each time your audio finishes playing.
              //player.setReleaseMode(ReleaseMode.release);
              // player.onPlayerComplete;
              // for (var i = num; i < 3; i++) {
              //   print(';');
              //   player.play(DeviceFileSource(
              //       'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803'));
              //   if (num == 3) {
              //     player.setReleaseMode(ReleaseMode.release);
              //   }
              // }

              // player.onPlayerCompletion.listen((event) {
              //   //Here goes the code that will be called when the audio finishes
              //   onComplete();
              //   setState(() {
              //     position = duration;
              //     timesPlayed++;
              //     if(timesPlayed >= timesToRepeat) {
              //       timesPlayed = 0;
              //       await player.stop();
              //     }
              //   });
              // });
              // for (var i = 0; i < 3; i++) {
              //   print(i);
              // player.play(DeviceFileSource(
              //     'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803'));
              //   await player.play(DeviceFileSource(
              //       'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803'));
              //   await player.play(DeviceFileSource(
              //       'https://firebasestorage.googleapis.com/v0/b/tamakan-ef69b.appspot.com/o/practices%2F%D8%A3%D9%84%D9%81.mp3?alt=media&token=f542d369-e47c-441f-aadc-9f91c47dd803'));
              // }
            },
            icon: const Icon(
              Icons.volume_up_rounded,
              color: Color(0xff1A535C),
            ),
            iconSize: 100,
          ),
        ],
      ),
    );
  }

  void repeateSurah(int repeatSurah, int repeatAyah, List<String> URLs) {
    final player = AudioPlayer();
    int tmp = 0;
    int index = 0;
    setState(() {
      x = 0;
    });
    player.play(DeviceFileSource(URLs[0]));
    player.onPlayerComplete.listen((event) async {
      //player.release();?
      setState(() {
        print('x is' + x.toString());
        x++;
        tmp++;
      });

      if (x < (repeatAyah * repeatSurah)) {
        print('xxx is' + x.toString());
        print('tmp is' + tmp.toString());
        print('inex is' + index.toString());
        if (tmp == repeatAyah) {
          index++;
          tmp = 0;
        }
        player.play(DeviceFileSource(URLs[index]));
      } else {}
    });
    print('donee');
    player.stop(); //?
    //player.onPlayerStateChanged
  }

  Future getAyahs(String id) async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('surah')
        .doc('الإخلاص')
        .collection('ayahs')
        .get();
    for (var element in qs.docs) {
      ayahs.add(element['recordURL']);
    }
    print(ayahs);
  }
}
