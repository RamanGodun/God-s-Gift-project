// ignore_for_file: use_build_context_synchronously

import 'db_methods.dart';
import 'package:flutter/material.dart';
import '/models/admin_model.dart';
import '/models/cashback_model.dart';
import '/utils/utils.dart';

class AdminProvider with ChangeNotifier {
  AdminModel? _adminModel = AdminModel(
    aboutStore: '',
    adminEmail: '',
    adminImageURL: '',
    adminName: '',
    adminPhoneNumber: '',
    certificateURL: '',
    salePoints: [],
  );
  AdminModel get adminModel => _adminModel!;
  CashbackModel _cashbackInfo = CashbackModel(
    discountPercentage: [0, 0, 0, 0],
    spentMoneyLevel: [0, 0, 0, 0],
  );
  CashbackModel get cashbackInfo {
    return _cashbackInfo;
  }

  Future<AdminModel?> getAdminDataAndPoints(BuildContext context) async {
    try {
      final adminData =
          await DBmethods().fetchAdminDataFromFirestore('adminData');
      if (adminData != null) {
        _adminModel = adminData;
      }
      return adminData;
    } catch (e) {
      showSnackBar(context, 'Помилка при отримані даних!');
      return null;
    }
  }

  Future<void> saveAdminDataAndPoints(
      BuildContext context, AdminModel adminInfo) async {
    try {
      await DBmethods().saveAdminInfoOnFirebase(
        adminInfo: adminInfo,
        docName: 'adminData',
      );
      _adminModel = adminInfo;
    } catch (e) {
      showSnackBar(context, 'Помилка при збережені даних!');
    }
  }

  Future<void> saveAdminCashback(
      BuildContext context, CashbackModel cashbackInfo) async {
    try {
      await DBmethods().saveAdminInfoOnFirebase(
        cashbackInfo: cashbackInfo,
        docName: 'cashbackData',
      );
      _cashbackInfo = cashbackInfo;
    } catch (e) {
      showSnackBar(context, 'Помилка при збережені даних!');
    }
  }

  Future<CashbackModel?> getAdminCashback(BuildContext context) async {
    try {
      final cashbackData =
          await DBmethods().fetchAdminDataFromFirestore('cashbackData');
      if (cashbackData != null) {
        _cashbackInfo = cashbackData;
      }
      return cashbackData;
    } catch (e) {
      showSnackBar(context, 'Помилка при отримані даних!');
      return null;
    }
  }

  int findCashbackPercentageAmount(int inputAmount) {
    for (int i = _cashbackInfo.spentMoneyLevel.length - 1; i >= 0; i--) {
      if (inputAmount >= _cashbackInfo.spentMoneyLevel[i]) {
        int foundedDiscountAmount = _cashbackInfo.discountPercentage[i];
        return foundedDiscountAmount;
      }
    }
    return 0;
  }
}
