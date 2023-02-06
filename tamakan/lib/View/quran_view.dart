import 'package:flutter/material.dart';
import 'package:tamakan/View/surah_view.dart';

class QuranView extends StatelessWidget {
  QuranView({super.key, required this.childID});

  final String childID;

  final List<String> surahs = [
    'الإخلاص',
    'الفلق',
    "الناس",
    'الفاتحة',
    'الكوثر'
  ];

  List<Color> surahsColor = const [
    Color(0xff4ECDC4),
    Color(0xff1A535C),
    Color(0xffFF6B6B),
    Color(0xffFFE66D),
  ];

  //   Color(0xff4ECDC4),
  // Color(0xff1A535C),
  // Color(0xffFF6B6B),
  // Color(0xffFFE66D),
  //   Color.fromARGB(255, 200, 245, 242),
  // Color.fromARGB(255, 209, 248, 255),
  // Color.fromARGB(255, 255, 239, 239),
  // Color.fromARGB(255, 250, 242, 201),
  int colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //appbar needed?
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Image.asset(
              'assets/images/logo3.png',
              scale: 0.5,
            ),
          ],
          backgroundColor: const Color(0xffFF6B6B),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                'القرآن الكريم',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Text(
                'قصار السور',
                style: TextStyle(fontSize: 25, color: Colors.grey[700]),
              ),
            ),
            Expanded(
              child: ListView(
                children: surahs
                    .map(
                      (e) => Card(
                        color: surahsColor[colorIndex++ % 4],
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        child: InkWell(
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            height: 80,
                            child: Center(
                                child: Text(
                              e,
                              style: const TextStyle(color: Colors.white),
                            )),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SurahView(
                                surahName: e,
                                childID: childID,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
