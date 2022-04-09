import 'package:phoneAuth/constans/strings.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'app_router.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

late String initialRoute;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAuth.instance.authStateChanges().listen((User) {
    if (User == null) {
      initialRoute = Loginscreen;
    } else {
      initialRoute = mapScreen;
    }
  });
  runApp(MyApp(
    approuter: AppRouter(),
  ));
}

class MyApp extends StatelessWidget {
  final AppRouter approuter;
  const MyApp({Key? key, required this.approuter}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PhoneAuth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: approuter.generateRoute,
      initialRoute: initialRoute,
    );
  }
}
