import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_van_app/loadingscreen.dart';
import 'package:school_van_app/screens/driver/driverhome.dart';
import 'package:school_van_app/wrappers/parentlocationwrapper.dart';

import '../models/user_model.dart';

class authwrapper extends StatefulWidget {
  const authwrapper({Key? key}) : super(key: key);

  @override
  _authwrapperState createState() => _authwrapperState();
}

class _authwrapperState extends State<authwrapper> {
  FirebaseAuth _auth =FirebaseAuth.instance;
  FirebaseFirestore store =FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);


    return FutureBuilder<DocumentSnapshot>(future:store.collection('parent').doc(_auth.currentUser!.uid).get(),builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return loadfadingcube();
        }else if(snapshot.data?.data()==null){
          return driverhome();
        }else{
          Map data =snapshot.data!.data() as Map;
          return parentwrapper(data: data,);
        }
    });
  }
}
