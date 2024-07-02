import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  static const String collectionName = 'users'; // Removed extra space
  String id;
  String firstName;
  String lastName;
  String userName;
  String email;
  bool isDoc;
  String userType;
  String imageUrl;
  String rate;
  String countRate;
  String address;
  String specialization;
  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.isDoc,
    required this.imageUrl,
    required this.userType,
    required this.rate,
    required this.countRate,
    required this.address,
    required this.specialization,
  });

  MyUser.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] as String,
          firstName: json['first_name'] as String,
          lastName: json['last_name'] as String,
          userName: json['user_name'] as String,
          imageUrl: json['image_url'].toString() as String,
          email: json['email'] as String,
          isDoc: json['IsDoc'] as bool, // Removed extra colon
          userType: json['userType'] as String,
          rate: json['rate'].toString() ?? "",
          countRate: json['count_rate'].toString() ?? "",
          address: json['address'] ?? "",
          specialization: json['specialization'] ?? "",
        );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'user_name': userName,
      'email': email,
      'IsDoc': isDoc,
      'userType': userType,
      'rate': rate,
      'count_rate': countRate,
      'address': address,
      'specialization': specialization,
      'image_url': imageUrl,
    };
  }

  factory MyUser.fromDocument(DocumentSnapshot doc) {
    final docData = doc.data() as Map<String, dynamic>;

    return MyUser(
      id: doc['id'],
      firstName: doc['first_name'],
      lastName: doc['last_name'],
      email: doc['email'],
      userName: doc['user_name'],
      isDoc: doc['IsDoc'],
      imageUrl: doc['image_url'],
      userType: doc['userType'],
      rate: doc['rate'] == "" ? "0" : doc['rate'],
      countRate: (docData.containsKey("count_rate") ?? false) ? doc['count_rate'] : "0",
      address: (docData.containsKey("address") ?? false) ? doc['address'] : "No Address",
      specialization: (docData.containsKey("specialization") ?? false) ? doc['specialization'] : "No Specialization",
    );
  }

//(doc['rate'].toString() == "") ? '0' : doc['userType']
  //doc['address'] ??
  //doc['specialization' ??]
}

class Doctor {
  final String name;
  final double rate;
  final String address;
  final String imageUrl;
  final String specialization;

  Doctor({
    required this.name,
    required this.rate,
    required this.address,
    required this.imageUrl,
    required this.specialization,
  });

  factory Doctor.fromMap(Map<String, dynamic> data) {
    return Doctor(
      name: data['name'],
      rate: data['rate'],
      address: data['address'],
      imageUrl: data['imageUrl'],
      specialization: data['specialization'],
    );
  }
}
