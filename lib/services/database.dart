import 'package:cloud_firestore/cloud_firestore.dart';

class databaseService{
  final String ?uid;

  databaseService({this.uid});

  final CollectionReference parent = FirebaseFirestore.instance.collection('parent');
  final CollectionReference driver = FirebaseFirestore.instance.collection('driver');


  Future ? setdriverdata(String ? name, String ?Phoneno, String ?email,String ?  license,String ? NIC,String address) async {
    return await driver.doc(uid).set(
        {
          'uid':uid,
          'name': name,
          'Contact_No': Phoneno,
          'Email': email,
          "address":address,
          'NIC':NIC,
          'license':license,
          'trip1':{'start':'-','end':'-'},
          'trip2':{'start':'-','end':'-'}

        }
    );
  }
  Future ? setparentdata(String ? name, String ?Phoneno, String ?email,String address) async {
    return await parent.doc(uid).set(
        {
          'uid':uid,
          'name': name,
          'Contact_No': Phoneno,
          'Email': email,
          "address":address,

        }
    );
  }

}