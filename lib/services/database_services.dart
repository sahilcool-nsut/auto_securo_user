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
    final CollectionReference vehiclesCollection =
    FirebaseFirestore.instance.collection('vehicles');
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

}