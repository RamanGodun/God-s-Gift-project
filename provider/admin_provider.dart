import 'package:flutter/material.dart';
import 'package:mergehoney/models/admin_model.dart';
import 'package:mergehoney/server/DB_method.dart';

import '../models/casheBack_system_model.dart';

class AdminProvider with ChangeNotifier {
  bool isLoading = false;
  AdminModel? _adminModel;
  AdminModel get adminModel => _adminModel!;
  CasheBackModel _cashebackInfo = CasheBackModel(
      discountPercentage: [0, 0, 0, 0], spentMoneyLevel: [0, 0, 0, 0]);
  CasheBackModel get getCashebackInfo {
    return _cashebackInfo;
  }

  Future<AdminModel?> getAdminDataAndPoints() async {
    isLoading = true;
    notifyListeners();
    try {
      final adminData =
          await DBmethod().fetchAdminDataFromFirestore('admin_info');
      _adminModel = adminData;
      isLoading = false;
      notifyListeners();
      return adminData;
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> addAdminDataAndPoints(AdminModel info) async {
    isLoading = true;
    notifyListeners();
    try {
      final adminData = await DBmethod()
          .saveAdminInfoOnFirebase(adminInfo: info, docName: 'admin_info');
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CasheBackModel?> getCashebackModel() async {
    isLoading = true;
    notifyListeners();
    try {
      final cashebackData =
          await DBmethod().fetchAdminDataFromFirestore('casheBack');
      _cashebackInfo = cashebackData;
      print(cashebackData);
      isLoading = false;
      notifyListeners();

      return cashebackData;
    } catch (e) {
      print(e);
      isLoading = false;
      notifyListeners();
      return null;
    }
  }

  Future<void> saveAdminCasheBack(CasheBackModel casheBackInfo) async {
    isLoading = true;
    notifyListeners();
    try {
      final adminData = await DBmethod().saveAdminInfoOnFirebase(
          adminInfo: _adminModel,
          cashbackInfo: casheBackInfo,
          docName: 'casheBack');
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

  // Future<CasheBackModel?> getCashBackSystem() async {
  //   try {
  //     final cashBack = await DBmethod().getCashBackSystem();
  //     return cashBack;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  // Future<void> saveBonusData(CasheBackModel casheBack) async {
  //   try {
  //     await DBmethod().saveCashBackSystem(casheBack);
  //   } catch (e) {
  //     print(e.toString());
  //   }
  // }