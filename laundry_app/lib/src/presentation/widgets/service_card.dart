// // // import 'package:flutter/material.dart';
// // // import 'package:laundry_app/src/core/constants/app_colors.dart';
// // // import 'package:laundry_app/src/features/service/domain/entities/service.dart';
// // //
// // // class ServiceCard extends StatelessWidget {
// // //   final Service service;
// // //
// // //   const ServiceCard({super.key, required this.service});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Container(
// // //       margin: EdgeInsets.only(bottom: 12),
// // //       padding: EdgeInsets.all(16),
// // //       decoration: BoxDecoration(
// // //         color: AppColors.backgroundThird,
// // //         borderRadius: BorderRadius.circular(12),
// // //         border: Border.all(color: AppColors.primary),
// // //       ),
// // //       child: Row(
// // //         children: [
// // //           Image.asset(
// // //             service.icon,
// // //             width: 48,
// // //             height: 48,
// // //             errorBuilder: (context, error, stackTrace) {
// // //               return Container(
// // //                 width: 48,
// // //                 height: 48,
// // //                 decoration: BoxDecoration(
// // //                   color: AppColors.primary.withOpacity(0.1),
// // //                   borderRadius: BorderRadius.circular(8),
// // //                 ),
// // //                 child: Icon(Icons.local_laundry_service, color: AppColors.primary),
// // //               );
// // //             },
// // //           ),
// // //           SizedBox(width: 16),
// // //           Expanded(
// // //             child: Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   service.name,
// // //                   style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: AppColors.textPrimary,
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 4),
// // //                 Text(
// // //                   service.description,
// // //                   style: TextStyle(
// // //                     fontSize: 13,
// // //                     color: Colors.grey[700],
// // //                   ),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
// // import 'package:flutter/material.dart';
// // import 'package:laundry_app/src/core/constants/app_colors.dart';
// // import 'package:laundry_app/src/features/service/domain/entities/service.dart';
// //
// // class ServiceCard extends StatelessWidget {
// //   final Service service;
// //   final String myFont = 'Pacifico';
// //
// //   const ServiceCard({super.key, required this.service});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: [
// //           BoxShadow(
// //             color: Colors.black.withOpacity(0.05),
// //             blurRadius: 10,
// //             offset: Offset(0, 2),
// //           ),
// //         ],
// //       ),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           // Header với gradient
// //           Container(
// //             padding: EdgeInsets.all(16),
// //             decoration: BoxDecoration(
// //               gradient: LinearGradient(
// //                 begin: Alignment.topLeft,
// //                 end: Alignment.bottomRight,
// //                 colors: [
// //                   AppColors.primary,
// //                   AppColors.primary.withOpacity(0.7),
// //                 ],
// //               ),
// //               borderRadius: BorderRadius.only(
// //                 topLeft: Radius.circular(16),
// //                 topRight: Radius.circular(16),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 // Icon
// //                 Container(
// //                   padding: EdgeInsets.all(12),
// //                   decoration: BoxDecoration(
// //                     color: Colors.white.withOpacity(0.2),
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                   child: Icon(
// //                     _getServiceIcon(service.name),
// //                     color: Colors.white,
// //                     size: 28,
// //                   ),
// //                 ),
// //                 SizedBox(width: 16),
// //                 // Service name
// //                 Expanded(
// //                   child: Text(
// //                     service.name,
// //                     style: TextStyle(
// //                       fontFamily: myFont,
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.white,
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //
// //           // Content
// //           Padding(
// //             padding: EdgeInsets.all(16),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 // Description
// //                 if (service.description.isNotEmpty)
// //                   Column(
// //                     children: [
// //                       Row(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Icon(
// //                             Icons.info_outline,
// //                             size: 18,
// //                             color: AppColors.primary,
// //                           ),
// //                           SizedBox(width: 8),
// //                           Expanded(
// //                             child: Text(
// //                               service.description,
// //                               style: TextStyle(
// //                                 fontFamily: myFont,
// //                                 fontSize: 14,
// //                                 color: AppColors.textSecondary,
// //                                 height: 1.4,
// //                               ),
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                       SizedBox(height: 12),
// //                     ],
// //                   ),
// //
// //                 // Duration
// //                 if (service.duration != null && service.duration!.isNotEmpty)
// //                   Row(
// //                     children: [
// //                       Container(
// //                         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
// //                         decoration: BoxDecoration(
// //                           color: AppColors.primary.withOpacity(0.1),
// //                           borderRadius: BorderRadius.circular(8),
// //                         ),
// //                         child: Row(
// //                           children: [
// //                             Icon(
// //                               Icons.access_time,
// //                               size: 16,
// //                               color: AppColors.primary,
// //                             ),
// //                             SizedBox(width: 6),
// //                             Text(
// //                               service.duration!,
// //                               style: TextStyle(
// //                                 fontFamily: myFont,
// //                                 fontSize: 13,
// //                                 color: AppColors.primary,
// //                                 fontWeight: FontWeight.w600,
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   IconData _getServiceIcon(String serviceName) {
// //     final name = serviceName.toLowerCase();
// //     if (name.contains('giặt') && name.contains('sấy')) {
// //       return Icons.local_laundry_service;
// //     } else if (name.contains('giặt') && name.contains('hấp')) {
// //       return Icons.iron;
// //     } else if (name.contains('ủi')) {
// //       return Icons.iron_outlined;
// //     } else if (name.contains('tẩy')) {
// //       return Icons.cleaning_services;
// //     } else if (name.contains('vá')) {
// //       return Icons.content_cut;
// //     } else {
// //       return Icons.local_laundry_service;
// //     }
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:laundry_app/src/core/constants/app_colors.dart';
// import 'package:laundry_app/src/features/service/domain/entities/service.dart';
//
// class ServiceCard extends StatelessWidget {
//   final Service service;
//   final String myFont = 'Pacifico';
//
//   const ServiceCard({super.key, required this.service});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 12,
//             offset: Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon
//             Container(
//               width: 56,
//               height: 56,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(14),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.25),
//                     blurRadius: 8,
//                     offset: Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 _getServiceIcon(service.name),
//                 color: Colors.white,
//                 size: 28,
//               ),
//             ),
//
//             SizedBox(width: 16),
//
//             // Content
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Service name
//                   Text(
//                     service.name,
//                     style: TextStyle(
//                       fontFamily: myFont,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: AppColors.textPrimary,
//                     ),
//                   ),
//
//                   SizedBox(height: 8),
//
//                   // Description
//                   if (service.description.isNotEmpty)
//                     Text(
//                       service.description,
//                       style: TextStyle(
//                         fontFamily: myFont,
//                         fontSize: 13,
//                         color: AppColors.textSecondary,
//                         height: 1.5,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//
//                   // Duration
//                   if (service.duration != null && service.duration!.isNotEmpty) ...[
//                     SizedBox(height: 12),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.access_time_rounded,
//                           size: 16,
//                           color: AppColors.primary,
//                         ),
//                         SizedBox(width: 6),
//                         Text(
//                           service.duration!,
//                           style: TextStyle(
//                             fontFamily: myFont,
//                             fontSize: 13,
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   IconData _getServiceIcon(String serviceName) {
//     final name = serviceName.toLowerCase();
//     if (name.contains('giặt') && name.contains('sấy')) {
//       return Icons.local_laundry_service_rounded;
//     } else if (name.contains('giặt') && name.contains('hấp')) {
//       return Icons.iron_rounded;
//     } else if (name.contains('ủi')) {
//       return Icons.iron_outlined;
//     } else if (name.contains('tẩy')) {
//       return Icons.cleaning_services_rounded;
//     } else if (name.contains('vá')) {
//       return Icons.content_cut_rounded;
//     } else {
//       return Icons.local_laundry_service_rounded;
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:laundry_app/src/core/constants/app_colors.dart';
import 'package:laundry_app/src/features/service/domain/entities/service.dart';

class ServiceCard extends StatelessWidget {
  final Service service;
  final String myFont = 'Pacifico';

  const ServiceCard({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(
                _getServiceIcon(service.name),
                color: Colors.white,
                size: 28,
              ),
            ),

            SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service name
                  Text(
                    service.name,
                    style: TextStyle(
                      fontFamily: myFont,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: 8),

                  // Description
                  if (service.description.isNotEmpty)
                    Text(
                      service.description,
                      style: TextStyle(
                        fontFamily: myFont,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                  // Duration
                  if (service.duration != null && service.duration!.isNotEmpty) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 6),
                        Text(
                          service.duration!,
                          style: TextStyle(
                            fontFamily: myFont,
                            fontSize: 13,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getServiceIcon(String serviceName) {
    final name = serviceName.toLowerCase();
    if (name.contains('giặt') && name.contains('sấy')) {
      return Icons.local_laundry_service_rounded;
    } else if (name.contains('giặt') && name.contains('hấp')) {
      return Icons.iron_rounded;
    } else if (name.contains('ủi')) {
      return Icons.iron_outlined;
    } else if (name.contains('tẩy')) {
      return Icons.cleaning_services_rounded;
    } else if (name.contains('vá')) {
      return Icons.content_cut_rounded;
    } else {
      return Icons.local_laundry_service_rounded;
    }
  }
}