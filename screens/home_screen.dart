import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mergehoney/widgets/custom_widgets/chose_image.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/admin_model.dart';
import '../provider/admin_provider.dart';
import '../server/db_method.dart';
import '../utils/utils.dart';
import '../widgets/custom_widgets/admin_textField.dart';
import 'bonus_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  List<TextEditingController> adminControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<Map<String, TextEditingController>> salesPoint = [];
  int _salesPointCount = 0;
  File? _imagePicker;
  File? _certificatePicker;
  String adminImage = '';
  String certificate = '';

  Future<void> saveInfo() async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });

    File? imageFile = _imagePicker;
    File? certificateFile = _certificatePicker;

    if (imageFile != null && certificateFile != null) {
      // String imagePath = 'images/${const Uuid().v4()}';
      // String certificatePath = 'images/${const Uuid().v4()}';

      String? imageUrl = await DBmethod().uploadImageToStorage(imageFile);
      String? certificate = await DBmethod().uploadImageToStorage(
        certificateFile,
      );

      if (imageUrl != null) {
        List<Map<String, String>> locationsToSave = [];
        for (int i = 0; i < salesPoint.length; i++) {
          locationsToSave.add({
            'city': salesPoint[i]['city']!.text,
            'adress': salesPoint[i]['adress']!.text,
          });
        }
        final AdminModel adminData = AdminModel(
          adminPhoneNumber: adminControllers[0].text,
          adminName: adminControllers[1].text,
          adminEmail: adminControllers[2].text,
          aboutStore: adminControllers[3].text,
          adminImageURL: imageUrl,
          certificateURL: certificate!,
          salesPoint: locationsToSave,
        );
        await adminProv.addAdminDataAndPoints(adminData);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  void selectImage(bool isCertificate) async {
    final image = await pickImage(context);
    if (isCertificate) {
      _certificatePicker = image;
    } else {
      _imagePicker = image;
    }
    setState(() {});
  }

  // @override
  // void initState() {
  //   super.initState();
  //   Future.delayed(Duration.zero, () {
  //     fetchInfo(context);
  //   });
  // }

  Future<void> fetchInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);

    setState(() {
      isLoading = true;
    });

    try {
      final adminData = await adminProv.getAdminDataAndPoints();

      if (adminData != null) {
        adminControllers[0].text = adminData.adminPhoneNumber;
        adminControllers[1].text = adminData.adminName;
        adminControllers[2].text = adminData.adminEmail;
        adminControllers[3].text = adminData.aboutStore;
        adminControllers[4].text = adminData.adminImageURL;
        adminImage = adminData.adminImageURL;
        certificate = adminData.certificateURL;
        //  попробовать  сгенерировть  список

        salesPoint.clear();
        if (adminData.salesPoint.isNotEmpty) {
          for (var location in adminData.salesPoint) {
            salesPoint.add({
              'city': TextEditingController(text: location['city'] ?? ''),
              'adress': TextEditingController(text: location['adress'] ?? ''),
            });
          }

          _salesPointCount = salesPoint.length;
        }
      } else {}
    } catch (e) {
      print(e);
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('admin info'),
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    AdminTextField(
                        controller: adminControllers[0],
                        labelText: 'Phone Number'),
                    AdminTextField(
                        controller: adminControllers[1], labelText: 'Name'),
                    AdminTextField(
                        controller: adminControllers[2], labelText: 'Email'),
                    AdminTextField(
                        controller: adminControllers[3], labelText: 'About'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ChooseImageWidget(
                          imageUrl: adminImage,
                          onSelectImage: () => selectImage(false),
                          imageFile: _imagePicker,
                        ),
                        ChooseImageWidget(
                          imageUrl: certificate,
                          onSelectImage: () => selectImage(true),
                          imageFile: _certificatePicker,
                        ),
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
        AdminTextField(controller: locationData['city'], labelText: 'city'),
        AdminTextField(controller: locationData['adress'], labelText: 'adress'),
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
