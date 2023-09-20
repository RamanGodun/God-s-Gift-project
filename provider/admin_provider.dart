import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/models/cashback_model.dart';
import 'package:gods_gift/server/DB_method.dart';

class AdminProvider with ChangeNotifier {
  bool isLoading = false;
  AdminModel? _adminModel;
  AdminModel get adminModel => _adminModel!;
  CashbackModel _cashbackInfo = CashbackModel(
    discountPercentage: [0, 0, 0, 0],
    spentMoneyLevel: [0, 0, 0, 0],
  );
  CashbackModel get cashbackInfo {
    return _cashbackInfo;
  }

  Future<AdminModel?> getAdminDataAndPoints() async {
    isLoading = true;
    notifyListeners();
    try {
      final adminData =
          await DBmethod().fetchAdminDataFromFirestore('admin_data');
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

  Future<void> saveAdminDataAndPoints(AdminModel adminInfo) async {
    isLoading = true;
    notifyListeners();
    try {
      await DBmethod().saveAdminInfoOnFirebase(
        adminInfo: adminInfo,
        docName: 'admin_data',
      );
      _adminModel = adminInfo;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveAdminCashback(CashbackModel cashbackInfo) async {
    isLoading = true;
    notifyListeners();
    try {
      await DBmethod().saveAdminInfoOnFirebase(
        cashbackInfo: cashbackInfo,
        docName: 'cashback_data',
      );
      _cashbackInfo = cashbackInfo;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<CashbackModel?> getAdminCashback() async {
    isLoading = true;
    notifyListeners();
    try {
      final cashbackData =
          await DBmethod().fetchAdminDataFromFirestore('cashback_data');
      if (cashbackData != null) {
        _cashbackInfo = cashbackData;
      }
      isLoading = false;
      notifyListeners();
      return cashbackData;
    } catch (e) {
      isLoading = false;
      notifyListeners();
      return null;
    }
  }
}
