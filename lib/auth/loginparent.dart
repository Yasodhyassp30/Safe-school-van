import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_van_app/auth/regparent.dart';
import 'package:school_van_app/loadingscreen.dart';
import 'package:school_van_app/screens/driver/driverhome.dart';
import 'package:school_van_app/screens/parents/parents_home.dart';
import 'package:school_van_app/wrappers/authwrapper.dart';
import 'package:school_van_app/wrappers/parentlocationwrapper.dart';

import '../locationservice/mapservice.dart';
import '../services/authentication.dart';

class parentlogin extends StatefulWidget {
  const parentlogin({Key? key}) : super(key: key);

  @override
  State<parentlogin> createState() => _parentloginState();
}

class _parentloginState extends State<parentlogin> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool obsecure = true;
  String error = "";
  bool loading = false;
  Map data={};
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
                              'Parent',
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
                            image: AssetImage('assets/images/parent_auth.png'),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      Text(error,style: TextStyle(color: Colors.redAccent),),
                      SizedBox(
                        height: 10,
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
                              if (result != null) {
                                FirebaseFirestore store = FirebaseFirestore
                                    .instance;
                                DocumentSnapshot details = await store.collection(
                                    'parent').doc(result.uid).get();

                                if (details.data() != null) {
                                  data =details.data() as Map;
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          parentwrapper(data: data,),
                                    ),
                                        (route) => false,
                                  );
                                }else{
                                  setState((){
                                    loading=false;
                                    error="Login failed";
                                  });
                                }
                              }else{
                                setState((){
                                  error ="Login failed";
                                  loading =false;
                                });
                              }
                            } else {
                              setState(() {
                                error = "Fill all fields";
                              });
                            }
                            setState(() {
                              loading = false;
                            });

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
                            "Don't have an account",
                            style: TextStyle(fontSize: 18),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>regparent()));
                              },
                              child: Text(
                                "Sign up",
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
