import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_speech/google_speech.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecognize extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AudioRecognizeState();
}

class _AudioRecognizeState extends State<AudioRecognize> {
  bool recognizing = false;
  bool recognizeFinished = false;
  String text = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('here');
  }

  void recognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    //final serviceAccount = ServiceAccount.fromString();
//     r'''{
//   "type": "service_account",
//   "project_id": "tamakan-ef69b",
//   "private_key_id": "9c5c7163e38499f17981a3a55cfbc78783f36b89",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC+HTtqxm5K1LdY\nQ9AXp6H+NSKznMgPTkU/xBSFmXDgWX1r/ZmaPoCpDrIsJQmUos55cchaTc8oLrFS\n59LU2ONnEaKukifMVknyO/YODk/pTdG6R1qwKJfl4NUD0yIX0gTqWSzD3n5w/Mdo\nwJk3HshJZKwchrBW9+OmqTQeM3ALc/hJaOrFO9an4ENnUEd5rTTe8AxiaQQxHpeS\ne2/zQNTIPM63OqNQsXxYu6hBJfhWGiaxdwILZgbiISp5mVRJ3b3wG2COt5CJaGnI\nPPMIL4T7KwThNGEo7NqCG1eiWn1bW0tzgCsGq9XLRKL4CR8XB139ECJsT6s8lYrw\nZJI+/dGlAgMBAAECggEAHn9ffPs8ja4OhG8KdoT6eGZrPO95a3UlqDtLBHyPLjpE\n47pAtgzxRE16eRju7sRoRXSijJP/V6WX5iIQwPrTDgF2/LSvBDlSbvS9/da/bICC\nlLSmIGy+o06cNVsdFL+o8LQh+YDbfUIbthrxaTV7sURgVMophyYIg7+QgAjF4Fww\nlfolF7HrUdaETzziVanWB/wsU3ts8M3ZmhbXRJUyRNf2cOTtUVLwCQc8xQAFpvR8\nJH86TzHachqlD25Q7pnqjKiLDkc56TtCHQzJPCZEtcnukPImbKqqSS7pvZUjUgX7\n30jGFMvDuHifyB4rPN9vwqaUfh2kQCYjTViBRUl7sQKBgQD7VZZLR76Bd4bJruaQ\nnnsxDJXbWbYTX2q+wSCeem6LrJyECOp2GR/Mu3lyrc/TO+uJ8+A4i9YwB35DLCM8\nfkRvoRZQW+RhAU+KrdhDPPlnud80gamP8xiDP6JT2hKgfgPTEk/J1RyctF5XDCm1\nAsndDU8o4qd0oHv+pYeC026rsQKBgQDBpLWW+kQUNcoonBIWloYJZvma2aXyFfrE\n7mTPuHlKA5Src8Kchyt6ttmkZMo/ymnanvvjSwvxX1rjy1fBgyYBAEApgkRLP9JS\nDALHmQNoidmrcvZehnHdFgp3c71cbOjG0s23QG3VFVttWrwBrrtqWX4Rq4ygtXN7\nDYk84xgmNQKBgQCFqkDiDGfOpuiyPig05XQS4+SW4aEpsGcux7s3TVmZQtWCitNW\nt4nn8hRm3vVWG9nqZh7rM8NXi8SkqMacl3KCA6PAXP6acH4C/O205KqndXy1iffJ\nrLluo9sKyUF6xUn3aRex+XrcBDjgBoHv2GnO/BMLZW81YVxQU2w8MYH8IQKBgFY4\nvbZc9wU8sigE3jT6jvIOzOM7OB2j1cXsFC09iZwAHil9YNELiruYQS5mxntC6IE0\nuxmIp+ewuqqlNwzuFXTqpKcW3svWvhJUUMSJCDB6+NXTWYnbOUXk84IeodlOkRM+\nd+S5pm3zlYMKnJ3vLHn9IRpDFVnVkXbgHxRiVbVlAoGAWF2ZkrzDPs96Pq0+Kelb\n2/68j4mplIMK7PE3bUjJXGuidXWKb7H4IUM5ccKu8OmpxjaRiWIULE0LkfkT/GMx\nG3IoIne6+bQLU48fWY0ADnaIIE10/EJ5ft933IBF5iA8P9Z46NhFwFY/FYzEEUEh\nCPTeFwC3lssKWl0H0ym83HA=\n-----END PRIVATE KEY-----\n",
//   "client_email": "tamakan-speech-to-text@tamakan-ef69b.iam.gserviceaccount.com",
//   "client_id": "116075868641600141407",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/tamakan-speech-to-text%40tamakan-ef69b.iam.gserviceaccount.com"
// }'''
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();
    final audio = await _getAudioContent('test.wav');

    await speechToText.recognize(config, audio).then((value) {
      setState(() {
        text = value.results
            .map((e) => e.alternatives.first.transcript)
            .join('\n');
      });
    }).whenComplete(() => setState(() {
          recognizeFinished = true;
          recognizing = false;
        }));
  }

  void streamingRecognize() async {
    setState(() {
      recognizing = true;
    });
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/test_service_account.json'))}');
    final speechToText = SpeechToText.viaServiceAccount(serviceAccount);
    final config = _getConfig();

    final responseStream = speechToText.streamingRecognize(
        StreamingRecognitionConfig(config: config, interimResults: true),
        await _getAudioStream('test.wav'));

    responseStream.listen((data) {
      setState(() {
        text =
            data.results.map((e) => e.alternatives.first.transcript).join('\n');
        recognizeFinished = true;
      });
    }, onDone: () {
      setState(() {
        recognizing = false;
      });
    });
  }

  RecognitionConfig _getConfig() => RecognitionConfig(
      encoding: AudioEncoding.LINEAR16,
      model: RecognitionModel.basic,
      enableAutomaticPunctuation: true,
      sampleRateHertz: 16000,
      languageCode: 'en-US'); //en-US

  Future<void> _copyFileFromAssets(String name) async {
    var data = await rootBundle.load('assets/$name');
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    await File(path).writeAsBytes(
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<List<int>> _getAudioContent(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).readAsBytesSync().toList();
  }

  Future<Stream<List<int>>> _getAudioStream(String name) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path + '/$name';
    if (!File(path).existsSync()) {
      await _copyFileFromAssets(name);
    }
    return File(path).openRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio File Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            if (recognizeFinished)
              _RecognizeContent(
                text: text,
              ),
            ElevatedButton(
              onPressed: recognizing ? () {} : recognize,
              child: recognizing
                  ? CircularProgressIndicator()
                  : Text('Test with recognize'),
            ),
            SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: recognizing ? () {} : streamingRecognize,
              child: recognizing
                  ? CircularProgressIndicator()
                  : Text('Test with streaming recognize'),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _RecognizeContent extends StatelessWidget {
  final String text;

  const _RecognizeContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Text(
            'The text recognized by the Google Speech Api:',
          ),
          SizedBox(
            height: 16.0,
          ),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
