// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gods_gift/models/cashback_model.dart';
import 'package:gods_gift/provider/admin_provider.dart';
import 'package:gods_gift/utils/utils.dart';
import 'package:provider/provider.dart';

class BonusScreen extends StatefulWidget {
  const BonusScreen({Key? key}) : super(key: key);

  @override
  BonusScreenState createState() => BonusScreenState();
}

class BonusScreenState extends State<BonusScreen> {
  List<TextEditingController> discountPercentageControllers = [];
  List<TextEditingController> spentMoneyLevelControllers = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final cashbackInfo =
        Provider.of<AdminProvider>(context, listen: false).cashbackInfo;
    for (int i = 0; i < 4; i++) {
      discountPercentageControllers.add(TextEditingController(
        text: cashbackInfo.discountPercentage[i].toString(),
      ));
      spentMoneyLevelControllers.add(TextEditingController(
        text: cashbackInfo.spentMoneyLevel[i].toString(),
      ));
    }
  }

  Future<void> saveInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await adminProv.saveAdminCashback(
        CashbackModel(
          discountPercentage: discountPercentageControllers
              .map((controller) => int.tryParse(controller.text) ?? 0)
              .toList(),
          spentMoneyLevel: spentMoneyLevelControllers
              .map((controller) => int.tryParse(controller.text) ?? 0)
              .toList(),
        ),
      );
    } catch (e) {
      showSnackBar(context, 'Дані неможливо зберегти!');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      final cashbackInfo = await adminProv.getAdminCashback();
      for (int i = 0; i < 4; i++) {
        discountPercentageControllers[i].text =
            cashbackInfo!.discountPercentage[i].toString();
        spentMoneyLevelControllers[i].text =
            cashbackInfo.spentMoneyLevel[i].toString();
      }
    } catch (e) {
      showSnackBar(context, 'Дані неможливо отримати!');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          for (int i = 0; i < 4; i++) textFormWidget(index: i),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    saveInfo(context);
                  },
                  child: const Text('Save bonus data'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    fetchInfo(context);
                  },
                  child: const Text('Fetch bonus data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget textFormWidget({required int index}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: 150,
              child: TextFormField(
                decoration: const InputDecoration(labelText: '%'),
                controller: discountPercentageControllers[index],
              ),
            ),
            SizedBox(
              width: 150,
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Грн'),
                controller: spentMoneyLevelControllers[index],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
