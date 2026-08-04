import 'genre.dart';

class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  final int runtime;
  final String language;
  final List<int> genreIds;
  final List<Genre> genres;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.runtime = 0,
    this.language = 'Malayalam',
    this.genreIds = const [],
    this.genres = const [],
  });

  static const String fallbackBackdrop =
      'https://images.unsplash.com/photo-1517604931442-7e0c8ed2963c?auto=format&fit=crop&w=1200&q=80';
  static const String fallbackPoster =
      'https://images.unsplash.com/photo-1478720568477-152d9b164e26?auto=format&fit=crop&w=1200&q=80';

  String get posterUrl {
    if (posterPath == null || posterPath!.isEmpty || posterPath == 'N/A') {
      return fallbackPoster;
    }
    if (posterPath!.contains('._V1_') && !posterPath!.contains('SX1200')) {
      return posterPath!.replaceAll(RegExp(r'._V1_.*\.jpg'), '._V1_SX1200.jpg');
    }
    return posterPath!;
  }

  String get backdropUrl {
    if (backdropPath != null && backdropPath!.isNotEmpty && backdropPath != 'N/A') {
      if (backdropPath!.contains('._V1_') && !backdropPath!.contains('SX1200')) {
        return backdropPath!.replaceAll(RegExp(r'._V1_.*\.jpg'), '._V1_SX1200.jpg');
      }
      if (backdropPath!.startsWith('http')) return backdropPath!;
    }
    if (posterPath != null && posterPath!.isNotEmpty && posterPath != 'N/A') {
      if (posterPath!.contains('._V1_') && !posterPath!.contains('SX1200')) {
        return posterPath!.replaceAll(RegExp(r'._V1_.*\.jpg'), '._V1_SX1200.jpg');
      }
      if (posterPath!.startsWith('http')) return posterPath!;
    }
    return fallbackBackdrop;
  }

  String get year {
    if (releaseDate.length >= 4) {
      return releaseDate.substring(0, 4);
    }
    return 'N/A';
  }

  String? get formattedRating => voteAverage > 0 ? voteAverage.toStringAsFixed(1) : null;

  String get displayRating => formattedRating ?? 'N/A';

  String get formattedDuration {
    if (runtime <= 0) return 'N/A';
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    final imdbId = json['imdbID'] as String? ?? 'tt0000000';
    final numericId = int.tryParse(imdbId.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final runtimeStr = json['Runtime'] as String? ?? '0 min';
    final runtime = int.tryParse(runtimeStr.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;

    final ratingStr = json['imdbRating'] as String? ?? '0';
    final rating = double.tryParse(ratingStr) ?? 0.0;

    final posterRaw = json['Poster'] as String? ?? '';
    final poster = (posterRaw.isEmpty || posterRaw == 'N/A') ? null : posterRaw;

    final genreStr = json['Genre'] as String? ?? '';
    final genres = genreStr
        .split(',')
        .map((g) => g.trim())
        .where((g) => g.isNotEmpty && g != 'N/A')
        .map((g) => Genre(id: g.hashCode.abs(), name: g))
        .toList();

    final released = json['Released'] as String? ?? '';
    final year = json['Year'] as String? ?? '';
    final releaseDate = (released.isNotEmpty && released != 'N/A') ? released : year;

    return Movie(
      id: numericId,
      title: json['Title'] as String? ?? json['name'] as String? ?? 'Untitled',
      overview: json['Plot'] as String? ?? 'No overview available.',
      posterPath: poster,
      backdropPath: poster,
      voteAverage: rating,
      releaseDate: releaseDate,
      runtime: runtime,
      language: json['language'] as String? ?? json['Language'] as String? ?? 'Malayalam',
      genreIds: genres.map((g) => g.id).toList(),
      genres: genres,
    );
  }

  factory Movie.fromImdbJson(Map<String, dynamic> json) {
    final imdbId = json['id'] as String? ?? 'tt0000000';
    final numericId = int.tryParse(imdbId.replaceAll(RegExp(r'[^0-9]'), '')) ?? imdbId.hashCode.abs();
    final title = json['l'] as String? ?? json['Title'] as String? ?? 'Untitled';
    final year = json['y']?.toString() ?? json['Year']?.toString() ?? '';
    final stars = json['s'] as String? ?? '';
    final rawImg = (json['i']?['imageUrl'] as String?) ?? json['Poster'] as String?;
    final lang = json['language'] as String? ?? json['Language'] as String? ?? 'Malayalam';

    String? poster;
    if (rawImg != null && rawImg.isNotEmpty && rawImg != 'N/A') {
      poster = rawImg.contains('._V1_')
          ? rawImg.replaceAll(RegExp(r'._V1_.*\.jpg'), '._V1_SX1200.jpg')
          : rawImg;
    }

    return Movie(
      id: numericId,
      title: title,
      overview: stars.isNotEmpty ? 'Starring $stars' : '',
      posterPath: poster,
      backdropPath: poster,
      voteAverage: 8.0,
      releaseDate: year,
      language: lang,
    );
  }

  factory Movie.fromSearchJson(Map<String, dynamic> json) {
    return Movie.fromImdbJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
      'runtime': runtime,
      'language': language,
      'genre_ids': genreIds,
      'genres': genres.map((g) => g.toJson()).toList(),
    };
  }
}
