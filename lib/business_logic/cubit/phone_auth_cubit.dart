// ignore_for_file: non_constant_identifier_names, unnecessary_this, avoid_print

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'phone_auth/phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String verficationID;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  Future<void> SubmetPhoneNumber(String PhoneNumber) async {
    emit(Loading());

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+2$PhoneNumber',
      timeout: const Duration(seconds: 14),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  void verificationCompleted(PhoneAuthCredential credential) async {
    print('verificationCompleted');
    await Signin(credential);
  }

  void verificationFailed(FirebaseException e) async {
    print('verificationCompleted: ${e.toString()}');

    emit(ErrorOccured(errorMessage: e.toString()));
  }

  void codeSent(String verificationId, int? resendToken) {
    print('codeSent');
    this.verficationID = verificationId;
    emit(PhoneNumberSubmited());
  }

  void codeAutoRetrievalTimeout(String verificationId) {
    print("codeAutoRetrievalTimeout");
  }

  Future<void> SubmitOtp(String OtpCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: this.verficationID, smsCode: OtpCode);
    await Signin(credential);
  }

  Future<void> Signin(PhoneAuthCredential credential) async {
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      emit(PhoneotpVerifyed());
    } catch (e) {
      emit(ErrorOccured(errorMessage: e.toString()));
    }
  }

  Future<void> Logout() async {
    await FirebaseAuth.instance.signOut();
  }

  User getLoggedInUser() {
    User firebaseUser = FirebaseAuth.instance.currentUser!;
    return firebaseUser;
  }
}
