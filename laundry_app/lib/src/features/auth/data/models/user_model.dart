// import 'package:laundry_app/src/features/auth/domain/entities/user.dart';
//
// class UserModel extends User {
//   UserModel({
//     required super.id,
//     required super.fullName,
//     required super.email,
//     required super.phone,
//     super.image,
//     super.token,
//   });
//
//   factory UserModel.fromJson(Map<String, dynamic> json) {
//     return UserModel(
//       id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
//       fullName: json['fullName'] ?? '',
//       email: json['email'] ?? '',
//       phone: json['phone'] ?? '',
//       image: json['image'],
//       token: json['token'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'fullName': fullName,
//       'email': email,
//       'phone': phone,
//       'image': image,
//       'token': token,
//     };
//   }
//
//   User toEntity() {
//     return User(
//       id: id,
//       fullName: fullName,
//       email: email,
//       phone: phone,
//       image: image,
//       token: token,
//     );
//   }
// }
//
// class AuthResponseModel extends AuthResponse {
//   AuthResponseModel({
//     super.user,
//     required super.message,
//     required super.code,
//     super.otp,
//   });
//
//   // factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
//   //   return AuthResponseModel(
//   //     user: json['data'] != null ? UserModel.fromJson(json['data']) : null,
//   //     message: json['message'] ?? '',
//   //     code: json['code'] ?? 'error',
//   //     otp: json['otp'],
//   //   );
//   // }
//   // Sửa factory AuthResponseModel.fromJson()
//   factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
//     UserModel? user;
//     if (json['user'] != null) {
//       user = UserModel.fromJson(json['user']);
//       // ⬇️ QUAN TRỌNG: Thêm token nếu có trong response
//       if (json['token'] != null) {
//         user = UserModel(
//           id: user.id,
//           fullName: user.fullName,
//           email: user.email,
//           phone: user.phone,
//           image: user.image,
//           token: json['token'], // ⬅️ Lấy token từ response
//         );
//       }
//     }
//
//     return AuthResponseModel(
//       user: user,
//       message: json['message'] ?? '',
//       code: json['code'] ?? 'error',
//       otp: json['otp'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'data': user != null ? (user as UserModel).toJson() : null,
//       'message': message,
//       'code': code,
//       'otp': otp,
//     };
//   }
//
//   AuthResponse toEntity() {
//     return AuthResponse(
//       user: user,
//       message: message,
//       code: code,
//       otp: otp,
//     );
//   }
// }
import 'package:laundry_app/src/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    required super.phone,
    super.image,
    super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'image': image,
      'token': token,
    };
  }

  User toEntity() {
    return User(
      id: id,
      fullName: fullName,
      email: email,
      phone: phone,
      image: image,
      token: token,
    );
  }
}

class AuthResponseModel extends AuthResponse {
  AuthResponseModel({
    super.user,
    required super.message,
    required super.code,
    super.otp,
  });

  // ✅ SỬA LẠI: Backend trả về "user" và "token" ở cùng level
  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    UserModel? user;

    // ✅ CASE 1: Login/Register response
    // Backend trả: { "code": "success", "token": "...", "user": {...} }
    if (json['user'] != null) {
      user = UserModel.fromJson(json['user']);

      // ✅ Gắn token từ response vào user
      if (json['token'] != null) {
        user = UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          image: user.image,
          token: json['token'], // ⬅️ Token ở root level
        );
      }
    }
    // ✅ CASE 2: Profile/Other responses
    // Backend trả: { "code": "success", "data": {...} }
    else if (json['data'] != null) {
      user = UserModel.fromJson(json['data']);

      // Thêm token nếu có trong response
      if (json['token'] != null) {
        user = UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          phone: user.phone,
          image: user.image,
          token: json['token'],
        );
      }
    }

    return AuthResponseModel(
      user: user,
      message: json['message'] ?? '',
      code: json['code'] ?? 'error',
      otp: json['otp'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user != null ? (user as UserModel).toJson() : null,
      'message': message,
      'code': code,
      'otp': otp,
    };
  }

  AuthResponse toEntity() {
    return AuthResponse(
      user: user,
      message: message,
      code: code,
      otp: otp,
    );
  }
}