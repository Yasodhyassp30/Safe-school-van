import 'package:flutter/material.dart';

class Driver_Map extends StatefulWidget {
  const Driver_Map({Key? key}) : super(key: key);

  @override
  State<Driver_Map> createState() => _Driver_MapState();
}

class _Driver_MapState extends State<Driver_Map> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [Text("Map")],
      ),
    );
  }
}
