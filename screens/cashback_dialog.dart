// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:gods_gift/models/cashback_model.dart';
import 'package:gods_gift/providers/admin_provider.dart';
import 'package:gods_gift/utils/utils.dart';
import 'package:gods_gift/widgets/custom_widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class BonusScreen extends StatefulWidget {
  const BonusScreen({Key? key}) : super(key: key);

  @override
  BonusScreenState createState() => BonusScreenState();
}

class BonusScreenState extends State<BonusScreen> {
  List<TextEditingController> discountPercentageControllers = [];
  List<TextEditingController> spentMoneyLevelControllers = [];
  TextEditingController totalSum = TextEditingController();
  TextEditingController orderSum = TextEditingController();
  int cashback = 0;
  bool isLoading = false;
  bool isContainer = true;

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
        context,
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
      await adminProv.getAdminCashback(context);
      for (int i = 0; i < 4; i++) {
        discountPercentageControllers[i].text =
            adminProv.cashbackInfo.discountPercentage[i].toString();
        spentMoneyLevelControllers[i].text =
            adminProv.cashbackInfo.spentMoneyLevel[i].toString();
      }
    } catch (e) {
      showSnackBar(context, 'Дані неможливо отримати!');
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> fecthCashback() async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      final cashbackPercent =
          adminProv.findCashbackPercentageAmount(int.parse(totalSum.text));
      int calculatedBonusesForCurrentOrder =
          (cashbackPercent * int.parse(orderSum.text) ~/ 100);
      cashback = calculatedBonusesForCurrentOrder;
    } catch (e) {
      showSnackBar(context, 'Неможливо отримати кеш!');
    }
    setState(() {
      isLoading = false;
    });
  }

  void changeIsContainer() {
    setState(() {
      isContainer = !isContainer;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 10, left: 10, bottom: 20, top: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ))
              ],
            ),
            for (int i = 0; i < 4; i++)
              TextFormForCashback(
                discountPercentageControllers: discountPercentageControllers,
                spentMoneyLevelControllers: spentMoneyLevelControllers,
                isContainer: isContainer,
                index: i,
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    isContainer == false ? saveInfo(context) : null;
                    changeIsContainer();
                  },
                  child: Text(isContainer == true ? 'Change' : 'Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextFormForCashback extends StatelessWidget {
  final List<TextEditingController> discountPercentageControllers;
  final List<TextEditingController> spentMoneyLevelControllers;
  final bool isContainer;
  final int index;

  const TextFormForCashback(
      {super.key,
      required this.index,
      required this.isContainer,
      required this.discountPercentageControllers,
      required this.spentMoneyLevelControllers});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 150,
            child: CustomTextFormField(
              isContainer: isContainer,
              textForContainer: discountPercentageControllers[index].text,
              labelText: '%',
              hintText: '',
              controller: discountPercentageControllers[index],
              typeOfField: 'int',
            ),
          ),
          SizedBox(
            width: 150,
            child: CustomTextFormField(
              isContainer: isContainer,
              textForContainer: spentMoneyLevelControllers[index].text,
              labelText: 'грн',
              hintText: '',
              typeOfField: 'int',
              controller: spentMoneyLevelControllers[index],
            ),
          ),
        ],
      ),
    );
  }
}
