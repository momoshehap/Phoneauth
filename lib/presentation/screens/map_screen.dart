// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:phoneAuth/business_logic/cubit/phone_auth_cubit.dart';
import 'package:phoneAuth/constans/strings.dart';
import 'package:phoneAuth/presentation/screens/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();

    return Scaffold(
        body: Center(
      child: Column(children: [
        Container(
            padding: EdgeInsets.all(120),
            child: BlocProvider<PhoneAuthCubit>(
              create: (context) => phoneAuthCubit,
              child: ElevatedButton(
                onPressed: () async {
                  await phoneAuthCubit.Logout();
                  Navigator.of(context).pushReplacementNamed(Loginscreen);
                },
                child: Text(
                  'logout',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(110, 50),
                    primary: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
              ),
            ))
      ]),
    ));
  }
}
