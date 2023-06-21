import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:timezone/data/latest.dart' as tz;

import 'package:task_managementapp/screens/auth_screens.dart';
import 'package:task_managementapp/screens/home_screen.dart';
import 'package:task_managementapp/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  NotifyHelper().initializeNotifications();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: StreamBuilder(
          builder: (ctx, usersnapshots) {
            if (usersnapshots.hasData) {
              return const HomePage();
            }
            return const AuthScreen();
          },
          stream: FirebaseAuth.instance.authStateChanges()),
      debugShowCheckedModeBanner: false,
    );
  }
}
