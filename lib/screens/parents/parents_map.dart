import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:ui' as ui;

import '../../services/notifications.dart';

class Parents_map extends StatefulWidget {
  final markerdriver,markeruser,driverids,notified,change;
  const Parents_map({Key? key,this.markerdriver,this.markeruser,this.driverids,this.notified,this.change}) : super(key: key);

  @override
  State<Parents_map> createState() => _Parents_mapState();
}

class _Parents_mapState extends State<Parents_map> {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;
  LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 1);
  BitmapDescriptor? customIcon;
  LatLng ?current;
  String? error;
  LatLng? initital = LatLng(0, 0);
  GoogleMapController? control;
  bool loading = false;
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> polylineCoordinates = [];
  Map<PolylineId, Polyline> polylines = {};
  Set<Marker> marks = {};
  bool started = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    locationservice();


  }
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    locationservice();
  }
  @override
  Widget build(BuildContext context) {
      return SafeArea(
          child:Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.height,
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.only(top: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child:Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            "Map",
                            style: TextStyle(
                                fontSize: 25.0,
                                color: Colors.indigo[900],
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                      ],
                    ),
                    (widget.driverids.length!=0)?
                    StreamBuilder<QuerySnapshot>(stream:store.collection('location').where(FieldPath.documentId,whereIn:widget.driverids ).snapshots(),builder: (context,locations){
                      if(locations.connectionState!=ConnectionState.waiting){
                        locations.data!.docs.forEach((element) {
                          for(var i in marks){
                            if(i.markerId==MarkerId('${element.id}')){
                              marks.remove(i);
                              break;
                            }
                          }
                          String time ='-';

                          if(element.get('speed')!=null&&element.get('speed').ceil()!=0 &&current?.longitude!=null){
                            double distance = Geolocator.distanceBetween(element.get('corrds')['lat'], element.get('corrds')['long'], current!.latitude, current!.longitude);
                            time =((distance/element.get('speed').ceil()/60).toInt()).toString();
                            if(int.parse(time)>100){
                              time ="100+";
                            }

                          }
                          if(element.get('corrds')['lat']!=null) {
                            marks.add(Marker(
                                markerId: MarkerId('${element.id}'),
                                icon: BitmapDescriptor.fromBytes(
                                    widget.markerdriver!),
                                position: LatLng(element.get('corrds')['lat'],
                                    element.get('corrds')['long']),
                                infoWindow: InfoWindow(
                                  title: '${element.get('name')}',
                                  snippet: time + ' min',

                                )

                            ));
                          }

                        });
                      }
                      return Expanded(
                          child: Container(
                            child: GoogleMap(
                              initialCameraPosition:
                              CameraPosition(target: initital!, zoom: 16),
                              onMapCreated: (GoogleMapController ctrl) {
                                control = ctrl;

                              },
                              markers: marks,
                              polylines: Set<Polyline>.of(polylines.values),
                            ),
                          ));
                    }):
                    Expanded(
                        child: Container(
                          child: GoogleMap(
                            initialCameraPosition:
                            CameraPosition(target: initital!, zoom: 16),
                            onMapCreated: (GoogleMapController ctrl) {
                              control = ctrl;

                            },
                            markers: marks,
                            polylines: Set<Polyline>.of(polylines.values),
                          ),
                        ))
                  ],
                ),
              ),
            ),
          )
      );
  }
  Future locationservice() async {
    bool serviceen = await Geolocator.isLocationServiceEnabled();
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
  DocumentSnapshot d1= await store.collection('parent').doc(_auth.currentUser!.uid).get();
    current =LatLng(d1.get('location')['lat'], d1.get('location')['lon']);
  marks.add(
    Marker(
        markerId: MarkerId('My location'),
        icon: BitmapDescriptor.fromBytes(widget.markeruser!),
        position: LatLng(d1.get('location')['lat'], d1.get('location')['lon']),
        infoWindow: InfoWindow(
          title: 'Your Location',

        )

    ),
  );
  if(mounted){
    control?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(d1.get('location')['lat'], d1.get('location')['lon']), zoom: 16)));
    setState(() { });
  }


    if(widget.driverids.length!=0){
      store.collection('location').where(FieldPath.documentId,whereIn:widget.driverids ).snapshots().listen((event) async{
        event.docs.forEach((element)async {
          String time ='-';
          if(element.get('speed').ceil()!=0 &&element.get('speed')!=null&&current?.longitude!=null&&!widget.notified){
            double distance = Geolocator.distanceBetween(element.get('corrds')['lat'], element.get('corrds')['long'], current!.latitude, current!.longitude);
            time =(((distance/element.get('speed')).ceil()/60).toInt()).toString();

            if(int.parse(time)<=5&&element.get('status')){
              NotificationService.shownotification(title: '${element.get('name')}',body:'I\'m Less than 5 min away',payload: 'pick up  notification' );
                await store.collection('location').doc(element.id).update({'alert':FieldValue.arrayUnion([_auth.currentUser!.uid])});
              }


            }


          }
        });
      });
    }

  }
}
