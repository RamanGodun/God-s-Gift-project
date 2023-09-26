// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gods_gift/models/admin_model.dart';
import 'package:gods_gift/providers/admin_provider.dart';
import 'package:gods_gift/server/DB_method.dart';
import 'package:gods_gift/utils/utils.dart';
import 'package:gods_gift/widgets/custom_widgets/custom_text_field.dart';
import 'package:gods_gift/widgets/custom_widgets/edit_form_image.dart';
import 'package:provider/provider.dart';

class EditAdminInfoScreen extends StatefulWidget {
  const EditAdminInfoScreen({super.key});

  @override
  State<EditAdminInfoScreen> createState() => _EditAdminInfoScreenState();
}

class _EditAdminInfoScreenState extends State<EditAdminInfoScreen> {
  bool isLoading = false;
  TextEditingController adminPhoneNumber = TextEditingController();
  TextEditingController adminName = TextEditingController();
  TextEditingController adminEmail = TextEditingController();
  TextEditingController aboutStore = TextEditingController();
  TextEditingController adminImageURL = TextEditingController();
  TextEditingController certificateURL = TextEditingController();
  final List<Map<String, TextEditingController>> salePoints = [];
  int _salePointsCount = 0;
  File? _adminImagePicker;
  File? _certificateImagePicker;

  @override
  void initState() {
    super.initState();

    final adminModel =
        Provider.of<AdminProvider>(context, listen: false).adminModel;
    adminPhoneNumber.text = adminModel.adminPhoneNumber;
    adminName.text = adminModel.adminName;
    adminEmail.text = adminModel.adminEmail;
    adminImageURL.text = adminModel.adminImageURL;
    certificateURL.text = adminModel.certificateURL;
    aboutStore.text = adminModel.aboutStore;
    if (adminModel.salePoints.isNotEmpty) {
      for (var location in adminModel.salePoints) {
        salePoints.add({
          'city': TextEditingController(text: location['city'] ?? ''),
          'address': TextEditingController(text: location['address'] ?? ''),
        });
      }
      _salePointsCount = salePoints.length;
    }
  }

  Future<void> saveAdminInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      List<Map<String, String>> locationsToSave = [];
      for (int i = 0; i < salePoints.length; i++) {
        locationsToSave.add({
          'city': salePoints[i]['city']!.text,
          'address': salePoints[i]['address']!.text,
        });
      }

      String? adminImageUrlStorage;
      if (_adminImagePicker != null) {
        adminImageUrlStorage = await DBmethod().saveImageToStorage(
          imageFile: _adminImagePicker,
          imageName: 'adminPhoto',
        );
      }

      String? certificateImageUrlStorage;
      if (_certificateImagePicker != null) {
        certificateImageUrlStorage = await DBmethod().saveImageToStorage(
          imageFile: _certificateImagePicker,
          imageName: 'certificatePhoto',
        );
      }

