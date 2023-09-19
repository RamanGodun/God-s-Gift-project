import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/provider/admin_provider.dart';
import 'package:gods_gift/screens/bonus_screen.dart';
import 'package:gods_gift/server/DB_method.dart';
import 'package:gods_gift/utils/utils.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  TextEditingController adminPhoneNumber = TextEditingController();
  TextEditingController adminName = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController adminImageURL = TextEditingController();
  TextEditingController certificateURL = TextEditingController();
  TextEditingController aboutStore = TextEditingController();
  final List<Map<String, TextEditingController>> salesPoint = [];
  int _salesPointCount = 0;
  File? _imagePicker;

  Future<void> saveInfo() async {
    setState(() {
      isLoading = true;
    });

    List<Map<String, String>> locationsToSave = [];
    for (int i = 0; i < salesPoint.length; i++) {
      locationsToSave.add({
        'city': salesPoint[i]['city']!.text,
        'adress': salesPoint[i]['adress']!.text,
      });
    }
    final AdminModel adminData = AdminModel(
      adminPhoneNumber: adminPhoneNumber.text,
      adminName: adminName.text,
      adminEmail: adminEmail.text,
      adminImageURL: adminImageURL.text,
      certificateURL: certificateURL.text,
      aboutStore: aboutStore.text,
      salesPoint: locationsToSave,
    );
    await DBmethod().saveAdminInfoOnFirebase(adminData);
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
      final adminInfo = await adminProv.getAdminDataAndPoints();
      if (adminInfo != null) {
        adminPhoneNumber.text = adminInfo.adminPhoneNumber;
        adminName.text = adminInfo.adminName;
        adminEmail.text = adminInfo.adminEmail;
        adminImageURL.text = adminInfo.adminImageURL;
        certificateURL.text = adminInfo.certificateURL;
        aboutStore.text = adminInfo.aboutStore;
        salesPoint.clear();
        if (adminInfo.salesPoint.isNotEmpty) {
          for (var location in adminInfo.salesPoint) {
            salesPoint.add({
              'city': TextEditingController(text: location['city'] ?? ''),
              'adress': TextEditingController(text: location['adress'] ?? ''),
            });
          }

          _salesPointCount = salesPoint.length;
        }
      } else {}
    } catch (e) {}
    setState(() {
      isLoading = false;
    });
  }

  void _addLocationContainer() {
    if (_salesPointCount < 6) {
      setState(() {
        _salesPointCount++;
        salesPoint.add({
          'city': TextEditingController(),
          'adress': TextEditingController(),
        });
      });
    }
  }

  void _removeLocationContainer(int index) {
    setState(() {
      salesPoint.removeAt(index);
      _salesPointCount--;
    });
  }

  void selectImage() async {
    _imagePicker = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Demo Home Page'),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    textForm(
                        labelText: 'Phone Number',
                        controller: adminPhoneNumber),
                    textForm(
                      labelText: 'Name',
                      controller: adminName,
                    ),
                    textForm(labelText: 'Email', controller: adminEmail),
                    textForm(labelText: 'About Store', controller: aboutStore),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        chouseImage(imageUrl: adminImageURL.text),
                        chouseImage(imageUrl: certificateURL.text),
                      ],
                    ),
                    for (int i = 0; i < _salesPointCount; i++)
                      buildLocation(
                        context: context,
                        removeLocationContainer: _removeLocationContainer,
                        locationData: salesPoint[i],
                        index: i,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              saveInfo();
                            },
                            child: const Text('Add'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              fetchInfo(context);
                            },
                            child: const Text('Fetch data'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addLocationContainer();
                            },
                            child: const Text('Add point'),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: ElevatedButton(
                        onPressed: () {
                          nextScreen(context, const BonusScreen());
                        },
                        child: const Text('Bonus screen'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget chouseImage({required String imageUrl}) {
    return InkWell(
      onTap: () => selectImage(),
      child: _imagePicker == null
          ? Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(Icons.add_a_photo,
                    size: 90, color: Colors.white),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: _imagePicker != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              _imagePicker!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                  )),
            ),
    );
  }

  Widget textForm({TextEditingController? controller, String? labelText}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: labelText),
        controller: controller,
      ),
    );
  }

  Widget buildLocation({
    required Function removeLocationContainer,
    required BuildContext context,
    required Map<String, TextEditingController> locationData,
    required int index,
  }) {
    int locationNumber = index + 1;
    return Card(
      child: Column(children: [
        Text('Локація №$locationNumber'),
        textForm(labelText: 'city', controller: locationData['city']),
        textForm(labelText: 'adress', controller: locationData['adress']),
        ElevatedButton(
          onPressed: () {
            removeLocationContainer(index);
          },
          child: const Text('Delete point'),
        ),
      ]),
    );
  }
}
