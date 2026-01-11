// class UserProfile {
//   final String id;
//   final String name;
//   final String? email;
//   final String? phone;
//
//   UserProfile({
//     required this.id,
//     required this.name,
//     this.email,
//     this.phone,
//   });
// }
class UserProfile {
  final String id;
  final String name;
  final String? email;
  final String? phone;
  final String? address;
  final String? image;

  UserProfile({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.address,
    this.image,
  });
}