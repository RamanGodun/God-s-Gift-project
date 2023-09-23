import 'package:flutter/material.dart';

class CasheBackModel {
  final List<int> discountPercentage;
  final List<int> spentMoneyLevel;

  CasheBackModel(
      {required this.discountPercentage, required this.spentMoneyLevel});

  Map<String, dynamic> toMap() {
    return {
      'discountPercentage': discountPercentage,
      'spentMoneyLevel': spentMoneyLevel,
    };
  }

  factory CasheBackModel.fromMap(Map<String, dynamic> map) {
    return CasheBackModel(
      discountPercentage: List<int>.from(map['discountPercentage']),
      spentMoneyLevel: List<int>.from(map['spentMoneyLevel']),
    );
  }
}
