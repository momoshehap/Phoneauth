// ignore_for_file: prefer_const_constructors

import 'package:phoneAuth/business_logic/cubit/phone_auth_cubit.dart';
import 'package:phoneAuth/presentation/screens/login_screen.dart';
import 'package:phoneAuth/presentation/screens/map_screen.dart';
import 'package:phoneAuth/presentation/screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'constans/strings.dart';

class AppRouter {
  PhoneAuthCubit? phoneAuthCubit;
  AppRouter() {
    phoneAuthCubit = PhoneAuthCubit();
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mapScreen:
        return MaterialPageRoute(
          builder: (_) => MapScreen(),
        );

      case Loginscreen:
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: LoginScreen(),
                ));

      case otpscreen:
        final phoneNumber = settings.arguments;
        return MaterialPageRoute(
            builder: (_) => BlocProvider<PhoneAuthCubit>.value(
                  value: phoneAuthCubit!,
                  child: OtpScreen(phoneNumber: phoneNumber),
                ));
    }
  }
}
