import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:school_van_app/auth/accountselect.dart';
import 'package:school_van_app/auth/regdriver.dart';
import 'package:school_van_app/loadingscreen.dart';
import 'package:school_van_app/services/authentication.dart';

import '../screens/driver/driverhome.dart';
import '../locationservice/mapservice.dart';

class logindriver extends StatefulWidget {
  const logindriver({Key? key}) : super(key: key);

  @override
  State<logindriver> createState() => _logindriverState();
}

class _logindriverState extends State<logindriver> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obsecure = true;
  bool loading = false;
  String error = "";
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return loadfadingcube();
    } else {
      return Scaffold(
        body: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
            minWidth: MediaQuery.of(context).size.width,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Text(
                              'Login',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image(
                            image:
                                AssetImage('assets/images/driver_auth_img.png'),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        error,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      TextField(
                        controller: email,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            contentPadding: EdgeInsets.all(15),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "email",
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 15.0)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                          controller: password,
                          obscureText: obsecure,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              contentPadding: EdgeInsets.all(15),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Password",
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 15.0),
                              suffix: InkWell(
                                onTap: () {
                                  setState(() {
                                    obsecure = !obsecure;
                                  });
                                },
                                child: Icon(
                                  (obsecure)
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                ),
                              ))),
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ElevatedButton(
                          onPressed: () async {
                            dynamic result;
                            authService login = authService();
                            if (email.text.trim() != "" &&
                                password.text.trim() != "") {
                              setState(() {
                                loading = true;
                              });
                              result = await login.Signin_with_email(
                                  email.text.trim(), password.text.trim());
                            } else {
                              setState(() {
                                error = "Fill all fields";
                              });
                            }
                            if (result != null) {
                                  FirebaseFirestore store = FirebaseFirestore
                                      .instance;
                                  DocumentSnapshot details = await store.collection(
                                  'driver').doc(result.uid).get();

                                  if (details.data() != null) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            driverhome(),
                                      ),
                                          (route) => false,
                                    );
                                  }else{
                                   setState((){
                                     error="Login Failed";
                                     loading=false;
                                     FirebaseAuth _auth =FirebaseAuth.instance;
                                     _auth.signOut();
                                   });
                                  }
                              setState(() {
                                loading = false;
                              });
                            }else{
                              setState(() {
                                error = "Log in Failed";
                                loading = false;
                              });
                            }
                          },
                          child: Text('Log in'),
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(16),
                              primary: Colors.indigo[900],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "I don't have an account",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => regdriver()));
                              },
                              child: Text(
                                "Sign Up",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 18),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
