import 'dart:io';

import 'package:auto_securo_user/main_screens/NavBar.dart';
import 'package:auto_securo_user/services/database_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:auto_securo_user/globals.dart' as globals;

import '../globals.dart';

class CreateProfile extends StatefulWidget {
  String phoneNumber;

  CreateProfile({this.phoneNumber});
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  String _phoneNumber;
  String _profileURL;
  TextEditingController _nameController;
  TextEditingController _houseController;
  bool _loading = false;
  bool _enableButton = true;

  @override
  void initState() {
    _phoneNumber = widget.phoneNumber;
    _nameController = new TextEditingController();
    _houseController = new TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _houseController.dispose();
  }

  Future<void> updateProfile() async{
    await DatabaseService().updateProfile(_nameController.text,_houseController.text);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar,
        body: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Profile image UI
                    Column(
                      children: [
                        Container(
                          height: 200.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 3.0),
                                child: Stack(fit: StackFit.loose, children: <
                                    Widget>[
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(flex: 1, child: SizedBox()),
                                      _profileURL == null
                                          ? Expanded(
                                              child: Container(
                                                  width: 140.0,
                                                  height: 140.0,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                        image: ExactAssetImage(
                                                            'images/person.png'),
                                                        fit: BoxFit.cover,
                                                      ))),
                                            )
                                          : Expanded(
                                              child: CachedNetworkImage(
                                                imageUrl: _profileURL,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 140,
                                                  width: 140,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircularProgressIndicator(),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                              ),
                                            ),
                                      Expanded(flex: 1, child: SizedBox()),
                                    ],
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(
                                        top: 90.0,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 3,
                                            child: SizedBox(),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 25.0,
                                              child: InkWell(
                                                onTap: () async {
                                                  final pickedFile =
                                                      await ImagePicker()
                                                          .getImage(
                                                              source:
                                                                  ImageSource
                                                                      .gallery,
                                                              imageQuality: 65);
                                                  if (pickedFile != null) {
                                                    File image =
                                                        File(pickedFile.path);
                                                    //have to implement
//                                                profileURL =
//                                                    await uploadFile(image);
                                                    setState(() {});
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.camera_alt,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(child: SizedBox()),
                                          Expanded(
                                            flex: 1,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.red,
                                              radius: 25.0,
                                              child: InkWell(
                                                onTap: () async {
                                                  // for dialog
                                                  // _showMyDialog();
                                                },
                                                child: Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: SizedBox(),
                                          ),
                                        ],
                                      )),
                                ]),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (val) {
                            // handleTap();
                          },
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              labelText: 'Name',
                              hintText: 'Enter your Name'),
                          controller: _nameController,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (val) {
                            // handleTap();
                          },
                          decoration: InputDecoration(
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
                              border: OutlineInputBorder(),
                              labelText: 'House Number',
                              hintText: 'Enter your house number'),
                          controller: _houseController,
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        TextFormField(
                          onChanged: (val) {
                            // handleTap();
                          },
                          initialValue: _phoneNumber,
                          enabled: false,
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _enableButton != true
                          ? null
                          : () async {
                              setState(() {
                                _loading = true;
                              });
                              //update profile in firebase
                              await updateProfile();
                              //then navigate
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: NavBar()));
                            },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        child: _loading
                            ? Center(
                                child: Transform.scale(
                                  scale: 0.6,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: 0,
                                  ),
                                  Text('Create Profile',
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
                )),
          ],
        ),
      ),
    );
  }

  Future<String> uploadFile(File file) async {
    var user = FirebaseAuth.instance.currentUser;
    var storageRef = FirebaseStorage.instance
        .ref()
        .child("${user.email}/profilepic/profilepic");
    var uploadTask = await storageRef.putFile(file).whenComplete(() async {
      print(storageRef.getDownloadURL());
    });
    return await storageRef.getDownloadURL();
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete profile pic'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Are you sure you want to delete your profile picture. This is not revertible'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                await deleteFromFirebase(context);
                Navigator.of(context).pop();
                setState(() {});
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteFromFirebase(var context) async {
    print("inside deleting");
    var user = FirebaseAuth.instance.currentUser;
    var storageRef = FirebaseStorage.instance
        .ref()
        .child("${user.email}/profilepic/profilepic");

    try {
      await storageRef.delete();
      _profileURL = null;
    } catch (e) {
      print(e);
      final snackBar = SnackBar(content: Text('Some error occurred!'));
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }
}
