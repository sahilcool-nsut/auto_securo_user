import 'package:flutter/material.dart';
class VehicleInfo
{
  String vehiclePhoto;
  String name;
  String numberPlate;
  String ownerName;
  VehicleInfo(vehiclePhoto,name,numberPlate,ownerName)
  {
    this.vehiclePhoto = vehiclePhoto;
    this.name = name;
    this.numberPlate = numberPlate;
    this.ownerName = ownerName;
  }
}
