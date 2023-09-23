import 'package:flutter/material.dart';
import 'package:mergehoney/models/casheBack_system_model.dart';
import 'package:mergehoney/provider/admin_provider.dart';
import 'package:mergehoney/widgets/custom_widgets/bonus_text_field.dart';
import 'package:provider/provider.dart';

class BonusScreen extends StatefulWidget {
  const BonusScreen({super.key});

  @override
  State<BonusScreen> createState() => _BonusScreenState();
}

class _BonusScreenState extends State<BonusScreen> {
  List<TextEditingController> percentageControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  List<TextEditingController> spentMoneyControllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  Future<CasheBackModel?> _loadCashebackData() async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    final cashebackData = await adminProv.getCashebackModel();
    if (cashebackData != null) {
      for (int i = 0; i < 4; i++) {
        percentageControllers[i].text =
            cashebackData.discountPercentage[i].toString();
        spentMoneyControllers[i].text =
            cashebackData.spentMoneyLevel[i].toString();
      }
    }
    return cashebackData;
  }

  @override
  void dispose() {
    for (final controller in percentageControllers) {
      controller.dispose();
    }
    for (final controller in spentMoneyControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Container(
              height: size.height / 2,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(1),
              ),
              child: Column(
                children: List.generate(4, (index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      BonusTextField(controller: percentageControllers[index]),
                      BonusTextField(controller: spentMoneyControllers[index]),
                    ],
                  );
                }),
              )),
          Consumer<AdminProvider>(
            builder: (context, adminProvider, _) {
              return ElevatedButton(
                onPressed: () async {
                  List<int> discountPercentages = [];
                  List<int> spentMoneyLevels = [];

                  for (int i = 0; i < 4; i++) {
                    discountPercentages
                        .add(int.tryParse(percentageControllers[i].text) ?? 0);
                    spentMoneyLevels
                        .add(int.tryParse(spentMoneyControllers[i].text) ?? 0);
                  }

                  CasheBackModel casheBack = CasheBackModel(
                    discountPercentage: discountPercentages,
                    spentMoneyLevel: spentMoneyLevels,
                  );

                  await adminProvider.saveAdminCasheBack(casheBack);
                },
                child: Text(
                  'Save casheBack',
                  style: TextStyle(color: Colors.black),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              _loadCashebackData();
            },
            child: Text('fetch casheback'),
          ),
        ],
      ),
    );
  }
}
