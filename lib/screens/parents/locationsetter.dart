import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../wrappers/authwrapper.dart';

class locationsetter extends StatefulWidget {
  const locationsetter({Key? key}) : super(key: key);

  @override
  State<locationsetter> createState() => _locationsetterState();
}

class _locationsetterState extends State<locationsetter> {
  final _position=CameraPosition(target: LatLng(6,80),zoom: 14.0);
  Set<Marker>marks={};
  bool pickinglocation=false;
  LatLng ? current ;
  String error="";
  Position? start;
  GoogleMapController ? _con;

  void togglepicker(){
    setState(() {
      pickinglocation=!pickinglocation;
    });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    currentlocation();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top:10),
        child: Column(
          children: [
           Row(
             children: [
             Container(
               width: MediaQuery.of(context).size.width*0.7,
               child: Column(
                 children: [
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Row(
                       children: [
                         Text(
                           'Complete Profile',
                           style: TextStyle(
                               fontSize: 25, fontWeight: FontWeight.bold,color: Colors.blue[900]),
                         )
                       ],
                     ),
                   ),
                   Container(
                     padding: EdgeInsets.only(left: 10),
                     child: Row(
                       children: [
                         Text(
                           'Pick Your Home Location',
                           style: TextStyle(
                               fontSize: 18, fontWeight: FontWeight.bold),
                         )
                       ],
                     ),
                   ),
                 ],
               ),
             ),
               Expanded(child: SizedBox()),
               ElevatedButton(onPressed: (marks.length==0)?null:()async{

                 FirebaseFirestore store =FirebaseFirestore.instance;
                 FirebaseAuth _auth =FirebaseAuth.instance;
                 await store.collection('parent').doc(_auth.currentUser!.uid).update(
                     {'location':{'lat':marks.elementAt(0).position.latitude,'lon':marks.elementAt(0).position.longitude}});

                 Navigator.pushAndRemoveUntil(
                   context,
                   MaterialPageRoute(
                     builder: (BuildContext context) =>
                         authwrapper(),
                   ),
                       (route) => false,
                 );
               }, child: Text('Confirm')),
               SizedBox(width: 10,),
             ],
           ),
            Expanded(child: GoogleMap(initialCameraPosition: _position,
              onMapCreated: (GoogleMapController controller){
                _con=controller;
              },
              markers:marks,
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              onTap: (latlang){
                setState(() {
                  if(pickinglocation) {
                    marks.add(
                        Marker(markerId: MarkerId("Work Location"),
                            position: latlang,
                            icon: BitmapDescriptor.defaultMarker)
                    );
                    current=latlang;
                    togglepicker();
                  }
                });

              },
            ),)
          ],
        ),  
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: togglepicker,
        child: Icon(Icons.location_on),
        backgroundColor: Colors.blue[900],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

    );

  }
  void currentlocation()async{
      bool serviceen = await Geolocator.isLocationServiceEnabled();
      var get = await Geolocator.requestPermission();
      if (serviceen) {
        LocationPermission check = await Geolocator.checkPermission();
        var get = await Geolocator.requestPermission();
        if (check == LocationPermission.denied) {
          setState(() {
            error = "Service Not Enabled";
            return;
          });
        }
      }

      start = await Geolocator.getCurrentPosition();
      if(mounted){
        _con?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(start!.latitude, start!.longitude), zoom: 16)));
      }
    }

}
