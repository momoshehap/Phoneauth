// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, prefer_typing_uninitialized_variables, must_be_immutable

import 'package:phoneAuth/business_logic/cubit/phone_auth_cubit.dart';
import 'package:phoneAuth/constans/strings.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final phoneNumber;

  OtpScreen({Key? key, required this.phoneNumber}) : super(key: key);
  late String Otpcode;

  Widget _buildintroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'verify your phone number ',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: RichText(
            text: TextSpan(
                text: "Enter your 6 digit code numbers sent to ",
                style:
                    TextStyle(color: Colors.black, fontSize: 18, height: 1.5),
                children: <TextSpan>[
                  TextSpan(
                      text: '$phoneNumber',
                      style: TextStyle(color: Colors.blue))
                ]),
          ),
        )
      ],
    );
  }

  Widget _buildPinCodeFields(BuildContext context) {
    return Container(
      child: PinCodeTextField(
        appContext: context,
        autoFocus: true,
        keyboardType: TextInputType.number,
        length: 6,
        obscureText: false,
        animationType: AnimationType.fade,
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(5),
          fieldHeight: 50,
          fieldWidth: 40,
          inactiveFillColor: Colors.white,
          activeFillColor: Colors.white,
        ),
        animationDuration: Duration(milliseconds: 300),
        backgroundColor: Colors.grey.shade50,
        enableActiveFill: true,
        onCompleted: (submitedcode) {
          Otpcode = submitedcode;
          print("Completed");
        },
        onChanged: (value) {
          print(value);
        },
      ),
    );
  }

  void _login(context) {
    BlocProvider.of<PhoneAuthCubit>(context).SubmitOtp(Otpcode);
  }

  Widget _buildVerifyButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgresIndecator(context);
          _login(context);
        },
        child: Text(
          'verify',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
            minimumSize: Size(110, 50),
            primary: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
      ),
    );
  }

  void showProgresIndecator(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
        ),
      ),
    );

    showDialog(
        barrierColor: Colors.white.withOpacity(0),
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }

  Widget _buildphoneVerificationBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (Previous, current) {
        return Previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgresIndecator(context);
        }
        if (state is PhoneotpVerifyed) {
          Navigator.pop(context);
          Navigator.of(context)
              .pushReplacementNamed(mapScreen, arguments: phoneNumber);
        }

        if (state is ErrorOccured) {
          // Navigator.pop(context);
          String errorMsg = (state).errorMessage;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.black,
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: Container(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
          child: Column(
            children: [
              _buildintroTexts(),
              SizedBox(
                height: 88,
              ),
              _buildPinCodeFields(context),
              SizedBox(
                height: 88,
              ),
              _buildVerifyButton(context),
              _buildphoneVerificationBloc(),
            ],
          ),
        ),
      ),
    );
  }
}
