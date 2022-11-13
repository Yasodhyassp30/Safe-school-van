
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:school_van_app/screens/parents/parents_home.dart';
import 'package:school_van_app/wrappers/authwrapper.dart';

import '../models/user_model.dart';
import '../screens/parents/locationsetter.dart';
import '../screens/splash_screen.dart';

class parentwrapper extends StatefulWidget {
  final data;
  const parentwrapper({Key? key,this.data}) : super(key: key);

  @override
  State<parentwrapper> createState() => _parentwrapperState();
}

class _parentwrapperState extends State<parentwrapper> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentlocation();
  }
  Widget build(BuildContext context) {
    if (widget.data.containsKey('location')) {
      return Parent_Home();
    } else {
      return locationsetter();
    }
  }
  void currentlocation()async{

      bool serviceen = await Geolocator.isLocationServiceEnabled();
      if (serviceen) {
        var get = await Geolocator.requestPermission();
        LocationPermission check = await Geolocator.checkPermission();
        if (check == LocationPermission.denied) {
          setState(() async{
            var get = await Geolocator.requestPermission();
            return;
          });
        }
      }
    }
}


