import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/movies/models/movie.dart';
import '../../features/movies/providers/movie_providers.dart';
import '../../features/user/models/user_preferences.dart';
import '../../features/user/providers/user_preferences_provider.dart';

/// Recommendation Scoring Matrix according to exact user priority order
int scoreMovie(Movie movie, UserPreferences prefs) {
  int score = 0;

  final titleLower = movie.title.toLowerCase();
  final overviewLower = movie.overview.toLowerCase();

  // Priority 1 & 2: Industry & Language Match (+50 / +40)
  for (final ind in prefs.favoriteIndustries) {
    final indLower = ind.toLowerCase();
    if (overviewLower.contains(indLower) || titleLower.contains(indLower)) {
      score += 50;
    }
  }

  for (final lang in prefs.preferredLanguages) {
    final langLower = lang.toLowerCase();
    if (overviewLower.contains(langLower) || titleLower.contains(langLower)) {
      score += 40;
    }
  }

  // Priority 3: Favorite Actor Match (+30)
  for (final actor in prefs.favoriteActors) {
    final actorLower = actor.toLowerCase();
    if (overviewLower.contains(actorLower) || titleLower.contains(actorLower)) {
      score += 30;
    }
  }

  // Priority 4: Favorite Actress Match (+25)
  for (final actress in prefs.favoriteActresses) {
    final actressLower = actress.toLowerCase();
    if (overviewLower.contains(actressLower) || titleLower.contains(actressLower)) {
      score += 25;
    }
  }

  // Priority 5: Favorite Director Match (+20)
  for (final director in prefs.favoriteDirectors) {
    final dirLower = director.toLowerCase();
    if (overviewLower.contains(dirLower) || titleLower.contains(dirLower)) {
      score += 20;
    }
  }

  // Priority 6: Genre Match (+15)
  for (final g in movie.genres) {
    if (prefs.favoriteGenres.any((fg) => fg.toLowerCase() == g.name.toLowerCase())) {
      score += 15;
    }
  }

  // Highly Rated (+5)
  if (movie.voteAverage >= 7.5) score += 5;
  if (movie.voteAverage >= 8.5) score += 5;

  // Priority 7: Watch History Similarity (+10)
  if (prefs.watchHistory.contains(movie.id)) {
    score += 10;
  }

  return score;
}

/// ⭐ Section 1: AI Recommended Movies (Scored & Ranked)
final aiRecommendedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  String query = 'malayalam';
  if (prefs.favoriteActors.isNotEmpty) {
    query = prefs.favoriteActors.first.toLowerCase();
  } else if (prefs.preferredLanguages.isNotEmpty) {
    query = prefs.preferredLanguages.first.toLowerCase();
  }

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});

/// ⭐ Section 2: Because You Like [Favorite Actor]
final becauseYouWatchedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  String query = 'mohanlal';
  if (prefs.favoriteActors.isNotEmpty) {
    query = prefs.favoriteActors.first.toLowerCase();
  }

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});

/// ⭐ Section 3: Movies Starring [Favorite Actress]
final actressPersonalizedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  String query = 'sai pallavi';
  if (prefs.favoriteActresses.isNotEmpty) {
    query = prefs.favoriteActresses.first.toLowerCase();
  }

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});

/// ⭐ Section 4: Popular in [Preferred Language]
final popularInLanguageMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  String query = 'malayalam';
  if (prefs.preferredLanguages.isNotEmpty) {
    query = prefs.preferredLanguages.first.toLowerCase();
  }

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});

/// ⭐ Section 5: Directed by [Favorite Director]
final directorPersonalizedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  String query = 'lijo jose pellissery';
  if (prefs.favoriteDirectors.isNotEmpty) {
    query = prefs.favoriteDirectors.first.toLowerCase();
  }

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});

/// ⭐ Section 6: [Language] [Genre] Blockbusters
final genreLanguagePersonalizedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final prefs = ref.watch(userPreferencesProvider);
  final repo = ref.watch(movieRepositoryProvider);

  final lang = prefs.preferredLanguages.isNotEmpty ? prefs.preferredLanguages.first.toLowerCase() : 'malayalam';
  final genre = prefs.favoriteGenres.isNotEmpty ? prefs.favoriteGenres.first.toLowerCase() : 'action';
  final query = '$lang $genre';

  final movies = await repo.fetchCategory(query, page: 1);
  movies.sort((a, b) => scoreMovie(b, prefs).compareTo(scoreMovie(a, prefs)));
  return movies;
});
