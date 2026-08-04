import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';

class ApiClient {
  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );
  }

  /// Search IMDb directly via official suggestion search API
  Future<List<Map<String, dynamic>>> searchImdb(String query) async {
    final cleanQ = query.trim().toLowerCase();
    if (cleanQ.isEmpty) return [];

    final firstChar = cleanQ[0];
    final url = '${ApiConstants.imdbBaseUrl}$firstChar/${Uri.encodeComponent(cleanQ)}.json';

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        url,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          },
        ),
      );

      final data = response.data;
      if (data != null && data['d'] is List) {
        final list = data['d'] as List;
        return list
            .cast<Map<String, dynamic>>()
            .where((item) =>
                item['l'] != null &&
                item['i']?['imageUrl'] != null &&
                (item['qid'] == 'movie' || item['q'] == 'feature'))
            .toList();
      }
    } catch (e) {
      debugPrint('IMDb search error for "$query": $e');
    }
    return [];
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final fullUrl = path.startsWith('http') ? path : '${ApiConstants.imdbBaseUrl}$path';
      final response = await _dio.get<T>(
        fullUrl,
        queryParameters: queryParameters,
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['Error'] ?? 'Network error occurred connecting to IMDb.',
      );
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
