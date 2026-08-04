import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../services/people_database.dart';

class LocalBackendServer {
  static HttpServer? _server;
  static int port = 8088;
  static bool _isRunning = false;

  static bool get isRunning => _isRunning;

  static Future<void> startServer() async {
    if (_isRunning) return;
    try {
      _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
      _isRunning = true;
      debugPrint('🚀 [LocalBackendServer] Running at http://127.0.0.1:$port');

      _server!.listen((HttpRequest request) async {
        try {
          final path = request.uri.path;
          request.response.headers.set('Access-Control-Allow-Origin', '*');
          request.response.headers.set('Content-Type', 'application/json');

          if (path == '/api/health') {
            request.response.write(jsonEncode({'status': 'online', 'server': 'CineStream AI Local Server'}));
          } else if (path == '/api/people') {
            final role = request.uri.queryParameters['role'] ?? 'actor';
            final industry = request.uri.queryParameters['industry'] ?? 'Mollywood';
            final list = PeopleDatabase.getPeopleForIndustries(
              industries: [industry],
              role: role,
            );
            final data = list.map((p) => {
              'id': p.id,
              'name': p.name,
              'industry': p.industry,
              'role': p.role,
              'profileUrl': p.profileUrl,
              'knownMovies': p.knownMovies,
            }).toList();
            request.response.write(jsonEncode({'success': true, 'data': data}));
          } else if (path == '/api/recommendations') {
            request.response.write(jsonEncode({
              'success': true,
              'engine': 'CineStream AI Neural Scorer v2.5',
              'status': 'active',
            }));
          } else {
            request.response.write(jsonEncode({'success': true, 'message': 'CineStream Local Server'}));
          }
        } catch (e) {
          request.response.statusCode = 500;
          request.response.write(jsonEncode({'error': e.toString()}));
        } finally {
          await request.response.close();
        }
      });
    } catch (e) {
      debugPrint('⚠️ [LocalBackendServer] Startup note: $e');
    }
  }

  static Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _isRunning = false;
      _server = null;
    }
  }
}
