import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_van_app/auth/accountselect.dart';
import 'package:school_van_app/auth/logindriver.dart';
import 'package:school_van_app/wrappers/authwrapper.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void startTimer() {
    if(mounted){
      var duration = Duration(seconds: 5);
      new Timer(duration, detailsScreen1Route);
    }
  }

  detailsScreen1Route() {
    if(mounted){
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => accountselect()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: new Color(0xff00154D),
            ),
          ),
          Center(
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'S C H O O L',
                  style: TextStyle(
                    fontSize: 60,
                    fontFamily: 'Chewy',
                    color: Color.fromARGB(255, 245, 246, 247),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'B U S',
                  style: TextStyle(
                      fontSize: 60,
                      fontFamily: 'Cherry Cream Soda',
                      color: Color.fromARGB(255, 248, 246, 246),
                      fontWeight: FontWeight.w400),
                ),
                Image.asset(
                  'assets/images/splash_screen.png',
                ),
                Text("An End-to-End Solution For School Bus Tracking...",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: Color.fromARGB(255, 248, 246, 246),
                        // fontWeight: FontWeight.w400),
                        fontStyle: FontStyle.italic))
              ],
            )),
          ),
        ],
      ),
    );
  }
}
