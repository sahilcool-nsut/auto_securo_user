import 'package:auto_securo_user/create_user/create_profile.dart';
import 'package:auto_securo_user/main_screens/NavBar.dart';
import 'package:auto_securo_user/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:auto_securo_user/globals.dart' as globals;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_securo_user/screens/login_screens/login_screen.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNo;
  final String verificationId;
  final int code;
  OTPScreen(this.phoneNo, this.verificationId, this.code);
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool loading = false;
  bool _enableButton;
  TextEditingController _controller;
  bool _timer;

  void _submitOTP(String smsCode) {
    globals.phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId, smsCode: smsCode);
    _login();
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(globals.phoneAuthCredential)
          .then((UserCredential authRes) async{

        globals.user = authRes.user;
        globals.phoneNumber = widget.phoneNo;
        await DatabaseService().checkUserCollectionExists();
        setState(() {
          loading = false;
        });
        if (globals.user != null) {
          print("user there");
        } else {
          print("user null");
        }
        if (globals.user.displayName != null) {
           Navigator.pushAndRemoveUntil(context, PageTransition(child:NavBar(),type: PageTransitionType.fade),(route)=>false);
        } else {
          Navigator.pushAndRemoveUntil(context, PageTransition(child:CreateProfile(phoneNumber: widget.phoneNo,),type: PageTransitionType.fade),(route)=>false);
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      print("error: " + e.toString());
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController();
    _enableButton = false;
    _timer = true;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void handleTap() {
    if (_controller.text.length == 6) {
      setState(() {
        _enableButton = true;
      });
    } else {
      setState(() {
        _enableButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Text(
                'OTP-Verification',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Text(
                    'Enter the OTP sent on +91-${widget.phoneNo}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.edit,
                      size: 16,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 40,
              ),
              PinCodeTextField(
                keyboardType: TextInputType.number,
                controller: _controller,
                appContext: context,
                cursorColor: Colors.black38,
                length: 6,
                onChanged: (String value) {
                  handleTap();
                },
                pinTheme: PinTheme(
                  selectedColor: Color(0xFFC1F1DF),
                  inactiveColor: Colors.grey,
                  activeColor: Colors.red,
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              _timer
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Resend OTP in ',
                          style: TextStyle(fontSize: 16),
                        ),
                        TweenAnimationBuilder(
                          tween: Tween(begin: 30.0, end: 0.0),
                          duration: Duration(seconds: 30),
                          builder: (context, value, child) => Text(
                            '${value.toInt()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          onEnd: () {
                            setState(() {
                              _timer = false;
                            });
                          },
                        )
                      ],
                    )
                  : Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Resend OTP',
                          style: TextStyle(fontSize: 16, color: Colors.red),
                        ),
                      ),
                    ),
              Flexible(
                child: Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("images/captchaPNG.png"),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _enableButton != true
                    ? null
                    : () {
                        setState(() {
                          loading = true;
                        });
                        _submitOTP(_controller.text);

                        print(_controller.text);
                      },
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: loading
                      ? Center(
                          child: Transform.scale(
                            scale: 0.6,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 0,
                            ),
                            Text('Verify',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 19)),
                            Icon(
                              Icons.arrow_right_alt,
                              color: Colors.white,
                            ),
                          ],
                        ),
                  decoration: BoxDecoration(
                      color: _enableButton != true
                          ? Color(0xFFBEBABF)
                          : Colors.red,
                      borderRadius: BorderRadius.circular(7)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
