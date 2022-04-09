// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:phoneAuth/business_logic/cubit/phone_auth_cubit.dart';
import 'package:phoneAuth/constans/Mycolors.dart';
import 'package:phoneAuth/constans/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  final GlobalKey<FormState> _phoneFormkey = GlobalKey();
  late String phoneNumber;
  Widget _buildintroTexts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'what is your phone number ?',
          style: TextStyle(
              color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 30,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            'please enter your phone number to verify your account.',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.normal),
          ),
        )
      ],
    );
  }

  Widget _buildPhoneFormField() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Mycolors.lightgray),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: Text(
              generateCountryFlag() + '+02',
              style: TextStyle(
                fontSize: 24,
                letterSpacing: 2.0,
              ),
            ),
          ),
          flex: 1,
        ),
        SizedBox(
          width: 16,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Mycolors.blue),
              borderRadius: BorderRadius.all(Radius.circular(6)),
            ),
            child: TextFormField(
              autofocus: true,
              style: TextStyle(fontSize: 18, letterSpacing: 2.0),
              decoration: InputDecoration(border: InputBorder.none),
              cursorColor: Colors.black,
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value!.isEmpty) {
                  return "please enter your phone number";
                } else if (value.length < 11) {
                  return "too shotr for phone number";
                }
                return null;
              },
              onSaved: (value) {
                phoneNumber = value!;
              },
            ),
          ),
          flex: 2,
        )
      ],
    );
  }

  String generateCountryFlag() {
    String countryCode = "eg";
    String flag = countryCode.toUpperCase().replaceAllMapped(RegExp(r'[A-Z]'),
        (match) => String.fromCharCode(match.group(0)!.codeUnitAt(0) + 127397));
    return flag;
  }

  Widget _bulidNextButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton(
        onPressed: () {
          showProgresIndecator(context);
          _register(context);
        },
        child: Text(
          'next',
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

  Widget _buildPhoneNumberSubmitedBloc() {
    return BlocListener<PhoneAuthCubit, PhoneAuthState>(
      listenWhen: (Previous, current) {
        return Previous != current;
      },
      listener: (context, state) {
        if (state is Loading) {
          showProgresIndecator(context);
        }
        if (state is PhoneNumberSubmited) {
          Navigator.pop(context);
          Navigator.of(context).pushNamed(otpscreen, arguments: phoneNumber);
        }

        if (state is ErrorOccured) {
          Navigator.pop(context);
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

  Future<void> _register(BuildContext context) async {
    if (!_phoneFormkey.currentState!.validate()) {
      Navigator.pop(context);
      return;
    } else {
      Navigator.pop(context);
      _phoneFormkey.currentState!.save();
      BlocProvider.of<PhoneAuthCubit>(context).SubmetPhoneNumber(phoneNumber);
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _phoneFormkey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 88),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildintroTexts(),
                  SizedBox(
                    height: 110,
                  ),
                  _buildPhoneFormField(),
                  SizedBox(
                    height: 80,
                  ),
                  _bulidNextButton(context),
                  _buildPhoneNumberSubmitedBloc(),
                ],
              ),
            )),
      ),
    ));
  }
}
