import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:school_van_app/loadingscreen.dart';
import 'package:intl/intl.dart';
import 'package:school_van_app/screens/driver/requests.dart';

class driversH extends StatefulWidget {
  final indexhange;
  const driversH({Key? key, this.indexhange}) : super(key: key);

  @override
  State<driversH> createState() => _driversHState();
}

class _driversHState extends State<driversH> {
  bool runingservice = false;
  List students = [];
  FirebaseFirestore store = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  int requests = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> serviceruning() async {
    return await FlutterBackground.isBackgroundExecutionEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: store
            .collection('children')
            .where('driverid', isEqualTo: _auth.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return loadfadingcube();
          }
          if (snapshot.connectionState != ConnectionState.waiting) {
            students = snapshot.data!.docs;
          }
          return Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SafeArea(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi  ${_auth.currentUser!.displayName}..!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                ],
                              )
                            ],
                          )),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              width: MediaQuery.of(context).size.width * 0.45,
                              decoration: BoxDecoration(
                                color: Colors.lightBlue,
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height *
                                        0.03,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/students.png'))),
                                  ),
                                  Text(
                                    '${students.length}',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                        color: Colors.white),
                                  ),
                                  Text(
                                    'Students',
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.04,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              widget.indexhange(2);
                            },
                          ),
                          StreamBuilder<DocumentSnapshot>(
                              stream: store
                                  .collection('requests')
                                  .doc(_auth.currentUser!.uid)
                                  .snapshots(),
                              builder: (context, reqeuestno) {
                                if (reqeuestno.data?.data() != null) {
                                  requests =
                                      reqeuestno.data!.get('requests').length;
                                }
                                return GestureDetector(
                                  onTap: () async {
                                    var wait = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                joinrequests()));
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 239, 196, 37),
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.03,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/add.png'))),
                                        ),
                                        Text(
                                          '${requests}',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.05,
                                              color: Colors.white),
                                        ),
                                        Text(
                                          'Requests',
                                          style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.04,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              })
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FutureBuilder<DocumentSnapshot>(
                          future: store
                              .collection('driver')
                              .doc(_auth.currentUser!.uid)
                              .get(),
                          builder: (context, snap2) {
                            Map t1 = {'start': '-', 'end': '-'};
                            Map t2 = {'start': '-', 'end': '-'};
                            if (snap2.connectionState !=
                                    ConnectionState.waiting &&
                                snap2.data!.data() != null) {
                              Map tripdata = snap2.data!.data() as Map;
                              if (tripdata.containsKey('trip2')) {
                                t2['start'] = snap2.data!.get('trip2')['start'];
                                t2['end'] = snap2.data!.get('trip2')['end'];
                              }
                              if (tripdata.containsKey('trip1')) {
                                t1['start'] = snap2.data!.get('trip1')['start'];
                                t1['end'] = snap2.data!.get('trip1')['end'];
                              }
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                    child: Container(
                                      padding: EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width *
                                          0.45,
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromARGB(
                                                      255, 22, 22, 22)
                                                  .withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 1,
                                              offset: Offset(1,
                                                  1), // changes position of shadow
                                            ),
                                          ],
                                          color: Colors.blue[900],
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          Text(
                                            'Trip 1',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Start',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${t1['start']}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 10,
                                            thickness: 0.6,
                                            indent: 0,
                                            endIndent: 0,
                                            color: Color(0xff4E8CDD),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'End',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                '${t1['end']}',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                size: 15,
                                                color: Color.fromARGB(
                                                    255, 166, 167, 168),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                "Edit",
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 166, 167, 168)),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    onTap: () async {
                                      var wait = await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            TimeOfDay start = TimeOfDay.now();
                                            TimeOfDay end = TimeOfDay.now();
                                            return StatefulBuilder(
                                                builder: (context, setState) {
                                              return AlertDialog(
                                                title: Text("Trip 1"),
                                                content: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.8,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.15,
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          166,
                                                                          167,
                                                                          168), // background
                                                                  onPrimary: Colors
                                                                      .white, // foreground
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  TimeOfDay
                                                                      selectedTime =
                                                                      TimeOfDay
                                                                          .now();
                                                                  TimeOfDay?
                                                                      pickedTime =
                                                                      await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        selectedTime,
                                                                  );
                                                                  setState(() {
                                                                    start =
                                                                        pickedTime!;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'Start  ',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )),
                                                            Text(
                                                                '${MaterialLocalizations.of(context).formatTimeOfDay(start)}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18))
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  primary: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          166,
                                                                          167,
                                                                          168), // background
                                                                  onPrimary: Colors
                                                                      .white, // foreground
                                                                ),
                                                                onPressed:
                                                                    () async {
                                                                  TimeOfDay
                                                                      selectedTime =
                                                                      TimeOfDay
                                                                          .now();
                                                                  TimeOfDay?
                                                                      pickedTime =
                                                                      await showTimePicker(
                                                                    context:
                                                                        context,
                                                                    initialTime:
                                                                        selectedTime,
                                                                  );
                                                                  setState(() {
                                                                    end =
                                                                        pickedTime!;
                                                                  });
                                                                },
                                                                child: Text(
                                                                  'Finish',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          15),
                                                                )),
                                                            Text(
                                                                '${MaterialLocalizations.of(context).formatTimeOfDay(end)}',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18))
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                actions: [
                                                  Container(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                ElevatedButton(
                                                          onPressed: () async {
                                                            await store
                                                                .collection(
                                                                    'driver')
                                                                .doc(_auth
                                                                    .currentUser!
                                                                    .uid)
                                                                .update({
                                                              'trip1': {
                                                                'start':
                                                                    "${MaterialLocalizations.of(context).formatTimeOfDay(start)}",
                                                                'end':
                                                                    '${MaterialLocalizations.of(context).formatTimeOfDay(end)}'
                                                              }
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    20),
                                                            child:
                                                                Text("Submit"),
                                                          ),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                                  primary: Colors
                                                                          .blue[
                                                                      900]),
                                                        ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            });
                                          });
                                      setState(() {});
                                    }),
                                GestureDetector(
                                  onTap: () async {
                                    var wait = await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          TimeOfDay start = TimeOfDay.now();
                                          TimeOfDay end = TimeOfDay.now();
                                          return StatefulBuilder(
                                              builder: (context, setState) {
                                            return AlertDialog(
                                              title: Text("Trip 2"),
                                              content: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.8,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.15,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        166,
                                                                        167,
                                                                        168), // background
                                                                onPrimary: Colors
                                                                    .white, // foreground
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                TimeOfDay
                                                                    selectedTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                TimeOfDay?
                                                                    pickedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      selectedTime,
                                                                );
                                                                setState(() {
                                                                  start =
                                                                      pickedTime!;
                                                                });
                                                              },
                                                              child: Text(
                                                                'Start  ',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                          Text(
                                                              '${MaterialLocalizations.of(context).formatTimeOfDay(start)}',
                                                              style: TextStyle(
                                                                  fontSize: 18))
                                                        ],
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                              style:
                                                                  ElevatedButton
                                                                      .styleFrom(
                                                                primary: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        166,
                                                                        167,
                                                                        168), // background
                                                                onPrimary: Colors
                                                                    .white, // foreground
                                                              ),
                                                              onPressed:
                                                                  () async {
                                                                TimeOfDay
                                                                    selectedTime =
                                                                    TimeOfDay
                                                                        .now();
                                                                TimeOfDay?
                                                                    pickedTime =
                                                                    await showTimePicker(
                                                                  context:
                                                                      context,
                                                                  initialTime:
                                                                      selectedTime,
                                                                );
                                                                setState(() {
                                                                  end =
                                                                      pickedTime!;
                                                                });
                                                              },
                                                              child: Text(
                                                                'Finish',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        15),
                                                              )),
                                                          Text(
                                                              '${MaterialLocalizations.of(context).formatTimeOfDay(end)}',
                                                              style: TextStyle(
                                                                  fontSize: 18))
                                                        ],
                                                      )
                                                    ],
                                                  )),
                                              actions: [
                                                Container(
                                                  padding: EdgeInsets.all(10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                          child: ElevatedButton(
                                                        onPressed: () async {
                                                          await store
                                                              .collection(
                                                                  'driver')
                                                              .doc(_auth
                                                                  .currentUser!
                                                                  .uid)
                                                              .update({
                                                            'trip2': {
                                                              'start':
                                                                  "${MaterialLocalizations.of(context).formatTimeOfDay(start)}",
                                                              'end':
                                                                  '${MaterialLocalizations.of(context).formatTimeOfDay(end)}'
                                                            }
                                                          });
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
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
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    width: MediaQuery.of(context).size.width *
                                        0.45,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Color.fromARGB(255, 22, 22, 22)
                                                    .withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(1,
                                                1), // changes position of shadow
                                          ),
                                        ],
                                        color: Colors.blue[900],
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [
                                        Text(
                                          'Trip 2',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Start',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              '${t2['start']}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const Divider(
                                          height: 10,
                                          thickness: 0.6,
                                          indent: 0,
                                          endIndent: 0,
                                          color: Color(0xff4E8CDD),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'End',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              '${t2['end']}',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Icon(
                                              Icons.edit,
                                              size: 15,
                                              color: Color.fromARGB(
                                                  255, 166, 167, 168),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "Edit",
                                              style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 166, 167, 168)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          }),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      FutureBuilder<bool>(
                          future: serviceruning(),
                          builder: (context, data) {
                            if (data.connectionState !=
                                ConnectionState.waiting) {
                              runingservice = data.data!;
                            }
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: ElevatedButton(
                                  onPressed: () => widget.indexhange(1),
                                  child: (!runingservice)
                                      ? Text('Start sharing the location')
                                      : Text('Location Sharing is on'),
                                  style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(20),
                                      primary: (!runingservice)
                                          ? Colors.indigo[900]
                                          : Colors.lightGreen,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)))),
                            );
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Students',
                            style: TextStyle(
                                color: Colors.blue[900],
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Container(
                              child: FutureBuilder<DocumentSnapshot>(
                                  future: store
                                      .collection('location')
                                      .doc(_auth.currentUser!.uid)
                                      .get(),
                                  builder: (context, trip) {
                                    String triptype = "";
                                    if (trip.connectionState !=
                                            ConnectionState.waiting &&
                                        trip.data?.data() != null) {
                                      try {
                                        triptype = trip.data!.get("trip");
                                      } catch (e) {}
                                    }
                                    return StreamBuilder<QuerySnapshot>(
                                        stream: store
                                            .collection('children')
                                            .where('driverid',
                                                isEqualTo:
                                                    _auth.currentUser!.uid)
                                            .snapshots(),
                                        builder: (context, snap) {
                                          if (snap.connectionState !=
                                                  ConnectionState.waiting &&
                                              snap.data?.docs != null) {
                                            students = snap.data!.docs;
                                          }
                                          if (students.length > 0) {
                                            return ListView.builder(
                                                itemCount: students.length,
                                                itemBuilder: (context, index) {
                                                  return Container(
                                                    padding: EdgeInsets.all(8),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.3),
                                                              spreadRadius: 2,
                                                              blurRadius: 5,
                                                              offset: Offset(0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ],
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10)),
                                                      padding: EdgeInsets.all(
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.03),
                                                      child: Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.person,
                                                                size: 18,
                                                                color: Colors
                                                                        .indigo[
                                                                    600],
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Text(
                                                                students[index]
                                                                    .get(
                                                                        'name'),
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              )
                                                            ],
                                                          ),
                                                          const Divider(
                                                            height: 10,
                                                            thickness: 0.6,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    212,
                                                                    211,
                                                                    211),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.school,
                                                                size: 18,
                                                                color: Colors
                                                                        .indigo[
                                                                    600],
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Text(students[
                                                                      index]
                                                                  .get(
                                                                      'school'))
                                                            ],
                                                          ),
                                                          const Divider(
                                                            height: 10,
                                                            thickness: 0.6,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    212,
                                                                    211,
                                                                    211),
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                Icons.home,
                                                                size: 18,
                                                                color: Colors
                                                                        .indigo[
                                                                    600],
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.05,
                                                              ),
                                                              Text(students[
                                                                      index]
                                                                  .get(
                                                                      'address'))
                                                            ],
                                                          ),
                                                          const Divider(
                                                            height: 10,
                                                            thickness: 0.6,
                                                            indent: 0,
                                                            endIndent: 0,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    212,
                                                                    211,
                                                                    211),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              ElevatedButton(
                                                                onPressed:
                                                                    () async {
                                                                  if(runingservice){
                                                                    if (triptype != "2" &&
                                                                        !(students[
                                                                        index]
                                                                            .get(
                                                                            'notifed'))) {
                                                                      await store
                                                                          .collection(
                                                                          'children')
                                                                          .doc(students[index]
                                                                          .id)
                                                                          .update(
                                                                        {
                                                                          'notifications':
                                                                          FieldValue.arrayUnion([
                                                                            {
                                                                              'time':
                                                                              DateFormat('hh:mm').format(DateTime.now()),
                                                                              'type':
                                                                              'Notified',
                                                                            }
                                                                          ]),
                                                                          'notifed':
                                                                          true
                                                                        },
                                                                      );
                                                                    } else {
                                                                      await store
                                                                          .collection(
                                                                          'children')
                                                                          .doc(students[index]
                                                                          .id)
                                                                          .update(
                                                                        {
                                                                          'notifications':
                                                                          FieldValue.arrayUnion([
                                                                            {
                                                                              'time':
                                                                              DateFormat('hh:mm').format(DateTime.now()),
                                                                              'type':
                                                                              'Notified trip2',
                                                                            }
                                                                          ]),
                                                                          't2remainder':
                                                                          true
                                                                        },
                                                                      );
                                                                    }
                                                                  }
                                                                },
                                                                child: (triptype!="2")?((students[
                                                                index]
                                                                    .get(
                                                                    'notifed'))
                                                                    ? Text(
                                                                    'Notified')
                                                                    : Text(
                                                                    'Notify parent')):((students[
                                                                index]
                                                                    .get(
                                                                    't2remainder'))
                                                                    ? Text(
                                                                    'Notified')
                                                                    : Text(
                                                                    'Notify parent')),
                                                                style: ElevatedButton.styleFrom(
                                                                    primary:triptype!="2"?(
                                                                        !students[index].get('notifed') ? Colors.blue[900] : Colors.lightGreen
                                                                    ):(
                                                                        !students[index].get('t2remainder') ? Colors.blue[900] : Colors.lightGreen
                                                                    ),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15))),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.02,
                                                              ),
                                                              (triptype == "1")
                                                                  ? (students[index]
                                                                              .get('picked_up') ==
                                                                          false
                                                                      ? ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (!students[index].get('picked_up') &&
                                                                                runingservice) {
                                                                              await store.collection('children').doc(students[index].id).update({
                                                                                'picked_up': true,
                                                                                'notifications': FieldValue.arrayUnion([
                                                                                  {
                                                                                    'time': DateFormat('hh:mm').format(DateTime.now()),
                                                                                    'type': 'Picked up',
                                                                                  }
                                                                                ])
                                                                              });
                                                                            }
                                                                          },
                                                                          child: (students[index].get('picked_up') == false)
                                                                              ? Text('Arrived')
                                                                              : Text('Picked up'),
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: (students[index].get('picked_up') == false) ? Colors.blue[900] : Colors.lightGreen[700],
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                                        )

                                                                      : ElevatedButton(
                                                                          onPressed:
                                                                              () async {
                                                                            if (!students[index].get('atschool') &&
                                                                                runingservice) {
                                                                              await store.collection('children').doc(students[index].id).update({
                                                                                'atschool': true,
                                                                                'notifications': FieldValue.arrayUnion([
                                                                                  {
                                                                                    'time': DateFormat('hh:mm').format(DateTime.now()),
                                                                                    'type': 'Dropped at school',
                                                                                  }
                                                                                ])
                                                                              });
                                                                            }
                                                                          },
                                                                          child:
                                                                              Text('Dropped at school'),
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: (students[index].get('atschool') == false) ? Colors.blue[900] : Colors.lightGreen[700],
                                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                                        )
                                                                    )
                                                                  : ElevatedButton(
                                                                      onPressed:
                                                                          () async {
                                                                        if (!students[index].get('dropped') &&
                                                                            runingservice) {
                                                                          await store
                                                                              .collection('children')
                                                                              .doc(students[index].id)
                                                                              .update({
                                                                            'dropped':
                                                                                true,
                                                                            'notifications':
                                                                                FieldValue.arrayUnion([
                                                                              {
                                                                                'time': DateFormat('hh:mm').format(DateTime.now()),
                                                                                'type': 'Dropped at home',
                                                                              }
                                                                            ])
                                                                          });
                                                                        }
                                                                      },
                                                                      child: (!students[index].get('dropped'))
                                                                          ? Text(
                                                                              'Child\'s drop')
                                                                          : Text(
                                                                              'Dropped at home'),
                                                                      style: ElevatedButton.styleFrom(
                                                                          primary: (students[index].get('dropped') == false)
                                                                              ? Colors.blue[900]
                                                                              : Colors.lightGreen[700],
                                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                                                                    )
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                });
                                          } else {
                                            return Center(
                                                child: Text(
                                              "No Passengers",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  color: Colors.blue[900]),
                                            ));
                                          }
                                        });
                                  })))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
