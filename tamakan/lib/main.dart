import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:tamakan/View/child_homepage.dart';

import 'package:tamakan/View/game.dart';
import 'package:tamakan/View/learning_map.dart';
import 'package:tamakan/View/parent_homepage.dart';
import 'package:tamakan/View/temp.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

//import 'package:tamakan/View/game.dart';
//import 'package:tamakan/View/learning_map.dart';
import 'package:tamakan/View/loginView.dart';

import 'package:tamakan/View/registerationView.dart';
import 'package:tamakan/View/welcomeView.dart';

import 'View/learning_map3.dart';
import 'View/parentProfileView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xffFF6B6B)),
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontSize: 30,
              ),
            ),
      ),
      routes: <String, WidgetBuilder>{
        //'/LearningMap': (BuildContext context) => const LearningMap(),
        '/loginview': (BuildContext context) => loginview(),
        '/registerview': (BuildContext context) => registerationview(),
        '/ParentProfile': (BuildContext context) => ParentHomePage(),
        '/parentprofileview': (BuildContext context) => parentprofileview(),
      },
      home:  loginview(), //MyHomePage(),
      builder: EasyLoading.init(),
    );
  }
}

//good?
//https://medium.com/@nickysong/creating-a-custom-color-swatch-in-flutter-554bcdcb27f3
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  ;
  return MaterialColor(color.value, swatch);
}
