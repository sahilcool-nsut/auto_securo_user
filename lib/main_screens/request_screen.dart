import 'package:auto_securo_user/services/database_services.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'package:auto_securo_user/globals.dart' as globals;
import 'NavBar.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {

  bool _loading = false;
  bool _vehicleExists = true;
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
        appBar: globals.myAppBar,
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
                    child: Text("No Vehicle Found or Vehicle already Linked!",style: TextStyle(color: Colors.red.shade400),),
                ),
                Visibility(
                  visible: _showConfirmation,
                  child: Text("Request Sent!",style: TextStyle(color: Colors.green),),
                ),
                GestureDetector(
                  onTap: () async {
                    setState(() {
                      _loading = true;
                    });
                    _vehicleExists = await DatabaseService().checkVehicleExists(_numberPlateController.text);

                    if(!_vehicleExists)
                      {
                        setState(() {
                          _loading = false;
                          _showError = true;
                          _showConfirmation = false;
                        });
                      }
                    else
                      {
                        // Send Request
                        bool success = await DatabaseService().sendRequest(_numberPlateController.text,globals.phoneNumber);
                        if(success)
                          {
                            setState(() {
                              _showError = false;
                              _loading = false;
                              _showConfirmation = true;
                            });
                          }
                        else
                          {
                            _loading = false;
                            _showError = true;
                            _showConfirmation = false;
                          }
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
