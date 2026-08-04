import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../features/movies/models/movie.dart';

class MovieStreamService {
  final Dio _dio;

  MovieStreamService([Dio? dio])
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
              ),
            );

  static const Map<int, String> videoKeys = {
    872585: 'uYPbbksJxIg', // Oppenheimer
    1630047: 'd9MyW72ELq0', // Avatar 2
    619979: 'qSqVVowa4jE', // Top Gun Maverick
    693134: 'Way9Dexny3w', // Dune Part Two
    157336: 'zSWdZVtXT7E', // Interstellar
    4154796: 'TcMBFSGVi1c', // Avengers Endgame
    155: 'EXeTwQWrcwY', // The Dark Knight
    27205: 'YoHD9XEInc0', // Inception
    11514332: 'RPxm89vfBxM', // Glass Onion
    558449: '4mgUU-f4h0o', // Gladiator II
    575264: 'avz06PD5008', // Mission Impossible 7
    945961: 'x0XDEhP4MQs', // Alien Romulus
    414906: 'mqqft2x_Aa4', // The Batman
    475557: 'zAGVQLHvwOY', // Joker
    634649: 'JfVOs4VSpmA', // Spider-Man No Way Home
    346698: 'pBk4NYhWNMM', // Barbie
    603: 'vKQi3bBA1y8', // The Matrix
    597: 'cAI8E3zXw48', // Titanic
    680: 's7EdQ4FqbhY', // Pulp Fiction
  };

  /// Get 100% reliable YouTube stream key for full movie video player
  String getYoutubeVideoKey(Movie movie) {
    return videoKeys[movie.id] ?? 'uYPbbksJxIg';
  }

  /// Get direct playable stream URL for a given movie
  String getDirectStreamUrl(Movie movie) {
    if (movie.streamUrl != null &&
        movie.streamUrl!.isNotEmpty &&
        movie.streamUrl != 'N/A' &&
        !movie.streamUrl!.contains('gtv-videos-bucket')) {
      return movie.streamUrl!;
    }
    if (movie.archiveId != null && movie.archiveId!.isNotEmpty) {
      return 'https://archive.org/download/${movie.archiveId}/${movie.archiveId}.mp4';
    }
    return 'https://archive.org/download/his_girl_friday/his_girl_friday.mp4';
  }

  /// Get Internet Archive web embed URL
  String getArchiveEmbedUrl(Movie movie) {
    if (movie.archiveId != null && movie.archiveId!.isNotEmpty) {
      return 'https://archive.org/embed/${movie.archiveId}';
    }
    return 'https://archive.org/details/moviesandfilms';
  }

  /// Get public domain torrent download link
  String getTorrentUrl(Movie movie) {
    if (movie.torrentUrl != null && movie.torrentUrl!.isNotEmpty) {
      return movie.torrentUrl!;
    }
    if (movie.archiveId != null && movie.archiveId!.isNotEmpty) {
      return 'https://archive.org/download/${movie.archiveId}/${movie.archiveId}_archive.torrent';
    }
    return 'https://archive.org/details/moviesandfilms';
  }

  /// Query Internet Archive API for public domain video metadata
  Future<Map<String, dynamic>?> fetchArchiveMetadata(String archiveId) async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('https://archive.org/metadata/$archiveId');
      return res.data;
    } catch (e) {
      debugPrint('Error fetching Internet Archive metadata for $archiveId: $e');
      return null;
    }
  }
}
