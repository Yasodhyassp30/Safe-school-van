import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:school_van_app/screens/driver/childs_info.dart';
import 'package:school_van_app/screens/driver/driver_dashboard.dart';
import 'package:school_van_app/screens/driver/driverhomefile.dart';
import 'package:school_van_app/locationservice/mapservice.dart';
import 'package:school_van_app/screens/driver/drivers_profile.dart';

class driverhome extends StatefulWidget {
  const driverhome({Key? key}) : super(key: key);

  @override
  State<driverhome> createState() => _driverhomeState();
}

class _driverhomeState extends State<driverhome> {
  int _selected = 0;
  bool started = false;
  void _ontapped(int index) {
    setState(() {
      _selected = index;
    });
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff1f3fa),
      body: Container(
          child: <Widget>[
        driversH(
          indexhange: _ontapped,
        ),
        locationfind(),
        Child_Info(),
        Driver_profile()
      ].elementAt(_selected)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo[400],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        currentIndex: _selected,
        onTap: _ontapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home",
            backgroundColor: Colors.indigo[400],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: "Map",
            backgroundColor: Colors.indigo[500],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            label: "Kids",
            backgroundColor: Colors.indigo[600],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: "Profile",
            backgroundColor: Colors.indigo[700],
          )
        ],
      ),
    );
  }
}
