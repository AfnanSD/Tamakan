import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:audioplayers/audioplayers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Create a storage reference from our app
            final storageRef = FirebaseStorage.instance.ref();

            // Create a reference with an initial file path and name
            final pathReference = storageRef.child("/practices/ألف.mp3");
            // Create a reference to a file from a Google Cloud Storage URI
            final gsReference = FirebaseStorage.instance
                .refFromURL("gs://tamakan-ef69b.appspot.com/practices/ألف.mp3");

            await player
                .play(DeviceFileSource(await gsReference.getDownloadURL()));
            print('5');
          },
          child: Text('play'),
        ),
      ),
    );
  }
}
