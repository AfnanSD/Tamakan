import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SurahView extends StatefulWidget {
  const SurahView({super.key, required this.surahName});

  final String surahName;
  @override
  State<SurahView> createState() => _SurahViewState();
}

class _SurahViewState extends State<SurahView> {
  List<String> ayahs = List<String>.empty(growable: true);
  String surahImg = '';
  var gettingData = true;

  var selectedSurahRepetition = 1;
  var selectedAyahRepetition = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAyahs();
    getSurahData();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/b2.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            gettingData
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      //header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.chevron_left,
                                  color: Color(0xff1A535C),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 45.0, vertical: 10),
                                child: Text(
                                  'سورة ${widget.surahName}',
                                  style: const TextStyle(
                                    fontFamily: 'Blabeloo',
                                    fontSize: 30,
                                    color: Color(0xff1A535C),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.home,
                                    color: Color(0xff1A535C),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //surah
                      Expanded(
                        child: Center(
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 25,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                                  Image.network(surahImg, fit: BoxFit.contain),
                            ),
                          ),
                        ),
                      ),
                      //control
                      const Text('عدد تكرار السورة'),
                      amountWidget(true),
                      const Text('عدد تكرار الآية'),
                      amountWidget(false),
                      IconButton(
                        onPressed: () {
                          repeateSurah(selectedSurahRepetition,
                              selectedAyahRepetition, ayahs);
                        },
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Color(0xff1A535C),
                        ),
                        iconSize: 100,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  void repeateSurah(int repeatSurah, int repeatAyah, List<String> URLs) {
    int x = 0;
    final player = AudioPlayer();
    int tmpAyah = 0;
    int compeletedSurah = repeatAyah * URLs.length;

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

  Future getAyahs() async {
    QuerySnapshot qs = await FirebaseFirestore.instance
        .collection('surah')
        .doc(widget.surahName)
        .collection('ayahs')
        .get();
    for (var element in qs.docs) {
      ayahs.add(element['recordURL']);
    }
  }

  Future getSurahData() async {
    await FirebaseFirestore.instance
        .collection('surah')
        .doc(widget.surahName)
        .get()
        .then((value) {
      setState(() {
        surahImg = value['imageURL'];
        gettingData = false;
      });
    });
  }

//chech for min = 1 max = 5?
  Widget amountWidget(bool isSurah) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: SizedBox(
            width: 140,
            height: 40,
            child: Center(
              child: Text(
                  isSurah
                      ? selectedSurahRepetition.toString()
                      : selectedAyahRepetition.toString(),
                  style: const TextStyle(
                    fontSize: 25,
                  )),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (isSurah) {
                      selectedSurahRepetition++;
                    } else {
                      selectedAyahRepetition++;
                    }
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ),
            const SizedBox(
              width: 100,
            ),
            CircleAvatar(
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (isSurah) {
                      selectedSurahRepetition--;
                    } else {
                      selectedAyahRepetition--;
                    }
                  });
                },
                icon: const Icon(Icons.remove),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
