import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:school_van_app/auth/logindriver.dart';
import 'package:school_van_app/auth/loginparent.dart';
import 'package:school_van_app/auth/regdriver.dart';
import 'package:school_van_app/auth/regparent.dart';

class accountselect extends StatelessWidget {
  const accountselect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30)),
                          color: Color(0xff00154D)),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.1,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Lets go...',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Cherry Cream Soda',
                              color: Color.fromARGB(255, 245, 246, 247),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.width * 0.38,
                      left: MediaQuery.of(context).size.width * 0.25,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.width * 0.65,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/schoolvan.png')),
                        ),
                      ),
                    ),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.13,
                      left: MediaQuery.of(context).size.width * 0.05,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: AutoSizeText(
                          'Parent app allows them to track the school bus location and get real-time notifications regarding the students\' location...',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.white,
                          ),
                          maxLines: 6,
                        ),
                      ),
                    ),
                  ],
                ),
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.1,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => logindriver()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.redAccent[300],
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.redAccent[200],
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/schoolvan.png'),
                                      fit: BoxFit.contain)),
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I am a Driver ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(Icons.arrow_forward,
                                      size: 20, color: Colors.black)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.redAccent[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => parentlogin()));
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.blueAccent[300],
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blueAccent[200],
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/parent_auth.png'),
                                      fit: BoxFit.contain)),
                              padding: EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.width * 0.2,
                              width: MediaQuery.of(context).size.width * 0.2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'I am a Parent ',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blueAccent[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
