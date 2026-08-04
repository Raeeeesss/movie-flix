import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/watchlist_item.dart';
import '../repositories/watchlist_repository.dart';
import '../../movies/models/movie.dart';

final watchlistRepositoryProvider = Provider<WatchlistRepository>((ref) {
  return WatchlistRepository();
});

class WatchlistNotifier extends StateNotifier<AsyncValue<List<WatchlistItem>>> {
  final WatchlistRepository _repository;

  WatchlistNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadWatchlist();
  }

  Future<void> loadWatchlist() async {
    try {
      state = const AsyncValue.loading();
      final items = await _repository.getWatchlist();
      state = AsyncValue.data(items);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggleWatchlist(Movie movie) async {
    await _repository.toggleWatchlist(movie);
    await loadWatchlist();
  }

  Future<void> removeFromWatchlist(int movieId) async {
    await _repository.remove(movieId);
    await loadWatchlist();
  }

  Future<void> clearWatchlist() async {
    await _repository.clearWatchlist();
    await loadWatchlist();
  }

  bool isWatchlisted(int movieId) {
    final list = state.asData?.value ?? [];
    return list.any((item) => item.id == movieId);
  }
}

final watchlistProvider =
    StateNotifierProvider<WatchlistNotifier, AsyncValue<List<WatchlistItem>>>((ref) {
  final repo = ref.watch(watchlistRepositoryProvider);
  return WatchlistNotifier(repo);
});
