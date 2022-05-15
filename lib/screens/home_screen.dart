// import 'package:dexter/screens/settings_screen.dart';
import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _ip = '192.168.29.181';
  String _status = 'Pinging Bike';

  Color _bellBackgroundColor = Colors.black;
  int pingCount = 0;
  Timer? _timer;
  bool isAlarmOn = false;
  AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
  sendResponse() async {
    try {
      if (_ip != null) {
        var url = 'http://$_ip/ledstate';
        var response = await http.post(Uri.parse(url));
        if (response.statusCode == 200) {
          print('Response status: ${response.statusCode} - Request Sent');
          print('Response body: ${response.body}');
          // setState(() {});
          _status = _status +
              '\n\n' +
              'Bike Pinged. Waiting for response\nResponse status: ${response.statusCode} - Request Received\nBike Secure';
          pingCount++;
          setState(() {});
          //TODO: Add code for nodemcu connected

          return true;
        } else {
          _status = _status +
              '\n\n' +
              'Could not get Response. Possible issues:\n1. NodeMCU Power Down\nSol: Turn on Power of NodeMCU and Press Reset pin\n2. NodeMCU Not connected to WIFI\nSol: Re-start NodeMCU and press Hard Reset pin\n3. IP Address of NodeMCU is changed\nSol: Change the IP Address and add correct IP for NodeMCU';
          _bellBackgroundColor = Colors.red;
          _timer!.cancel();
          isAlarmOn = true;
          if (isAlarmOn) {
            audioPlayer.open(Audio('assets/alarm.mp3'), showNotification: true);
          } else {}
          setState(() {});
          return false;
        }
      } else {
        _status = _status + '\n\n' + 'IP Address is Empty!';
        //TODO: Add code for nodemcu disconnected
        _bellBackgroundColor = Colors.red;
        _timer!.cancel();
        isAlarmOn = true;
        if (isAlarmOn) {
          audioPlayer.open(Audio('assets/alarm.mp3'), showNotification: true);
        } else {}
        setState(() {});
        return false;
      }
    } catch (err) {
      _status = _status + '\n\n' + 'Could not get Response.\nDetails-\n$err';
      //TODO: Add code if nodemcu disconnected
      _bellBackgroundColor = Colors.red;
      _timer!.cancel();
      isAlarmOn = true;
      if (isAlarmOn) {
        audioPlayer.open(Audio('assets/alarm.mp3'), showNotification: true);
      } else {}
      setState(() {});
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // initPlatformState();
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await sendResponse();
    });
    _timer!.tick;
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bellBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      '$pingCount successful pings',
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Time ${DateTime.now()}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                padding: const EdgeInsets.only(left: 10.0),
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Colors.blueAccent),
                    right: BorderSide(color: Colors.blueAccent),
                    left: BorderSide(color: Colors.blueAccent),
                    bottom: BorderSide(color: Colors.blueAccent),
                  ),
                  borderRadius: BorderRadius.circular(33),
                ),
                child: ListView(
                  reverse: true,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        _status,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            isAlarmOn
                ? TextButton(
                    onPressed: () {
                      audioPlayer.stop();
                    },
                    child: const Text(
                      'Stop Alarm',
                      style: TextStyle(fontSize: 14.0),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
