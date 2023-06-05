
import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:sizer/sizer.dart';
import 'package:untitled/Myotpscreen.dart';
import 'package:untitled/fetchvideo_screen.dart';
import 'package:untitled/phnonelogin.dart';


Future<void> main() async {
  // Ensure that Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, deviceType){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
              home:Mylogin()
          );
        }

    );
  }
}
