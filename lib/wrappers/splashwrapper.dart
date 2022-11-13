import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_van_app/auth/logindriver.dart';
import 'package:school_van_app/screens/driver/driverhome.dart';
import 'package:school_van_app/wrappers/authwrapper.dart';

import '../models/user_model.dart';
import '../screens/splash_screen.dart';

class splashwrapper extends StatelessWidget {
  const splashwrapper({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    final currentuser = Provider.of<myUser?>(context);

    if (currentuser == null) {
      return SplashScreen();
    } else {
      return authwrapper();
    }
  }
}

