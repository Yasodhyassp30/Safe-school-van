import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class joinrequests extends StatefulWidget {
  const joinrequests({Key? key}) : super(key: key);

  @override
  State<joinrequests> createState() => _requestsState();
}

class _requestsState extends State<joinrequests> {
  FirebaseFirestore store =FirebaseFirestore.instance;
  FirebaseAuth _auth =FirebaseAuth.instance;
  List request =[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(onPressed: (){
                    Navigator.pop(context);
                  }, icon: Icon(Icons.arrow_back)),
                  SizedBox(width: 8,),
                  Text('Requests',style: TextStyle(fontSize: 25,color: Colors.blue[900]),)
                ],
              ),
              SizedBox(height: 10,),
              Expanded(child: Container(
                child: StreamBuilder<DocumentSnapshot>(stream:store.collection('requests').doc(_auth.currentUser!.uid).snapshots(),builder: (context, snapshot) {
                  if(snapshot.data?.data()!=null){
                    request =snapshot.data!.get('requests');
                  }
                  if(request.length>0){
                    return ListView.builder(itemCount:request.length,itemBuilder: (context, index) {
                      return Container(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child:Column(
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.person,size: 30,),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                                  Text('${request[index]['name']}')
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.school,size: 30,),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                                  Text('${request[index]['school']}')
                                ],
                              ),
                              Row(
                                children: [
                                  Icon(Icons.home,size: 30,),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.05,),
                                  Text('address')
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton.icon(onPressed: ()async{
                                    Map data =request[index];
                                    data['status']=false;
                                    await store.collection('children').add(
                                        {
                                          'address':request[index]['address'],
                                          'atschool':false,
                                          'driverid':_auth.currentUser!.uid,
                                          'drivername':_auth.currentUser!.displayName,
                                          'dropped':false,
                                          'name':request[index]['name'],
                                          'notifed':false,
                                          'parentid':request[index]['parentid'],
                                          'picked_up':false,
                                          'school':request[index]['school'],
                                          'started':false,
                                          't2remainder':false,
                                          'notifications':[]
                                        });
                                    request.removeAt(index);
                                    await store.collection('requests').doc(_auth.currentUser!.uid).update(
                                        {
                                          'requests':request
                                        }
                                    );

                                  }, label:Text('Accept'),
                                    icon: Icon(Icons.check),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.blue[900],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15))
                                    ),),
                                  ElevatedButton.icon(onPressed: ()async{
                                    request.removeAt(index);
                                    await store.collection('requests').doc(_auth.currentUser!.uid).update(
                                        {
                                          'requests':request
                                        }
                                    );
                                  }, label:Text('Reject'),
                                    icon: Icon(Icons.clear),
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.red[900],
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15))
                                    ),)
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    });
                  }else{
                    return Center(
                      child: Text('No New Requests',style: TextStyle(color: Colors.blue[900],fontSize: 25),)
                    );
                  }


                })),
              )

            ],
          ),
        ),
      ),
    );
  }
}
