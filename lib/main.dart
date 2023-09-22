import 'dart:ffi';

import 'package:diary/calendar.dart';
import 'package:diary/diary.dart';
import 'package:flutter/material.dart';
import 'entries.dart';
import 'package:flutter/services.dart';

enum enumState { entries, diary, calender }

enumState appState = enumState.entries;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock the screen orientation to landscape
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    initialRoute: 'CheckConnectionPage()',
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: ownAppBar(), body: currentState());
  }

  ownAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      toolbarHeight: 90,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  decoration: BoxDecoration(
                      color: appState == enumState.entries
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: const BorderRadius.horizontal(
                          left: Radius.circular(5))),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        appState = enumState.entries;
                      });
                    },
                    child: Text(
                      'Entries',
                      style: TextStyle(
                          letterSpacing: 3,
                          color: appState == enumState.entries
                              ? Colors.white
                              : Colors.blue),
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: appState == enumState.calender
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(0)),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        appState = enumState.calender;
                      });
                    },
                    child: Text(
                      'Calendar',
                      style: TextStyle(
                        letterSpacing: 3,
                        color: appState == enumState.calender
                            ? Colors.white
                            : Colors.blue,
                      ),
                    ),
                  )),
              Container(
                  decoration: BoxDecoration(
                      color: appState == enumState.diary
                          ? Colors.blue
                          : Colors.white,
                      border: Border.all(color: Colors.blue, width: 2.0),
                      borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(5))),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        appState = enumState.diary;
                      });
                    },
                    child: Text(
                      'Diary',
                      style: TextStyle(
                        letterSpacing: 3,
                        color: appState == enumState.diary
                            ? Colors.white
                            : Colors.blue,
                      ),
                    ),
                  )),
            ],
          ),
          const Text(
            'Diary',
            style: TextStyle(color: Colors.blue),
          )
        ],
      ),
    );
  }

  currentState() {
    if (appState == enumState.entries) {
      return const Entries();
    } else if (appState == enumState.diary) {
      return const Diary();
    } else {
      return const Calendar();
    }
  }
}
