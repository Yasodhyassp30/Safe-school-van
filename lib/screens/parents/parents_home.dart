import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:school_van_app/screens/parents/parent_profile_main.dart';
import 'package:school_van_app/screens/parents/parents_dashboard.dart';
import 'package:school_van_app/screens/parents/parents_map.dart';
import 'dart:ui' as ui;
import 'package:school_van_app/screens/parents/parents_profile.dart';

import '../../auth/accountselect.dart';
import '../../loadingscreen.dart';
import '../../services/notifications.dart';

class Parent_Home extends StatefulWidget {
  const Parent_Home({Key? key}) : super(key: key);

  @override
  State<Parent_Home> createState() => _Parent_HomeState();
}

class _Parent_HomeState extends State<Parent_Home> {
  int _selected = 0;
  bool started = false;
  String? kidid;
  List driverids = [];
  bool notified = false;

  Uint8List? markerIcondriver;
  Uint8List? markerIconuser;
  List childdata = [];
  List driverdata = [];
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore store = FirebaseFirestore.instance;

  String? selected;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  void _ontapped(int index) {
    index == 0
        ? _drawerKey.currentState?.openDrawer()
        : setState(() {
            _selected = index;
            print(_selected);
          });
  }
  void getids()async{
    QuerySnapshot q1 =await store.collection('children').where('parentid',isEqualTo: _auth.currentUser!.uid).get();
    q1.docs.forEach((element){
      driverids.add(element.get('driverid'));
      selected =element.get('driverid');
    });
  }

