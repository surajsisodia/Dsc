import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gur/homeMainInd.dart';
import 'package:gur/homeMainNGO.dart';
import 'package:gur/homeMainOrg.dart';
import 'package:gur/models/currentUser.dart';
import 'package:gur/newAuthScreens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Utils/SizeConfig.dart';
import '../Utils/constants.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'dart:async';

class Otp extends StatefulWidget {
  final String phoneNo;
  final CurrentUser currentUser;
  final String pwd;
  Otp(this.phoneNo, this.currentUser, this.pwd);
  _OtpState createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  String verificationCode = "";
  String uid = "";
  @override
  void initState() {
    super.initState();
    otpVerify();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 414;
    var h = SizeConfig.screenHeight / 896;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: b * 35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    sh(200),
                    Text(
                      'Confirm OTP',
                      style: txtS(mc, 40, FontWeight.w700),
                    ),
                    sh(65),
                    Container(
                      height: 0.5,
                      width: b * 159,
                      color: Color(0xff595959),
                    ),
                    sh(65),
                    Text(
                      'Thanks for signing up! We’ve sent a confirmation OTP over to',
                      textAlign: TextAlign.center,
                      style: txtS(textColor, 18, FontWeight.w400),
                    ),
                    Text(
                      ' your phone number ending with ******' +
                          widget.phoneNo.substring(9),
                      textAlign: TextAlign.center,
                      style: txtS(textColor, 18, FontWeight.w600),
                    ),
                    sh(85),
                    OTPTextField(
                      length: 6,
                      width: MediaQuery.of(context).size.width,
                      textFieldAlignment: MainAxisAlignment.spaceAround,
                      fieldWidth: b * 31,
                      fieldStyle: FieldStyle.underline,
                      style: txtS(textColor, 18, FontWeight.w600),
                      onChanged: (pin) {
                        print("Changed: ");
                      },
                      onCompleted: (pin) {
                        signUpWithEmailAndPhone(pin);
                      },
                    ),
                    sh(50),
                    Container(
                      child: MaterialButton(
                        onPressed: () {},
                        color: mc,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(b * 10),
                        ),
                        elevation: 0,
                        height: h * 65,
                        minWidth: b * 345,
                        child: Text(
                          'Verify & Proceed',
                          style: txtS(Colors.white, 16, FontWeight.w700),
                        ),
                      ),
                    ),
                    sh(40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Didn\'t Receive OTP? ',
                          style: txtS(textColor, 16, FontWeight.w500),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Resend it!',
                            style: txtS(mc, 16, FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    sh(30),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      OtpTimer(),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle txtS(Color col, double siz, FontWeight wg) {
    return TextStyle(
      color: col,
      fontWeight: wg,
      fontSize: SizeConfig.screenWidth * siz / 414,
    );
  }

  SizedBox sh(double h) {
    return SizedBox(height: SizeConfig.screenHeight * h / 896);
  }

  otpVerify() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.verifyPhoneNumber(
        phoneNumber: widget.phoneNo,
        timeout: Duration(seconds: 120),
        verificationCompleted: (PhoneAuthCredential credential) async {
          //signUpWithEmailAndPhone(credential);
        },
        verificationFailed: (FirebaseAuthException exception) {
          print(exception.message);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(exception.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) {
            return Login();
          }), (route) => false);
        },
        codeSent: (String verificationId, int forceResendingToken) async {
          setState(() {
            verificationCode = verificationId;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        });
  }

  signUpWithEmailAndPhone(String pin) async {
    String email = widget.currentUser.email;
    String pwd = widget.pwd;
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: pwd)
          .then((credential) {
        try {
          auth.currentUser
              .linkWithCredential(PhoneAuthProvider.credential(
                  verificationId: verificationCode, smsCode: pin))
              .then((result) {
            if (result.user != null) {
              uid = credential.user.uid;
              addUsertoDB();
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return widget.currentUser.userType == 'ind'
                    ? HomeInd()
                    : widget.currentUser.userType == 'org'
                        ? HomeOrg()
                        : HomeNgo();
              }), (route) => false);
            }
          }).catchError((eror) {
            print(eror);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(eror.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ));
            auth.currentUser.delete();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) {
              return Login();
            }), (route) => false);
          });
        } on FirebaseAuthException catch (error) {
          deleteUser(error.message);
        } catch (er) {
          print(er);
          deleteUser(er);
        }
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ));
    } catch (e) {
      print(e);
    }
  }

  deleteUser(e) {
    FirebaseAuth auth = FirebaseAuth.instance;

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(e),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
    auth.currentUser.delete();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) {
      return Login();
    }), (route) => false);
  }

  addUsertoDB() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String userName = widget.currentUser.name;
    String email = widget.currentUser.email;
    String phone = widget.currentUser.phone;

    Timestamp timestamp = Timestamp.now();

    CurrentUser currentUser = CurrentUser(
        name: userName,
        email: email,
        phone: phone,
        uid: uid,
        userType: widget.currentUser.userType,
        regDate: FieldValue.serverTimestamp());

    Map<String, dynamic> map = currentUser.toMap();

    try {
      firestore.collection('users').doc(uid).set(map).whenComplete(() {
        print("User added to DB");
      });
    } catch (e) {
      print(e);
    }

    preferences.setString('currentUserUID', uid);
    preferences.setString('currentUserName', userName);
    preferences.setString('currentUserEmail', email);
    preferences.setString('currentUserPhone', phone);
    preferences.setString('currentUserPhone', widget.phoneNo);
    preferences.setString('currentUserType', widget.currentUser.userType);
    preferences.setString('currentUserRegDate', timestamp.toDate().toString());
  }
}

class OtpTimer extends StatefulWidget {
  @override
  _OtpTimerState createState() => _OtpTimerState();
}

class _OtpTimerState extends State<OtpTimer> {
  final interval = const Duration(seconds: 1);

  final int timerMaxSeconds = 60;

  int currentSeconds = 0;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) timer.cancel();
      });
    });
  }

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var b = SizeConfig.screenWidth / 414;
    var h = SizeConfig.screenHeight / 896;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          "Send Otp After",
          style: TextStyle(color: textColor, fontWeight: FontWeight.w600),
        ),
        SizedBox(width: b * 10),
        Icon(Icons.timer, color: textColor),
        SizedBox(width: b * 10),
        Text(
          timerText,
          style: TextStyle(color: mc, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
