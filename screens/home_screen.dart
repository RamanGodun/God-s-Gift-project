// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/provider/admin_provider.dart';
import 'package:gods_gift/screens/bonus_screen.dart';
import 'package:gods_gift/server/DB_method.dart';
import 'package:gods_gift/utils/utils.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  TextEditingController adminPhoneNumber = TextEditingController();
  TextEditingController adminName = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController aboutStore = TextEditingController();
  TextEditingController adminImageURL = TextEditingController();
  TextEditingController certificateURL = TextEditingController();
  final List<Map<String, TextEditingController>> salesPoint = [];
  int _salesPointCount = 0;
  File? _adminImagePicker;
  File? _certificateImagePicker;

  Future<void> saveInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, String>> locationsToSave = [];
      for (int i = 0; i < salesPoint.length; i++) {
        locationsToSave.add({
          'city': salesPoint[i]['city']!.text,
          'adress': salesPoint[i]['adress']!.text,
        });
      }

      String? adminImageUrlStorage;
      if (_adminImagePicker != null) {
        adminImageUrlStorage = await DBmethod().saveImageToStorage(
          imageFile: _adminImagePicker,
          imageName: 'admin_photo',
        );
      }

      String? certificateImageUrlStorage;
      if (_certificateImagePicker != null) {
        certificateImageUrlStorage = await DBmethod().saveImageToStorage(
          imageFile: _certificateImagePicker,
          imageName: 'certificate_photo',
        );
      }

      final AdminModel adminData = AdminModel(
        adminPhoneNumber: adminPhoneNumber.text,
        adminName: adminName.text,
        adminEmail: adminEmail.text,
        adminImageURL: adminImageUrlStorage ?? adminImageURL.text,
        certificateURL: certificateImageUrlStorage ?? certificateURL.text,
        aboutStore: aboutStore.text,
        salesPoint: locationsToSave,
      );
      await adminProv.saveAdminDataAndPoints(adminData);
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

  void selectImage(bool adminImage) async {
    adminImage == true
        ? _adminImagePicker = await pickImage(context)
        : _certificateImagePicker = await pickImage(context);
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
                    textForm(labelText: 'Name', controller: adminName),
                    textForm(labelText: 'Email', controller: adminEmail),
                    textForm(labelText: 'About Store', controller: aboutStore),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        chouseImage(
                            imageUrl: adminImageURL.text, adminImage: true),
                        chouseImage(
                            imageUrl: certificateURL.text, adminImage: false),
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
                              saveInfo(context);
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

  Widget chouseImage({required String imageUrl, bool? adminImage}) {
    File? selectedImage =
        adminImage == true ? _adminImagePicker : _certificateImagePicker;
    return InkWell(
      onTap: () => selectImage(adminImage as bool),
      child: selectedImage == null && imageUrl.isEmpty
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
                    size: 90, color: Color.fromARGB(255, 105, 103, 103)),
              ),
            )
          : Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: selectedImage != null
                      ? Image.file(
                          selectedImage,
                          fit: BoxFit.cover,
                        )
                      : imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                            )
                          : Container(),
                ),
              ),
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
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Локація №$locationNumber'),
          ),
          textForm(labelText: 'city', controller: locationData['city']),
          textForm(labelText: 'adress', controller: locationData['adress']),
          ElevatedButton(
            onPressed: () {
              removeLocationContainer(index);
            },
            child: const Text('Delete point'),
          ),
        ]),
      ),
    );
  }
}