  void snapshotstream() async {
    Stream details = store
        .collection('children')
        .where('parentid', isEqualTo: _auth.currentUser!.uid)
        .snapshots();
    StreamSubscription sub = details.distinct().listen((event) {
      event.docChanges.forEach((element) async {
        if (element.doc.get('started')) {
          if (element.doc.get('dropped')) {
            NotificationService.shownotification(
                title: '${element.doc.get('drivername')}',
                body: 'Child safely arrived at destination',
                payload: 'drop notification');
          } else if (element.doc.get('t2remainder')) {
            NotificationService.shownotification(
                title: '${element.doc.get('drivername')}',
                body: 'Child picked up from the school',
                payload: 'pick up  notification');
          } else if (element.doc.get('atschool')) {
            NotificationService.shownotification(
                title: '${element.doc.get('drivername')}',
                body: 'Child safely arrived at school',
                payload: 'drop notification');
          } else if (element.doc.get('picked_up')) {
            NotificationService.shownotification(
                title: '${element.doc.get('drivername')}',
                body: 'Child picked up from the house',
                payload: 'drop notification');
          } else if (element.doc.get('notifed')) {
            NotificationService.shownotification(
                title: '${element.doc.get('drivername')}',
                body: 'I\'m Arrivaing soon',
                payload: 'drop notification');
          }
        }
      });
    });
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        sub.cancel();
      }
    });
  }

  void backgroundservice() async {
    final androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "School Van App",
        notificationText: "App is Running",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon: AndroidResource(
            name: 'background_icon',
            defType: 'drawable'), // Default is ic_launcher from folder mipmap
        enableWifiLock: false);
    bool success =
        await FlutterBackground.initialize(androidConfig: androidConfig);
    await FlutterBackground.enableBackgroundExecution();
  }

  getBytesFromAssetfordriver(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    markerIcondriver =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
  }

  getBytesFromAssetforuser(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    markerIconuser =
        (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
            .buffer
            .asUint8List();
  }

  void changeselected(driverid, childid) {
    selected = driverid;
    kidid = childid;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    backgroundservice();
    snapshotstream();
    getids();
    getBytesFromAssetfordriver('assets/images/mapbus.png', 75);
    getBytesFromAssetforuser('assets/images/user_location.png', 75);
    NotificationService.init();
  }

  void change() {
    notified = !notified;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Parent_Dashboard(selected: selected, kidid: kidid, ontapped: _ontapped),
      Parent_Dashboard(selected: selected, kidid: kidid, ontapped: _ontapped),
      Parents_map(
        markerdriver: markerIcondriver,
        markeruser: markerIconuser,
        driverids: driverids,
        notified: notified,
        change: change,
      ),
      ParentProfileMain()
    ];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xffE5E5E5),
      key: _drawerKey,
      drawer: Drawer(
          backgroundColor: Color(0xfff1f3fa),
          child: Column(
            // padding: EdgeInsets.zero,
            children: [
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 250, 251),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: MediaQuery.of(context).size.height * 0.06,
                            backgroundColor: Colors.amber,
                            foregroundImage:
                                AssetImage('assets/images/avatar.png')),
                        SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          '  ${_auth.currentUser!.displayName}',
                          maxFontSize: 20,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                // margin: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                padding: EdgeInsets.all(12.0),
                height: MediaQuery.of(context).size.height * 0.6,
                width: MediaQuery.of(context).size.width * 1,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Select your child",
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                            child: Row(
                          children: [
                            Icon(
                              Icons.add,
                              size: 15,
                              color: Colors.grey,
                            ),
                            TextButton(
                                onPressed: () async {
                                  var wait = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController name =
                                            TextEditingController();
                                        TextEditingController school =
                                            TextEditingController();
                                        TextEditingController email =
                                            TextEditingController();
                                        String error = "";
                                        bool loading = false;
                                        return StatefulBuilder(
                                            builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text("Add Child"),
                                            content: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.3,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.9,
                                                child: (!loading)
                                                    ? ListView(
                                                        children: [
                                                          Text(
                                                            error,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .redAccent),
                                                          ),
                                                          Container(
                                                            child: TextField(
                                                              controller: name,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "Child name",
                                                                      hintStyle: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            child: TextField(
                                                              controller:
                                                                  school,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "School",
                                                                      hintStyle: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Container(
                                                            child: TextField(
                                                              controller: email,
                                                              decoration:
                                                                  InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15.0),
                                                                      ),
                                                                      contentPadding:
                                                                          EdgeInsets.all(
                                                                              15),
                                                                      filled:
                                                                          true,
                                                                      fillColor:
                                                                          Colors
                                                                              .white,
                                                                      hintText:
                                                                          "Driver email",
                                                                      hintStyle: TextStyle(
                                                                          color: Colors
                                                                              .grey,
                                                                          fontSize:
                                                                              15.0)),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      )
                                                    : Container(
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                        child: loadfadingcube(),
                                                      )),
                                            actions: [
                                              Container(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: ElevatedButton(
                                                      onPressed: () async {
                                                        if (email.text
                                                                .trim()
                                                                .isNotEmpty &&
                                                            name.text
                                                                .trim()
                                                                .isNotEmpty &&
                                                            school.text
                                                                .trim()
                                                                .isNotEmpty) {
                                                          setState(() {
                                                            loading = true;
                                                          });
                                                          QuerySnapshot check =
                                                              await store
                                                                  .collection(
                                                                      'driver')
                                                                  .where(
                                                                      'Email',
                                                                      isEqualTo: email
                                                                          .text
                                                                          .trim()
                                                                          .toLowerCase())
                                                                  .get();
                                                          if (check
                                                              .docs.isEmpty) {
                                                            setState(() {
                                                              error =
                                                                  'Email Not Registered';
                                                              setState(() {
                                                                loading = false;
                                                              });
                                                            });
                                                          } else {
                                                            DocumentSnapshot
                                                                data =
                                                                await store
                                                                    .collection(
                                                                        'parent')
                                                                    .doc(_auth
                                                                        .currentUser!
                                                                        .uid)
                                                                    .get();
                                                            await store
                                                                .collection(
                                                                    'requests')
                                                                .doc(check
                                                                    .docs[0].id)
                                                                .set(
                                                                    {
                                                                  'requests': [
                                                                    {
                                                                      'name': name
                                                                          .text
                                                                          .trim(),
                                                                      'school': school
                                                                          .text
                                                                          .trim(),
                                                                      'parentid': _auth
                                                                          .currentUser!
                                                                          .uid,
                                                                      'address':
                                                                          data.get(
                                                                              'address')
                                                                    }
                                                                  ]
                                                                },
                                                                    SetOptions(
                                                                        merge:
                                                                            true));
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                            const message =
                                                                SnackBar(
                                                              content: Text(
                                                                  'Request Send'),
                                                            );
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(
                                                                    message);
                                                            Navigator.pop(
                                                                context);
                                                          }
                                                        } else {
                                                          setState(() {
                                                            error =
                                                                'Fill all Fields';
                                                            setState(() {
                                                              loading = false;
                                                            });
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(20),
                                                        child: Text("Submit"),
                                                      ),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Colors
                                                                  .blue[900]),
                                                    ))
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                      });
                                },
                                child: AutoSizeText(
                                  "Add Child",
                                  maxLines: 1,
                                  maxFontSize: 12,
                                  style: TextStyle(color: Colors.grey),
                                ))
                          ],
                        )),
                      ),
                    ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: store
                                .collection('children')
                                .where('parentid',
                                    isEqualTo: _auth.currentUser!.uid)
                                .snapshots(),
                            builder: (context, snap) {
                              if (snap.connectionState !=
                                  ConnectionState.waiting) {
                                childdata = snap.data!.docs as List;
                                driverids = [];
                                childdata.forEach((element) {
                                  driverids.add(element['driverid']);
                                  selected = element['driverid'];
                                  kidid = element.id;
                                });
                              }
                              return ListView.builder(
                                itemCount: childdata.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    color: Color(0xff001B61),
                                    child: InkWell(
                                      splashColor: Colors.white,
                                      onTap: () {
                                        setState(() {
                                          selected =
                                              childdata[index]['driverid'];
                                          kidid = childdata[index].id;
                                        });
                                      },
                                      child: SizedBox(
                                        width: 300,
                                        // height: 60,
                                        child: Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.amber,
                                                  foregroundImage: AssetImage(
                                                      'assets/images/avatar.png')),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${childdata[index]['name']}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    '${childdata[index]['school']}',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            })),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(12.0),

                  // height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 1,
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 16)),
                          onPressed: () {
                            _ontapped(3);
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.person_outline_sharp,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'My Profile',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.white,
                              textStyle: const TextStyle(fontSize: 16)),
                          onPressed: () async {
                            _auth.signOut();
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => accountselect()),
                                (route) => false);
                            await FlutterBackground
                                .disableBackgroundExecution();
                            setState(() {});
                          },
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout_rounded,
                                color: Colors.black,
                                size: 20,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              const Text(
                                'Log out',
                                style: TextStyle(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ],
          )),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.indigo[400],
        type: BottomNavigationBarType.shifting,
        selectedItemColor: Colors.white,
        currentIndex: _selected,
        onTap: _ontapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.menu_book_rounded,
            ),
            label: "Menu",
            backgroundColor: Color(0xff4E8CDD),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: "Home",
            backgroundColor: Color(0xff4E8CDD),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            label: "Map",
            backgroundColor: Color(0xff4E8CDD),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.airport_shuttle_outlined),
          //   label: "Kids",
          //   backgroundColor: Colors.indigo[600],
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_sharp),
            label: "Profile",
            backgroundColor: Color(0xff4E8CDD),
          )
        ],
      ),
      body: Center(
        child: (selected != null || _selected == 2 || _selected == 3)
            ? _widgetOptions.elementAt(_selected)
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: SafeArea(
                  child: Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50)),

                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Welcome ${_auth.currentUser!.displayName} !!! ',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontFamily: 'Cherry Cream Soda',
                                    color: Color.fromARGB(255, 245, 246, 247),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8,),
                              Expanded(child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage('assets/images/schoolvan.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              )),
                            ],
                          )),
                      FutureBuilder<QuerySnapshot>(
                          future: store
                              .collection('children')
                              .where('parentid',
                                  isEqualTo: _auth.currentUser!.uid)
                              .get(),
                          builder: (context, data) {
                            bool childhave = false;
                            if (data.connectionState !=
                                ConnectionState.waiting) {
                              if (data.data!.docs.isNotEmpty) {
                                childhave = true;
                              }
                            }
                            return Expanded(
                              child: Container(
                                child: Padding(
                                    padding: EdgeInsets.all(16),
                                    child: (childhave)
                                        ? Text(
                                            "Select Child from Menu to continue.....",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Cherry Cream Soda',
                                              color: Colors.blue[900],
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        : Text(
                                            "Add the information of your child in Profile section..!",
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Cherry Cream Soda',
                                              color: Colors.blue[900],
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                              ),
                            );
                          })
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
