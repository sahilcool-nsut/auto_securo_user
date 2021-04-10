import 'package:auto_securo_user/VehicleInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:auto_securo_user/globals.dart' as globals;

import '../globals.dart';

class DatabaseService {

  // collection reference
  final CollectionReference usersCollection =
  FirebaseFirestore.instance.collection('users');
  final CollectionReference vehiclesCollection =
  FirebaseFirestore.instance.collection('vehicles');

  Future<void> checkUserCollectionExists () async
  {
    print("inside checking");
    print(globals.user.phoneNumber);
    var doc = await usersCollection.doc(globals.phoneNumber).get();
    if(!doc.exists)
      {
        await usersCollection.doc(globals.phoneNumber).set({});
        print("created document");
      }
    else
      {
        print("doc exists");
      }
    var token = await FirebaseMessaging.instance.getToken();
    usersCollection.doc(globals.phoneNumber).update({
      'deviceToken': token,
    });
  }
  Future<void> updateProfile(String name, String house) async
  {
    var doc = await usersCollection.doc(globals.phoneNumber).update(
        {
          'fullName': name,
          'house':house,
        }
    );
    User currentUser = FirebaseAuth.instance.currentUser;
    await currentUser.updateProfile(displayName: name);
    globals.user = currentUser;

  }
  Future<List<VehicleInfo>> getVehiclesData() async{
    List<VehicleInfo> tempList =[];
    await usersCollection.doc(globals.phoneNumber).collection('vehicles').get().then((QuerySnapshot snapshot){
      print(snapshot.docs);
      if(snapshot.docs.length==0)
        {
          print("Empty");
          return tempList;
        }
      final CollectionReference vehiclesCollection =
      FirebaseFirestore.instance.collection('vehicles');

      snapshot.docs.forEach((element) async{
        print(element["numberPlate"]);
        var vehicleInfo = await vehiclesCollection.doc(element["numberPlate"]).get();
        tempList.add(
            VehicleInfo(vehicleInfo["vehiclePhoto"],vehicleInfo["vehicleName"],vehicleInfo["numberPlate"], vehicleInfo["ownerName"])
        );
      });
    });
    print(tempList);
    print("huehue");
    return tempList;

  }
  Future<bool> checkVehicleExists(String numberPlate) async {

    var vehicleDoc = await vehiclesCollection.doc(numberPlate).get();
    print(numberPlate);
    print("numberPlate from check Vehicle");
    print(vehicleDoc);
    if(vehicleDoc.exists)
      {
        return true;
      }
    else
      {
        return false;
      }
  }

  Future<bool> sendRequest(String numberPlate,String currentUserPhoneNumber) async
  {
    try{
      var vehicleDoc = await vehiclesCollection.doc(numberPlate).get();
      String ownerPhoneNumber = vehicleDoc.data()["ownerPhone"];
      print(ownerPhoneNumber);
      print("Owner Phone Number from sendRequest");
      await usersCollection.doc(ownerPhoneNumber).collection("requests").add({
        "requestFrom": currentUserPhoneNumber,
        "numberPlate":numberPlate,
        "requestFromName":globals.name,
      });
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }

  }

  Future<List<Map<dynamic,dynamic>>> getRequests(String currentUserPhoneNumber) async
  {
    List<Map<dynamic,dynamic>> tempList=[];
    try{
      var requstsDocs = await usersCollection.doc(currentUserPhoneNumber).collection("requests").get().then((snapshot) {
              var data = snapshot.docs;
              if(snapshot.docs.length==0)
                {
                  return tempList;
                }
              else
                {
                  data.forEach((element) {
                    tempList.add(
                        {
                          'requestFrom':element["requestFrom"],
                          'numberPlate':element["numberPlate"],
                          'requestFromName':element["requestFromName"],
                          'requestID':element.reference.id,
                      }
                    );
                  });
                }
      });
      return tempList;
    }
    catch(e)
    {
      print(e);
      return [];
    }

  }

  Future<bool> acceptRequest(String numberPlate, String targetPhoneNumber,String requestID) async{

    try
    {
      var temp = await usersCollection.doc(targetPhoneNumber).collection("vehicles").add({
        "numberPlate":numberPlate,
        "owner":false,
      });
      var temp2 = await vehiclesCollection.doc(numberPlate).collection("users").add({
        "phoneNumber":targetPhoneNumber,
        "owner":false,
      });

      deleteRequest(requestID);

      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }

  }
  Future<bool> deleteRequest(String requestID) async {

    try
    {
      await usersCollection.doc(globals.phoneNumber).collection("requests").doc(requestID).delete();
      print("inside delete");
      return true;
    }
    catch(e)
    {
      print(e);
      return false;
    }

  }


  Future<List<Map<dynamic,dynamic>>> getNotifications(String currentUserPhoneNumber) async
  {
    print(DateTime.now());
    List<Map<dynamic,dynamic>> tempList=[];
    try{
      var notificationDocs = await usersCollection.doc(currentUserPhoneNumber).collection("notifications").orderBy("timeStamp",descending: true).get().then((snapshot) {
        var data = snapshot.docs;
        if(snapshot.docs.length==0)
        {
          return tempList;
        }
        else
        {
          data.forEach((element) {
            tempList.add(
                {
                  'numberPlate':element["numberPlate"],
                  'timeStamp':element["timeStamp"],
                }
            );
          });
        }
      });
      return tempList;
    }
    catch(e)
    {
      print(e);
      return [];
    }

  }

}