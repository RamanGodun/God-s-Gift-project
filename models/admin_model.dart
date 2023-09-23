class AdminModel {
  final String adminPhoneNumber;
  final String adminName;
  final String adminEmail;
  final String adminImageURL;
  final String certificateURL;
  final String aboutStore;
  final List<Map<String, dynamic>> salesPoint;

  AdminModel({
    required this.adminPhoneNumber,
    required this.adminName,
    required this.adminEmail,
    required this.adminImageURL,
    required this.certificateURL,
    required this.aboutStore,
    required this.salesPoint,
  });

  factory AdminModel.fromMap(Map<String, dynamic> map) {
    final List<Map<String, dynamic>> salesPointList =
        List<Map<String, dynamic>>.from(map['salesPoint'] ?? []);

    return AdminModel(
      adminPhoneNumber: map['adminPhoneNumber'],
      adminName: map['adminName'] ?? '',
      adminEmail: map['adminEmail'] ?? '',
      adminImageURL: map['adminImageURL'] ?? '',
      certificateURL: map['certificateURL'] ?? '',
      aboutStore: map['aboutStore'] ?? '',
      salesPoint: salesPointList,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "adminPhoneNumber": adminPhoneNumber,
      "adminName": adminName,
      "adminEmail": adminEmail,
      "adminImageURL": adminImageURL,
      "certificateURL": certificateURL,
      "aboutStore": aboutStore,
      "salesPoint": salesPoint,
    };
  }
}
