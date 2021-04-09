import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../globals.dart';
import 'NavBar.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {

  bool _loading = false;
  bool _noVehicleExists = false;
  bool _showError = false;
  bool _showConfirmation = false;
  TextEditingController _numberPlateController;
  @override
  void initState() {
    _numberPlateController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar,
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:50),
                Text("Request for Acesss",style: TextStyle(fontSize:17,fontWeight: FontWeight.bold),),
                SizedBox(height:40),
                Text("Vehicle Number: ",style: TextStyle(fontSize:16,fontWeight: FontWeight.w300),),
                SizedBox(height:20),
                TextFormField(

                  decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(),
                      labelText: 'Number Plate',

                      hintStyle: TextStyle(color:Colors.black.withOpacity(0.2)),
                  ),
                  controller: _numberPlateController,
                ),
                SizedBox(height:30),

                Visibility(
                  visible: _showError,
                    child: Text("No Vehicle Found!",style: TextStyle(color: Colors.red.shade400),),
                ),
                Visibility(
                  visible: _showConfirmation,
                  child: Text("Request Sent!",style: TextStyle(color: Colors.green),),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _loading = true;
                    });
                    if(_noVehicleExists)
                      {
                        setState(() {
                          _loading = false;
                          _showError = true;
                        });
                      }
                    else
                      {
                        // Send Request
                        setState(() {
                          _loading = false;
                          _showConfirmation = true;
                        });

                      }

                  },
                  child: Container(
                    margin: EdgeInsets.all(32),
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
                        Text('Request Access',
                            style: TextStyle(
                                color: Colors.white, fontSize: 18)),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    decoration: BoxDecoration(
                        color:  Colors.red,
                        borderRadius: BorderRadius.circular(7)),
                  ),
                ),
                Container(
                  child: Center(
                    child: Image(
                      image: AssetImage("images/requestPNG.png"),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: double.infinity,
                    ),
                  ),
                ),

              ],
            ),
          )
        ),
      ),
    );
  }
}
