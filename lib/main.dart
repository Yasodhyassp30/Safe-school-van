import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:provider/provider.dart';
import 'package:school_van_app/screens/splash_screen.dart';
import 'package:school_van_app/services/authentication.dart';
import 'package:school_van_app/wrappers/authwrapper.dart';
import 'package:school_van_app/wrappers/splashwrapper.dart';

import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamProvider<myUser?>.value(
      value: authService().user,
      catchError: (_, __) {},
      initialData: null,
      child:
          MaterialApp(debugShowCheckedModeBanner: false, home: splashwrapper()),
    );
  }
}
