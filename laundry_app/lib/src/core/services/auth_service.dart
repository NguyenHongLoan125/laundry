// import 'package:dio/dio.dart';
// import '../di/auth_dependency_injection.dart';
//
// /// Service quản lý thông tin user và authentication state
// class AuthService {
//   // Singleton pattern
//   static final AuthService _instance = AuthService._internal();
//   factory AuthService() => _instance;
//   AuthService._internal();
//
//   String? _cachedUserId;
//
//   /// Lấy userId từ API /auth/me hoặc cache
//   ///
//   /// Flow:
//   /// 1. Kiểm tra cache trước
//   /// 2. Nếu chưa có, gọi API /auth/me
//   /// 3. Cache kết quả để sử dụng cho các lần sau
//   ///
//   /// Throws: Exception nếu không thể lấy userId
//   static Future<String> getCurrentUserId() async {
//     final instance = AuthService();
//
//     // Nếu đã có cache, return luôn
//     if (instance._cachedUserId != null) {
//       print('[AuthService] Using cached userId: ${instance._cachedUserId}');
//       return instance._cachedUserId!;
//     }
//
//     print('[AuthService] Fetching userId from API...');
//
//     try {
//       // Gọi API để lấy thông tin user hiện tại
//       final dio = AuthDI.getDio();
//       final response = await dio.get('/auth/me');
//
//       print('[AuthService] Response status: ${response.statusCode}');
//       print('[AuthService] Response data: ${response.data}');
//
//       if (response.statusCode == 200) {
//         final data = response.data;
//
//         // Parse userId từ response (thử nhiều cấu trúc khác nhau)
//         String? userId = _extractUserId(data);
//
//         if (userId == null || userId.isEmpty) {
//           throw Exception('User ID not found in response');
//         }
//
//         // Cache userId
//         instance._cachedUserId = userId;
//         print('[AuthService] UserId cached successfully: $userId');
//         return userId;
//       }
//
//       throw Exception('Failed to get user info: ${response.statusCode}');
//     } on DioException catch (e) {
//       print('[AuthService] DioException: ${e.message}');
//       if (e.response != null) {
//         print('[AuthService] Response status: ${e.response?.statusCode}');
//         print('[AuthService] Response data: ${e.response?.data}');
//
//         final errorMsg = e.response?.data is Map
//             ? e.response?.data['message'] ?? 'Không thể lấy thông tin user'
//             : 'Không thể lấy thông tin user';
//         throw Exception(errorMsg);
//       }
//       throw Exception('Lỗi kết nối: ${e.message}');
//     } catch (e) {
//       print('[AuthService] Error: $e');
//       rethrow;
//     }
//   }
//
//   /// Extract userId từ response data với nhiều format khác nhau
//   static String? _extractUserId(dynamic data) {
//     if (data is! Map<String, dynamic>) {
//       return null;
//     }
//
//     // Thử các cấu trúc phổ biến
//     final possibilities = [
//       // Format 1: { user: { _id: "..." } }
//       data['user']?['_id'],
//       data['user']?['id'],
//
//       // Format 2: { data: { _id: "..." } }
//       data['data']?['_id'],
//       data['data']?['id'],
//
//       // Format 3: { data: { user: { _id: "..." } } }
//       data['data']?['user']?['_id'],
//       data['data']?['user']?['id'],
//
//       // Format 4: { _id: "..." }
//       data['_id'],
//       data['id'],
//
//       // Format 5: { userId: "..." }
//       data['userId'],
//       data['user_id'],
//     ];
//
//     // Trả về giá trị đầu tiên khác null và không empty
//     for (var possibility in possibilities) {
//       if (possibility != null && possibility.toString().isNotEmpty) {
//         return possibility.toString();
//       }
//     }
//
//     return null;
//   }
//
//   /// Lấy userId đã được cache (không gọi API)
//   ///
//   /// Returns: userId nếu đã cache, null nếu chưa có
//   static String? getCachedUserId() {
//     final cached = AuthService()._cachedUserId;
//     print('[AuthService] Getting cached userId: $cached');
//     return cached;
//   }
//
//   /// Clear cache userId (khi logout)
//   static void clearUserId() {
//     print('[AuthService] Clearing userId cache');
//     AuthService()._cachedUserId = null;
//   }
//
//   /// Set userId manually (sau khi login/register thành công)
//   ///
//   /// Sử dụng khi bạn đã có userId từ login response
//   /// và không cần gọi API /auth/me
//   static void setUserId(String userId) {
//     print('[AuthService] Setting userId: $userId');
//     AuthService()._cachedUserId = userId;
//   }
//
//   /// Kiểm tra xem user đã đăng nhập chưa (có userId cached)
//   static bool get isAuthenticated {
//     return AuthService()._cachedUserId != null;
//   }
// }