import 'package:auto_securo_user/services/database_services.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';

import 'package:auto_securo_user/globals.dart' as globals;



class RequestNotificationScreen extends StatefulWidget {
  @override
  _RequestNotificationScreenState createState() => _RequestNotificationScreenState();
}

class _RequestNotificationScreenState extends State<RequestNotificationScreen> {

  bool _noNotifications=true;
  bool _dataLoaded = false;
  //Json.decode karke nikallenge list from firebase, store bhi as json hi karenge(from admin app)
 // List notificationData=[{'vehicle':'Lamborghini','numberPlate':'DL4CAC0001','time':formatDate(DateTime.now(), [HH, ':', nn,])},{'vehicle':'Lamborghini','numberPlate':'DL4CAC0001','time':formatDate(DateTime.now(), [HH, ':', nn,])}];

  List<Map<dynamic,dynamic>> requestData=[];
  @override
  void initState() {

    getRequestData();
    super.initState();
  }

  void getRequestData()async{
    requestData = await DatabaseService().getRequests(globals.phoneNumber);
    if(requestData.length==0)
      {
        setState(() {
          _dataLoaded = true;
          _noNotifications = true;
        });

      }
    else
      {
        setState(() {
          _dataLoaded = true;
          _noNotifications = false;
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: globals.myAppBar,
        body: Padding(
          padding:EdgeInsets.all(16),
          child: !_dataLoaded?Center(child: Container(height:30,width:30,child: CircularProgressIndicator()))
              :_noNotifications?
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No Notifications"),
              Container(
                child: Center(
                  child: Image(
                    image: AssetImage("images/noNotificationsPNG.png"),
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: double.infinity,
                  ),
                ),
              ),
            ],
          )
              : ListView.builder(
              scrollDirection: Axis.vertical,

              physics: AlwaysScrollableScrollPhysics(),
              itemCount: requestData.length,
              itemBuilder: (context, index) {

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex:4,
                          child: Image(
                            height: 50,
                            width: 50,
                            image: AssetImage(
                              "images/notificationPNG.png",
                            ),
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child: Container(),
                        ),
                        Expanded(
                          flex:16,
                          child:Container(
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
                                text: 'Request from  ',
                                children: <TextSpan>[
                                  TextSpan(text:requestData[index]["requestFromName"], style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text:", contact number:  "),
                                  TextSpan(text:requestData[index]["requestFrom"], style: TextStyle(fontWeight: FontWeight.bold)),
                                  TextSpan(text:" for vehicle "),
                                  TextSpan(text:requestData[index]["numberPlate"], style: TextStyle(fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                        height:10
                    ),
                    Row(

                      children: [
                        Expanded(
                          flex:1,
                          child: InkWell(
                            onTap:() async{
                              //Accept
                                bool success =   await DatabaseService().acceptRequest(requestData[index]["numberPlate"],requestData[index]["requestFrom"],requestData[index]["requestID"]);
                                if(success)
                                  {
                                    requestData.removeAt(index);
                                    if(requestData.length==0)
                                    {
                                      _noNotifications=true;
                                    }
                                    setState(() {

                                    });
                                  }
                                else
                                  {
                                    //
                                  }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                color: Colors.transparent,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: FittedBox(fit:BoxFit.scaleDown,child: Text("Accept",textAlign: TextAlign.center,)),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:1,
                          child:Container(),
                        ),
                        Expanded(
                          flex:1,
                          child: InkWell(
                            onTap:() async{
                            //Reject
                              bool success = await DatabaseService().deleteRequest(requestData[index]["requestID"]);
                              if(success)
                              {
                                requestData.removeAt(index);
                                if(requestData.length==0)
                                  {
                                    _noNotifications=true;
                                  }
                                setState(() {

                                });
                              }
                              else
                              {
                                //
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                color: Colors.transparent,
                              ),
                              padding: EdgeInsets.all(12.0),
                              child: FittedBox(fit:BoxFit.scaleDown,child: Text("Reject",textAlign: TextAlign.center,)),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height:20),
                    Center(
                      child: Padding(
                        padding:EdgeInsets.symmetric(horizontal:16.0),
                        child: Divider(
                          height:2,
                          thickness:2.5,
                          color: Colors.black,

                        ),
                      ),
                    ),
                    SizedBox(
                        height:20
                    ),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
