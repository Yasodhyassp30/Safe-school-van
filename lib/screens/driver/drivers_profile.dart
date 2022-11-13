import 'package:flutter/material.dart';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_van_app/auth/logindriver.dart';
import 'package:school_van_app/auth/loginparent.dart';
import 'package:school_van_app/screens/driver/driverhome.dart';

import '../../auth/accountselect.dart';

class Driver_profile extends StatefulWidget {
  const Driver_profile({Key? key}) : super(key: key);

  @override
  State<Driver_profile> createState() => _Driver_profileState();
}

class _Driver_profileState extends State<Driver_profile> {
  final Imagepic = ImagePicker();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String error = "";
  FirebaseFirestore store = FirebaseFirestore.instance;
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  TextEditingController driving = TextEditingController();
  TextEditingController NIC = TextEditingController();
  TextEditingController address = TextEditingController();
  int index = 1;
  File? name;
  bool obsecure = true, loading = false, updated = false;
  var user;

  @override
  Widget build(BuildContext context) {
    String? pic = _auth.currentUser?.photoURL;
    if (index == 1) {
      if (loading) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
        ));
      }
      return FutureBuilder<DocumentSnapshot>(
          future: store.collection("driver").doc(_auth.currentUser!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                snapshot.data!.data() == null) {
              return Scaffold(
                  body: SafeArea(
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ));
            } else {
              user = snapshot.data!.data();
              return Scaffold(
                backgroundColor: Color.fromARGB(245, 249, 249, 249),
                body: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(16),
                                child: Text(
                                  "Profile",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[900]),
                                ),
                              ),
                              Expanded(child: SizedBox()),
                              ElevatedButton(
                                onPressed: () async {
                                  FirebaseAuth _auth = FirebaseAuth.instance;
                                  if (FlutterBackground
                                      .isBackgroundExecutionEnabled) {
                                    await FlutterBackground
                                        .disableBackgroundExecution();
                                  }
                                  var wait = await _auth.signOut();

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              accountselect()),
                                      (route) => false);
                                },
                                child: Text('Sign Out'),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    primary: Color(0xff001B61)),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.amber,
                              foregroundImage: (pic == null)
                                  ? AssetImage('assets/images/avatar.png')
                                  : NetworkImage(pic!) as ImageProvider),
                          SizedBox(
                            height: 10,
                          ),
                          OutlinedButton(
                            onPressed: () async {
                              final picked = await Imagepic.pickImage(
                                  source: ImageSource.camera);
                              name = File(picked!.path);
                              FirebaseStorage? storage =
                                  FirebaseStorage.instance;
                              var stroeref = storage
                                  .ref()
                                  .child("image/${_auth.currentUser!.uid}");
                              setState(() {
                                loading = true;
                              });
                              if (name != null) {
                                var upload = await stroeref.putFile(name!);
                                String? completed =
                                    await upload.ref.getDownloadURL();
                                await _auth.currentUser!
                                    .updatePhotoURL(completed);
                                await store
                                    .collection('driver')
                                    .doc(_auth.currentUser!.uid)
                                    .update({'pic': completed});

                                pic = completed;
                                setState(() {
                                  loading = false;
                                });
                              }
                            },
                            child: Text(
                              'Change Profile photo',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                primary: Color(0xff001B61)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Edit Profile",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(16),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 10,
                                    blurRadius: 10,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Personal Details',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: email,
                                    decoration: InputDecoration(
                                        hintText: user['Email']),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: contact,
                                    decoration: InputDecoration(
                                        hintText: user['Contact_No']),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: address,
                                    decoration: InputDecoration(
                                        hintText: user['address']),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: NIC,
                                    decoration:
                                        InputDecoration(hintText: user['NIC']),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    controller: driving,
                                    decoration: InputDecoration(
                                        hintText: user['license']),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              index = 2;
                                            });
                                          },
                                          child: Text(
                                            'Next',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 166, 167, 168)),
                                          ))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          });
    } else {
      if (loading) {
        return Scaffold(
            body: SafeArea(
          child: Center(
            child: Container(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
        ));
      } else {
        return Scaffold(
          backgroundColor: Color.fromARGB(245, 249, 249, 249),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: password,
                              obscureText: obsecure,
                              decoration: InputDecoration(
                                hintText: 'Old Password',
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obsecure = !obsecure;
                                    });
                                  },
                                  child: Icon((obsecure)
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: confirm,
                              obscureText: obsecure,
                              decoration: InputDecoration(
                                hintText: 'New Password',
                                suffix: InkWell(
                                  onTap: () {
                                    setState(() {
                                      obsecure = !obsecure;
                                    });
                                  },
                                  child: Icon((obsecure)
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        index = 1;
                                      });
                                    },
                                    child: Text(
                                      'Back',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 166, 167, 168)),
                                    )),
                                TextButton(
                                    onPressed: () async {
                                      setState(() {
                                        loading = true;
                                      });
                                      Map<String, dynamic> newdata = new Map();
                                      if (contact.text.trim().isNotEmpty) {
                                        newdata['Contact_No'] =
                                            contact.text.trim();
                                      }
                                      if (driving.text.trim().isNotEmpty) {
                                        newdata['license'] =
                                            driving.text.trim();
                                      }
                                      if (address.text.trim().isNotEmpty) {
                                        newdata['address'] =
                                            address.text.trim();
                                      }
                                      if (NIC.text.trim().isNotEmpty) {
                                        newdata['NIC'] = NIC.text.trim();
                                      }
                                      try {
                                        await store
                                            .collection('driver')
                                            .doc(_auth.currentUser!.uid)
                                            .update(newdata);
                                        if (email.text.trim().isNotEmpty) {
                                          try {
                                            _auth.currentUser!
                                                .updateEmail(email.text.trim());
                                          } catch (e) {
                                            setState(() {
                                              error = 'Invalid Email';
                                            });
                                          }
                                          newdata['email'] = email.text.trim();
                                        }

                                        final cred =
                                            EmailAuthProvider.credential(
                                                email:
                                                    _auth.currentUser!.email!,
                                                password: password.text.trim());
                                        if (confirm.text.trim().isNotEmpty) {
                                          await _auth.currentUser!
                                              .reauthenticateWithCredential(
                                                  cred)
                                              .then((value) async {
                                            try {
                                              await _auth.currentUser!
                                                  .updatePassword(
                                                      confirm.text.trim());
                                              updated = true;
                                            } catch (e) {
                                              setState(() {
                                                error = 'Password invalid';
                                              });
                                            }
                                          });
                                        }
                                        if (confirm.text.trim().isNotEmpty &&
                                            updated) {
                                          await _auth.signOut();
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      logindriver()),
                                              (route) => false);
                                        } else {
                                          Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      driverhome()),
                                              (route) => false);
                                        }
                                      } catch (e) {
                                        setState(() {
                                          error = 'Invalid Details';
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 166, 167, 168)),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }
  }
}
