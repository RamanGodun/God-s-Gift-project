// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/models/cashback_model.dart';
import 'package:gods_gift/server/DB_method.dart';
import 'package:gods_gift/utils/utils.dart';

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

  Future<AdminModel?> getAdminDataAndPoints(BuildContext context) async {
    try {
      final adminData =
          await DBmethod().fetchAdminDataFromFirestore('admin_data');
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
      await DBmethod().saveAdminInfoOnFirebase(
        adminInfo: adminInfo,
        docName: 'admin_data',
      );
      _adminModel = adminInfo;
    } catch (e) {
      showSnackBar(context, 'Помилка при збережені даних!');
    }
  }

  Future<void> saveAdminCashback(
      BuildContext context, CashbackModel cashbackInfo) async {
    try {
      await DBmethod().saveAdminInfoOnFirebase(
        cashbackInfo: cashbackInfo,
        docName: 'cashback_data',
      );
      _cashbackInfo = cashbackInfo;
    } catch (e) {
      showSnackBar(context, 'Помилка при збережені даних!');
    }
  }

  Future<CashbackModel?> getAdminCashback(BuildContext context) async {
    try {
      final cashbackData =
          await DBmethod().fetchAdminDataFromFirestore('cashback_data');
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
