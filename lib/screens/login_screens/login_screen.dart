import 'package:auto_securo_user/screens/login_screens/otp_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_securo_user/globals.dart' as globals;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool _enableButton;
  TextEditingController _controller;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _submitPhoneNumber(String phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91" + phoneNumber,
      timeout: Duration(milliseconds: 60000),
      verificationCompleted: (AuthCredential phoneAuthCredential) async {
        print('phone number verified via device');
        globals.phoneAuthCredential = phoneAuthCredential;
        _login();
      },
      codeSent: (String verificationId, [int code]) {
        setState(() {
          loading = false;
        });
        print('code sent');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                OTPScreen(phoneNumber, verificationId, code)));
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('code auto retrieval timeout');
      },
      verificationFailed: (FirebaseAuthException error) {
        print(error);
        setState(() {
          loading = false;
        });
      },
    );
  }

  Future<void> _login() async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(globals.phoneAuthCredential)
          .then((UserCredential authRes) {
        globals.user = authRes.user;
        if (globals.user.displayName != null) {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => Navbar()));
        } else {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => UsernameScreen()));
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
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void handleTap() {
    if (_controller.text.length != 0) {
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: Text(
                  'Hello,',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                child: Text(
                  "Please enter your phone number to access the User Portal",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  handleTap();
                },
                decoration: InputDecoration(
                  prefix: Text('+91 '),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  border: OutlineInputBorder(),
                  labelText: 'Mobile Number',
                ),
                maxLength: 10,
                controller: _controller,
              ),
              Flexible(
                child: Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("images/loginPNG.png"),
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              GestureDetector(
                onTap: _enableButton != true
                    ? null
                    : () {
                        _submitPhoneNumber(_controller.text);
                        setState(() {
                          loading = true;
                        });
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
