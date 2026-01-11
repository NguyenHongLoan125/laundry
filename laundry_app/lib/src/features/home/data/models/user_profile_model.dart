// import '../../domain/entities/user_profile.dart';
//
// class UserProfileModel extends UserProfile {
//   UserProfileModel({
//     required super.id,
//     required super.name,
//     super.email,
//     super.phone,
//   });
//
//   factory UserProfileModel.fromJson(Map<String, dynamic> json) {
//     print('📋 Profile JSON: $json'); // ADD THIS
//
//     return UserProfileModel(
//       id: json['_id'] ?? json['id'] ?? '',
//       name: json['name'] ?? json['fullName'] ?? '',
//       email: json['email'],
//       phone: json['phone'] ?? json['phoneNumber'],
//     );
//   }
// }
//
import '../../domain/entities/user_profile.dart';

class UserProfileModel extends UserProfile {
  UserProfileModel({
    required super.id,
    required super.name,
    super.email,
    super.phone,
    super.address,
    super.image,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    print('📋 Profile JSON: $json');

    return UserProfileModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['fullName'] ?? json['name'] ?? '',
      email: json['email'],
      phone: json['phone'] ?? json['phoneNumber'],
      address: json['address'],
      image: json['image'],
    );
  }
}