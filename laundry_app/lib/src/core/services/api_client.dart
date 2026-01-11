// import 'dart:convert';
// import 'package:http/http.dart' as http;
//
// import '../error/exceptions.dart';
//
// class ApiClient {
//   final http.Client client;
//   String? authToken; // Add token if needed
//
//   ApiClient({required this.client});
//
//   void setAuthToken(String? token) {
//     authToken = token;
//   }
//
//   Future<dynamic> get(String url) async {
//     try {
//       print('🌐 API Request: GET $url');
//
//       final headers = {
//         'Content-Type': 'application/json',
//         if (authToken != null) 'Authorization': 'Bearer $authToken',
//       };
//
//       final response = await client.get(
//         Uri.parse(url),
//         headers: headers,
//       ).timeout(
//         const Duration(seconds: 10),
//         onTimeout: () {
//           throw NetworkException('Request timeout');
//         },
//       );
//
//       print('📡 API Response Status: ${response.statusCode}');
//       print('📦 API Response Body: ${response.body}');
//
//       return _handleResponse(response);
//     } on http.ClientException catch (e) {
//       print('❌ Network Error: $e');
//       throw NetworkException('Network error: Cannot connect to server');
//     } catch (e) {
//       print('❌ Unknown Error: $e');
//       throw NetworkException('Network error: $e');
//     }
//   }
//
//   dynamic _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       try {
//         return json.decode(response.body);
//       } catch (e) {
//         print('❌ JSON Parse Error: $e');
//         throw ServerException('Invalid JSON response');
//       }
//     } else {
//       throw ServerException('Server error: ${response.statusCode}');
//     }
//   }
// }

// api_client.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cookie_jar/cookie_jar.dart';

import '../error/exceptions.dart';

class ApiClient {
  final http.Client client;
  final CookieJar cookieJar;
  String? authToken;

  ApiClient({
    required this.client,
    required this.cookieJar, // ADD THIS
  });

  void setAuthToken(String? token) {
    authToken = token;
    print('🔑 Token ${token != null ? "set" : "removed"}');
  }

  Future<dynamic> get(String url) async {
    try {
      print('🌐 API Request: GET $url');

      // Lấy cookies từ CookieJar
      final uri = Uri.parse(url);
      final cookies = await cookieJar.loadForRequest(uri);
      final cookieHeader = cookies.map((c) => '${c.name}=${c.value}').join('; ');

      final headers = {
        'Content-Type': 'application/json',
        if (authToken != null) 'Authorization': 'Bearer $authToken',
        if (cookieHeader.isNotEmpty) 'Cookie': cookieHeader, // ADD THIS
      };

      print('🍪 Cookies being sent: $cookieHeader'); // DEBUG

      final response = await client.get(
        uri,
        headers: headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw NetworkException('Request timeout');
        },
      );

      print('📡 API Response Status: ${response.statusCode}');
      print('📦 API Response Body: ${response.body}');

      return _handleResponse(response);
    } on http.ClientException catch (e) {
      print('❌ Network Error: $e');
      throw NetworkException('Network error: Cannot connect to server');
    } catch (e) {
      print('❌ Unknown Error: $e');
      throw NetworkException('Network error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return json.decode(response.body);
      } catch (e) {
        print('❌ JSON Parse Error: $e');
        throw ServerException('Invalid JSON response');
      }
    } else {
      print('❌ Server Error ${response.statusCode}: ${response.body}');
      throw ServerException('Server error: ${response.statusCode}');
    }
  }
}