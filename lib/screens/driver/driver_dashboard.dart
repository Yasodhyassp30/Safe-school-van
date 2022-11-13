import 'package:flutter/material.dart';

class Driver_dashboard extends StatefulWidget {
  // final indexhange;
  // const Driver_dashboard({Key? key, this.indexhange}) : super(key: key);
  const Driver_dashboard({Key? key}) : super(key: key);

  @override
  State<Driver_dashboard> createState() => _Driver_dashboardState();
}

class _Driver_dashboardState extends State<Driver_dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [Text("Home")],
      ),
    );
  }
}
