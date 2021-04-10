import 'package:auto_securo_user/services/database_services.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:auto_securo_user/globals.dart' as globals;
import '../globals.dart';



class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  bool _noNotifications=true;
  bool _dataLoaded = false;
  //Json.decode karke nikallenge list from firebase, store bhi as json hi karenge(from admin app)
 // List notificationData=[{'vehicle':'Lamborghini','numberPlate':'DL4CAC0001','time':formatDate(DateTime.now(), [HH, ':', nn,])},{'vehicle':'Lamborghini','numberPlate':'DL4CAC0001','time':formatDate(DateTime.now(), [HH, ':', nn,])}];
  List notificationData=[];
  @override
  void initState() {

    getNotifications();
    super.initState();
  }

  Future<void> getNotifications() async{
    notificationData = await DatabaseService().getNotifications(globals.phoneNumber);
    if(notificationData.length==0)
      {
        setState(() {
          _noNotifications = true;
          _dataLoaded = true;
        });
      }
    else
      {
        setState(() {
          _noNotifications = false;
          _dataLoaded = true;
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: myAppBar,
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
          itemCount: notificationData.length,
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
                            text: 'Your vehicle numbered ',
                            children: <TextSpan>[
                              TextSpan(text:notificationData[index]["numberPlate"], style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text:" left at "),
                              TextSpan(text:formatDate(DateTime.parse(notificationData[index]["timeStamp"]), [dd, '/',mm, '/', yyyy, ', ',HH, ':', nn,]).toString(), style: TextStyle(fontWeight: FontWeight.bold)),
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
