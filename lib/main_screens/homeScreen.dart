import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:qr/qr.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../globals.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool noVehicles = false;     //to be checked in initstate
  String userName;            //initialize in initstate
  bool dataLoaded = true;

  //fill in initstate
  List vehicleList=[
    VehicleInfo("https://www.telegraph.co.uk/content/dam/news/2017/11/11/Lam1_trans_NvBQzQNjv4BqnAdySV0BR-4fDN_-_p756cVfcy8zLGPV4EhRkjQy7tg.jpg", "Lamborghini", "DL4CAC0001", "Sahil Chawla", DateTime.now().toString()),
    VehicleInfo("https://thedriven.io/wp-content/uploads/2019/06/crophero-jaguarxjgameofdrones22180917-1200x462-800x450.jpg","Jaguar", "888JXJ", "Sahil Chawla", DateTime.now().toString())
  ];

  @override
  void initState() {
    userName = "Sahil Chawla";

    //fetch data and make dataLoaded = true

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: myAppBar,
        body: SafeArea(
          child: !dataLoaded? Center(child: Container(height:30,width:30,child: CircularProgressIndicator())): Padding(
            padding: const EdgeInsets.all(16.0),
            child: noVehicles?SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:30),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
                      text: 'User: ',
                      children: <TextSpan>[
                        TextSpan(text: userName.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height:30),

                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("No Vehicle Added"),
                        Container(
                          child: Center(
                            child: Image(
                              image: AssetImage("images/no_vehiclePNG.png"),
                              height: MediaQuery.of(context).size.height * 0.4,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'You may ',
                            style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
                            children: <TextSpan>[
                              TextSpan(text: 'request ', style: TextStyle(fontWeight: FontWeight.bold)),
                              TextSpan(text: 'an owner to link a vehicle to your account'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
                :
            PageView.builder(
              scrollDirection: Axis.vertical,

              physics: AlwaysScrollableScrollPhysics(),
              itemCount: vehicleList.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:MediaQuery.of(context).size.height*0.03),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black,fontFamily: 'Montserrat'),
                          text: 'User: ',
                          children: <TextSpan>[
                            TextSpan(text: userName.toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.02),
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
                    SizedBox(height:MediaQuery.of(context).size.height*0.02),
                    Container(
                      child: Center(
                        child: CachedNetworkImage(
                          imageUrl: vehicleList[index].carPhoto,
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.04),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Vehicle: ',
                          style: TextStyle(color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(text: vehicleList[index].name, style: TextStyle(fontWeight: FontWeight.normal,fontSize: 17)),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.01),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Vehicle Numberplate: ',
                          style: TextStyle(color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(text: vehicleList[index].numberPlate, style: TextStyle(fontWeight: FontWeight.normal,fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.01),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          text: 'Owner Name: ',
                          style: TextStyle(color: Colors.black,fontFamily: 'Montserrat',fontWeight: FontWeight.bold,fontSize: 17),
                          children: <TextSpan>[
                            TextSpan(text: vehicleList[index].ownerName, style: TextStyle(fontWeight: FontWeight.normal,fontSize: 17)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.03),
                    Center(
                      child: QrImage(
                        data: vehicleList[index].ownerName + "took the " + vehicleList[index].name + " numbered " + vehicleList[index].numberPlate + " on " + formatDate(DateTime.now(), [dd, '/',mm, '/', yyyy, ', ',HH, ':', nn,]).toString(),
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.height * 0.25,
                      ),
                    ),
                    SizedBox(height:MediaQuery.of(context).size.height*0.04),
                  ],
                );
              },
            ),
          ),
        )
    );
  }

}

class VehicleInfo
{
  String carPhoto;
  String name;
  String numberPlate;
  String ownerName;
  String timeStamp;
  VehicleInfo(carPhoto,name,numberPlate,ownerName,timeStamp)
  {
    this.carPhoto = carPhoto;
    this.name = name;
    this.numberPlate = numberPlate;
    this.ownerName = ownerName;
    this.timeStamp = timeStamp;
  }
}