      final AdminModel adminData = AdminModel(
        adminPhoneNumber: adminPhoneNumber.text,
        adminName: adminName.text,
        adminEmail: adminEmail.text,
        adminImageURL: adminImageUrlStorage ?? adminImageURL.text,
        certificateURL: certificateImageUrlStorage ?? certificateURL.text,
        aboutStore: aboutStore.text,
        salePoints: locationsToSave,
      );
      await adminProv.saveAdminDataAndPoints(context, adminData);
      fetchAdminInfo(context);
    } catch (e) {
      showSnackBar(context, 'Дані неможливо зберегти!');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAdminInfo(BuildContext context) async {
    final adminProv = Provider.of<AdminProvider>(context, listen: false);
    setState(() {
      isLoading = true;
    });
    try {
      await adminProv.getAdminDataAndPoints(context);
      adminPhoneNumber.text = adminProv.adminModel.adminPhoneNumber;
      adminName.text = adminProv.adminModel.adminName;
      adminEmail.text = adminProv.adminModel.adminEmail;
      adminImageURL.text = adminProv.adminModel.adminImageURL;
      certificateURL.text = adminProv.adminModel.certificateURL;
      aboutStore.text = adminProv.adminModel.aboutStore;
      salePoints.clear();
      if (adminProv.adminModel.salePoints.isNotEmpty) {
        for (var location in adminProv.adminModel.salePoints) {
          salePoints.add({
            'city': TextEditingController(text: location['city'] ?? ''),
            'address': TextEditingController(text: location['address'] ?? ''),
          });
        }
        _salePointsCount = salePoints.length;
      } else {}
    } catch (e) {
      showSnackBar(context, 'Дані неможливо отримати!');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _addLocationContainer() {
    if (_salePointsCount < 6) {
      setState(() {
        _salePointsCount++;
        salePoints.add({
          'city': TextEditingController(),
          'address': TextEditingController(),
        });
      });
    }
  }

  void _removeLocationContainer(int index) {
    setState(() {
      salePoints.removeAt(index);
      _salePointsCount--;
    });
  }

  void selectImage(bool adminImage) async {
    adminImage == true
        ? _adminImagePicker = await pickImage(context)
        : _certificateImagePicker = await pickImage(context);
    setState(() {});
  }

  void _handleImagePicked(File? image) {
    setState(() {
      _adminImagePicker = image;
    });
  }

  void _handleCertificateIPicked(File? image) {
    setState(() {
      _certificateImagePicker = image;
    });
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
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          EditFormImage(
                            currentProfileImage: adminImageURL.text,
                            onImagePicked: _handleImagePicked,
                            height: 128,
                            width: 130,
                            paddingLeft: 0,
                            paddingTop: 15,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.60,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  controller: adminPhoneNumber,
                                  labelText: 'Phone Number',
                                  hintText: '',
                                  typeOfField: 'int',
                                  paddingTop: 30,
                                  paddingRight: 0,
                                  paddingLeft: 10,
                                ),
                                CustomTextFormField(
                                  controller: adminName,
                                  labelText: 'Name',
                                  hintText: '',
                                  typeOfField: 'String',
                                  paddingRight: 0,
                                  paddingLeft: 10,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    CustomTextFormField(
                      controller: adminEmail,
                      labelText: 'Email',
                      hintText: '',
                      typeOfField: 'String',
                      paddingTop: 0,
                    ),
                    CustomTextFormField(
                      controller: aboutStore,
                      labelText: 'About Store',
                      hintText: '',
                      typeOfField: 'String',
                    ),
                    EditFormImage(
                      currentProfileImage: certificateURL.text,
                      onImagePicked: _handleCertificateIPicked,
                      height: 400,
                      paddingLeft: 15,
                      paddingRight: 15,
                      paddingTop: 15,
                    ),
                    for (int i = 0; i < _salePointsCount; i++)
                      BuildLocation(
                        context: context,
                        removeLocationContainer: _removeLocationContainer,
                        locationData: salePoints[i],
                        index: i,
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              saveAdminInfo(context);
                            },
                            child: const Text('Add'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              fetchAdminInfo(context);
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
                  ],
                ),
              ),
            ),
    );
  }
}

class BuildLocation extends StatelessWidget {
  final Function removeLocationContainer;
  final BuildContext context;
  final Map<String, TextEditingController> locationData;
  final int index;
  const BuildLocation(
      {super.key,
      required this.removeLocationContainer,
      required this.context,
      required this.locationData,
      required this.index});

  @override
  Widget build(BuildContext context) {
    int locationNumber = index + 1;
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text('Локація №$locationNumber'),
          ),
          CustomTextFormField(
            labelText: 'city',
            controller: locationData['city'] as TextEditingController,
            hintText: '',
            typeOfField: 'String',
          ),
          CustomTextFormField(
            labelText: 'address',
            controller: locationData['address'] as TextEditingController,
            hintText: '',
            typeOfField: 'String',
          ),
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
