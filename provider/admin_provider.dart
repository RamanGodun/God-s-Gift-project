import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/server/DB_method.dart';

class AdminProvider with ChangeNotifier {
  bool isLoading = false;
  AdminModel? _adminModel;
  AdminModel get adminModel => _adminModel!;

  Future<AdminModel?> getAdminDataAndPoints() async {
    isLoading = true;
    notifyListeners();
    try {
      final adminData = await DBmethod().fetchAdminDataFromFirestore();
      if (adminData != null) {
        _adminModel = adminData;
      }
      isLoading = false;
      notifyListeners();
      return adminData;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
