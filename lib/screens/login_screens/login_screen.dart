import 'package:auto_securo_user/create_user/create_profile.dart';
import 'package:auto_securo_user/main_screens/NavBar.dart';
import 'package:auto_securo_user/main_screens/notification_screen.dart';
import 'package:auto_securo_user/screens/login_screens/otp_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:auto_securo_user/globals.dart' as globals;
import 'package:auto_securo_user/services/database_services.dart';

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
        _login(phoneNumber);
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

  Future<void> _login(String phoneNumber) async {
    try {
      await FirebaseAuth.instance
          .signInWithCredential(globals.phoneAuthCredential)
          .then((UserCredential authRes) async {
        //checks if user exists, if doesnt, creates user collection
        globals.user = authRes.user;
        //displayName only used to check this, baaki koi user info hogi, to wo firestore se hi uthayenge
//        if (globals.user.displayName != null) {
//          Navigator.push(context, PageTransition(child: NavBar(), type: PageTransitionType.fade));
//        } else {
//          Navigator.push(context, PageTransition(child: CreateProfile(), type: PageTransitionType.fade));
//        }
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

    checkNotification();
  }

  Future checkNotification () async{
    // Get any messages which caused the application to open from
    // a terminated state.
    RemoteMessage initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    if(initialMessage!=null)
      {
        // If the message also contains a data property with a "type" of "chat",
        // navigate to a chat screen
        if (initialMessage?.data['type'] == 'vehicle') {
          Navigator.push(context, PageTransition(child: NotificationScreen(), type: PageTransitionType.fade));
        }

        // Also handle any interaction when the app is in the background via a
        // Stream listener
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (initialMessage?.data['type'] == 'vehicle') {
            Navigator.push(context, PageTransition(child: NotificationScreen(), type: PageTransitionType.fade));
          }
        });
      }
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
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
              Spacer(),
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
