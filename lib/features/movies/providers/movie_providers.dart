import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/cast_member.dart';
import '../models/video_trailer.dart';
import '../repositories/movie_repository.dart';

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return MovieRepository(apiClient);
});

// ─────────────────────────────────────────────────────────────────────────────
// Home screen category providers
// ─────────────────────────────────────────────────────────────────────────────

final trendingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getTrendingMovies();
});

final trendingWeekMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getTrendingWeekMovies();
});

final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getPopularMovies();
});

final topRatedMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getTopRatedMovies();
});

final nowPlayingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getNowPlayingMovies();
});

final upcomingMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getUpcomingMovies();
});

final actionMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getActionMovies();
});

final comedyMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getComedyMovies();
});

final horrorMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getHorrorMovies();
});

final scifiMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getScifiMovies();
});

final dramaMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getDramaMovies();
});

final animationMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getAnimationMovies();
});

final thrillerMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getThrillerMovies();
});

final awardWinnersProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getAwardWinners();
});

final classicMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getClassicMovies();
});

// Industry & World Cinema Providers
final bollywoodMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getBollywoodMovies();
});

final southMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getSouthMovies();
});

final animeMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getAnimeMovies();
});

final koreanMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getKoreanMovies();
});

final internationalMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  return ref.watch(movieRepositoryProvider).getInternationalMovies();
});

// ─────────────────────────────────────────────────────────────────────────────
// Genres & Filters
// ─────────────────────────────────────────────────────────────────────────────

final movieGenresProvider = FutureProvider<List<Genre>>((ref) async {
  return ref.watch(movieRepositoryProvider).getGenres();
});

final selectedGenreIdProvider = StateProvider<int?>((ref) => null);

// ─────────────────────────────────────────────────────────────────────────────
// Search
// ─────────────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];
  return ref.watch(movieRepositoryProvider).searchMovies(query);
});

// ─────────────────────────────────────────────────────────────────────────────
// Movie Details
// ─────────────────────────────────────────────────────────────────────────────

final movieDetailsProvider = FutureProvider.family<Movie, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieDetails(movieId);
});

final movieCreditsProvider = FutureProvider.family<List<CastMember>, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieCredits(movieId);
});

final movieTrailersProvider = FutureProvider.family<List<VideoTrailer>, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieTrailers(movieId);
});

final movieRecommendationsProvider = FutureProvider.family<List<Movie>, int>((ref, movieId) async {
  return ref.watch(movieRepositoryProvider).getMovieRecommendations(movieId);
});
