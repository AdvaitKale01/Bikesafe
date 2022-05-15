import 'package:bikesafe/screens/splash_screen.dart';
import 'package:flutter/material.dart';

// void backgroundFetchHeadlessTask(HeadlessTask task) async {
//   var taskId = task.taskId;
//   if (taskId == 'me.advaitkale.pingBike') {
//     print('me.advaitkale.pingBike');
//     print('[BackgroundFetch] Headless event received.');
//     //TODO: perform tasks like — call api, DB and local notification etc…
//
//   }
// }

void main() {
  runApp(const MyApp());
  // Requires {stopOnTerminate: false, enableHeadless: true}
  // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bikesafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
