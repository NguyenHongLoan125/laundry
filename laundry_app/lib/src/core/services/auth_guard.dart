// // auth_guard.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../presentation/controllers/auth_controller.dart';
//
// class AuthGuard extends StatelessWidget {
//   final Widget child;
//
//   const AuthGuard({Key? key, required this.child}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final authController = Provider.of<AuthController>(context, listen: true);
//
//     // Nếu đang loading session
//     if (authController.isLoading) {
//       return Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     // Nếu chưa đăng nhập, chuyển sang Login
//     if (!authController.isLoggedIn) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Navigator.of(context).pushReplacementNamed('/login');
//       });
//       return Scaffold(body: SizedBox.shrink());
//     }
//
//     // Đã đăng nhập, hiển thị child
//     return child;
//   }
// }