// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/material.dart';

class UserModel {
  final String userId;
  final String useName;
  final String userLastName;
  final String userImageUrl;
  final String userPhoneNumber;
  final String userCity;
  final String userPostOffice;
  final String userDeliveryType;
  final double userBonuses;
  final double userTotal;

  UserModel(
      {required this.userId,
      required this.useName,
      required this.userLastName,
      required this.userImageUrl,
      required this.userPhoneNumber,
      required this.userCity,
      required this.userPostOffice,
      required this.userDeliveryType,
      required this.userBonuses,
      required this.userTotal});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'useName': useName,
      'userLastName': userLastName,
      'userImageUrl': userImageUrl,
      'userPhoneNumber': userPhoneNumber,
      'userCity': userCity,
      'userPostOffice': userPostOffice,
      'userDeliveryType': userDeliveryType,
      'userBonuses': userBonuses,
      'userTotal': userTotal,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      userId: map['userId'] as String,
      useName: map['useName'] as String,
      userLastName: map['userLastName'] as String,
      userImageUrl: map['userImageUrl'] as String,
      userPhoneNumber: map['userPhoneNumber'] as String,
      userCity: map['userCity'] as String,
      userPostOffice: map['userPostOffice'] as String,
      userDeliveryType: map['userDeliveryType'] as String,
      userBonuses: map['userBonuses'] as double,
      userTotal: map['userTotal'] as double,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
