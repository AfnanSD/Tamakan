import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SurahView extends StatefulWidget {
  const SurahView({super.key});

//get surahname
  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  // final player = AudioPlayer();
  var num = 0;
  int x = 0;
  List<String> ayahs = List<String>.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAyahs(''); //update this
  }

  @override
  void dispose() {
    super.dispose();
  }

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
              repeateSurah(2, 2, ayahs);
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
    int tmpAyah = 0;
    int compeletedSurah = repeatAyah * URLs.length;
    print(compeletedSurah.toString() + 'CS');

    int index = 0;
    setState(() {
      x = 0;
    });
    player.play(DeviceFileSource(URLs[0]));
    player.onPlayerComplete.listen((event) async {
      setState(() {
        x++;
        tmpAyah++;
        compeletedSurah--;
      });

      if (x < (repeatAyah * repeatSurah * URLs.length)) {
        print('xxx is' + x.toString());
        print('tmp is' + tmpAyah.toString());
        print('inex is' + index.toString());
        print(compeletedSurah.toString() + 'CS');
        if (tmpAyah == repeatAyah) {
          index++;
          tmpAyah = 0;
        }
        if (compeletedSurah == 0) {
          compeletedSurah = repeatAyah * (URLs.length + 1);
          index = 0;
        }
        player.play(DeviceFileSource(URLs[index]));
      } else {}
    });
    player.stop(); //?
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
  }
}
