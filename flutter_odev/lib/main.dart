import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bases/hive_base.dart';
import 'consts/consts.dart';
import 'pages/home_page.dart';
import 'pages/onboard_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(HiveUserAdapter());
  Box<HiveUser> _localUser = await Hive.openBox<HiveUser>(localDB);
  runApp(
    MyApp(
      localUser: _localUser,
    ),
  );
}

class MyApp extends StatefulWidget {
  final Box localUser;

  const MyApp({Key? key, required this.localUser}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "YBS4001 Ödev",
      debugShowCheckedModeBanner: false,
      home: widget.localUser.values.isEmpty ? OnBoardingPage() : HomePage(),
    );
  }
}
