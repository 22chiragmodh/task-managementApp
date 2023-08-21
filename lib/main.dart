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

// import 'package:flutter/material.dart';
// import 'package:task_managementapp/services/schedulenoti.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   NotificationService().initNotification();
//   tz.initializeTimeZones();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: const MyHomePage());
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [DatePickerTxt(), ScheduleBtn()],
//         ),
//       ),
//     );
//   }
// }

// DateTime scheduleTime = DateTime.now();

// class DatePickerTxt extends StatefulWidget {
//   const DatePickerTxt({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<DatePickerTxt> createState() => _DatePickerTxtState();
// }

// class _DatePickerTxtState extends State<DatePickerTxt> {
//   @override
//   Widget build(BuildContext context) {
//     return TextButton(
//       onPressed: () {
//         DatePicker.showDateTimePicker(
//           context,
//           showTitleActions: true,
//           onChanged: (date) => scheduleTime = date,
//           onConfirm: (date) {},
//         );
//       },
//       child: const Text(
//         'Select Date Time',
//         style: TextStyle(color: Colors.blue),
//       ),
//     );
//   }
// }

// class ScheduleBtn extends StatelessWidget {
//   const ScheduleBtn({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       child: const Text('Schedule notifications'),
//       onPressed: () {
//         debugPrint('Notification Scheduled for $scheduleTime');
//         print("$scheduleTime");
//         NotificationService().scheduleNotification(
//             title: 'Scheduled Notification',
//             body: '$scheduleTime',
//             scheduledNotificationDateTime: scheduleTime);
//       },
//     );
//   }
// }
