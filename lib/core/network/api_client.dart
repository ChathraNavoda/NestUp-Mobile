import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  String? _token;

  ApiClient({required this.baseUrl});

  void setToken(String token) {
    _token = token;
  }

  Future<dynamic> get(String endpoint) async {
    print('[ApiClient] GET called: $endpoint, token=$_token');
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null && _token!.isNotEmpty)
          'Authorization': 'Bearer $_token',
      },
    );
    print('[ApiClient] GET response status: ${response.statusCode}');
    print('[ApiClient] GET response body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('GET $endpoint failed: ${response.statusCode}');
    }
  }

  Future<dynamic> post(String endpoint, {Map<String, dynamic>? data}) async {
    print('[ApiClient] POST called: $endpoint, data=$data, token=$_token');

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null && _token!.isNotEmpty)
          'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(data),
    );

    print('[ApiClient] POST response status: ${response.statusCode}');
    print('[ApiClient] POST response body: ${response.body}');

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('POST $endpoint failed: ${response.statusCode}');
    }
  }
}
