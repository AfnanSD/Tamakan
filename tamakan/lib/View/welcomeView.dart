import 'package:flutter/material.dart';

class welcomeView extends StatefulWidget {
  static const String screenRoute = 'welcomeView';

  const welcomeView({Key? key}) : super(key: key);

  @override
  State<welcomeView> createState() => _welcomeViewState();
}

class _welcomeViewState extends State<welcomeView> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //return Scaffold(body: Text("Hello"));
    final signupButton = Container(
        //margin: const EdgeInsets.only(right: 200, left: 200),
        child: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xffFF6B6B),
      child: MaterialButton(
        //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.pushNamed(context, '/registerview');
        },
        child: Text(
          "مستخدم جديد ",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
    final signinButton = Container(
        //margin: const EdgeInsets.only(right: 200, left: 200),
        child: Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(30),
      color: Color.fromRGBO(255, 230, 109, 1),
      child: MaterialButton(
        //padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        //minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.pushNamed(context, '/loginview');
        },
        child: Text(
          "تسجيل دخول",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 71, 81, 80),
              fontWeight: FontWeight.bold),
        ),
      ),
    ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/welcome.png"),
              fit: BoxFit.fill //BoxFit.cover,
              ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 910,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    signinButton,
                    SizedBox(
                      width: 40,
                    ),
                    signupButton,
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //The variables that are going to store the values entered by the user
}
