import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract final class AppHttp {
  // Configuration
  static late final String _baseUrl;
  static const Duration _timeout = Duration(seconds: 30);
  static final Map<String, String> _defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  /// Initialize in main.dart
  static void configure({
    required String baseUrl,
    Map<String, String>? defaultHeaders,
  }) {
    _baseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    if (defaultHeaders != null) _defaultHeaders.addAll(defaultHeaders);
  }

  // ================
  // Public Methods
  // ================

  static Future<void> get(
      String endpoint, {
        required void Function(dynamic) onSuccess,
        required void Function(String) onError,
        Map<String, String>? headers,
        Map<String, dynamic>? query,
      }) async {
    await _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      onSuccess: onSuccess,
      onError: onError,
      headers: headers,
      query: query,
    );
  }

  static Future<void> post(
      String endpoint, {
        required void Function(dynamic) onSuccess,
        required void Function(String) onError,
        Map<String, String>? headers,
        dynamic body,
        List<File>? files,
        String fileField = 'file',
      }) async {
    await _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      onSuccess: onSuccess,
      onError: onError,
      headers: headers,
      body: body,
      files: files,
      fileField: fileField,
    );
  }

  static Future<void> put(
      String endpoint, {
        required void Function(dynamic) onSuccess,
        required void Function(String) onError,
        Map<String, String>? headers,
        dynamic body,
        List<File>? files,
        String fileField = 'file',
      }) async {
    await _sendRequest(
      method: 'PUT',
      endpoint: endpoint,
      onSuccess: onSuccess,
      onError: onError,
      headers: headers,
      body: body,
      files: files,
      fileField: fileField,
    );
  }

  static Future<void> delete(
      String endpoint, {
        required void Function(dynamic) onSuccess,
        required void Function(String) onError,
        Map<String, String>? headers,
        dynamic body,
      }) async {
    await _sendRequest(
      method: 'DELETE',
      endpoint: endpoint,
      onSuccess: onSuccess,
      onError: onError,
      headers: headers,
      body: body,
    );
  }

  // ================
  // Core Logic
  // ================

  static Future<void> _sendRequest({
    required String method,
    required String endpoint,
    required void Function(dynamic) onSuccess,
    required void Function(String) onError,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    dynamic body,
    List<File>? files,
    String fileField = 'file',
  }) async {
    try {
      // Build URI
      final uri = Uri.parse('$_baseUrl/${_cleanEndpoint(endpoint)}')
          .replace(queryParameters: _stringifyQuery(query));

      // Handle file uploads
      if (files != null && files.isNotEmpty) {
        var request = http.MultipartRequest(method, uri);

        // Add headers
        request.headers.addAll({..._defaultHeaders, ...?headers});

        // Add files
        for (var file in files) {
          var mimeType = _getMimeType(file.path);
          request.files.add(await http.MultipartFile.fromPath(
            fileField,
            file.path,
            contentType: MediaType.parse(mimeType),
          ));
        }

        // Add other fields
        if (body is Map) {
          body.forEach((key, value) {
            if (value != null) request.fields[key.toString()] = value.toString();
          });
        }

        // Send and handle response
        final response = await request.send().timeout(_timeout);
        final responseBody = await response.stream.bytesToString();
        _handleResponse(
          http.Response(responseBody, response.statusCode),
          onSuccess,
          onError,
        );
        return;
      }

      // Normal JSON request
      final requestHeaders = {
        ..._defaultHeaders,
        if (body != null) 'Content-Type': 'application/json',
        ...?headers,
      };

      final response = await _executeRequest(
        method: method,
        uri: uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );

      _handleResponse(response, onSuccess, onError);
    } catch (e) {
      _handleError(e, onError);
    }
  }

  static Future<http.Response> _executeRequest({
    required String method,
    required Uri uri,
    required Map<String, String> headers,
    required String? body,
  }) async {
    switch (method) {
      case 'GET':
        return await http.get(uri, headers: headers).timeout(_timeout);
      case 'POST':
        return await http.post(uri, headers: headers, body: body).timeout(_timeout);
      case 'PUT':
        return await http.put(uri, headers: headers, body: body).timeout(_timeout);
      case 'DELETE':
        return await http.delete(uri, headers: headers, body: body).timeout(_timeout);
      default:
        throw 'Unsupported HTTP method: $method';
    }
  }

  static void _handleResponse(
      http.Response response,
      void Function(dynamic) onSuccess,
      void Function(String) onError,
      ) {
    try {
      final decoded = jsonDecode(response.body);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        onSuccess(decoded);
      } else {
        onError(decoded['error']?.toString() ??
            decoded['message']?.toString() ??
            'Request failed with status ${response.statusCode}');
      }
    } catch (_) {
      onError('Invalid response: ${response.body}');
    }
  }

  static void _handleError(dynamic error, void Function(String) onError) {
    if (error is http.ClientException) {
      onError('Network error: ${error.message}');
    } else if (error is TimeoutException) {
      onError('Request timed out');
    } else {
      onError('Unexpected error: ${error.toString()}');
    }
  }

  // ================
  // Helpers
  // ================

  static String _cleanEndpoint(String endpoint) =>
      endpoint.startsWith('/') ? endpoint.substring(1) : endpoint;

  static Map<String, String>? _stringifyQuery(Map<String, dynamic>? query) =>
      query?.map((k, v) => MapEntry(k, v?.toString() ?? ''));

  static String _getMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg': case 'jpeg': return 'image/jpeg';
      case 'png': return 'image/png';
      case 'gif': return 'image/gif';
      case 'pdf': return 'application/pdf';
      case 'txt': return 'text/plain';
      case 'mp4': return 'video/mp4';
      default: return 'application/octet-stream';
    }
  }
}