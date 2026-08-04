import 'package:hive_flutter/hive_flutter.dart';
import '../models/watchlist_item.dart';
import '../../movies/models/movie.dart';

class WatchlistRepository {
  static const String boxName = 'watchlist_box';

  Future<Box<WatchlistItem>> _getBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<WatchlistItem>(boxName);
    }
    return Hive.box<WatchlistItem>(boxName);
  }

  Future<List<WatchlistItem>> getWatchlist() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<bool> isWatchlisted(int movieId) async {
    final box = await _getBox();
    return box.containsKey(movieId);
  }

  Future<void> toggleWatchlist(Movie movie) async {
    final box = await _getBox();
    if (box.containsKey(movie.id)) {
      await box.delete(movie.id);
    } else {
      final item = WatchlistItem.fromMovie(movie);
      await box.put(movie.id, item);
    }
  }

  Future<void> remove(int movieId) async {
    final box = await _getBox();
    await box.delete(movieId);
  }

  Future<void> clearWatchlist() async {
    final box = await _getBox();
    await box.clear();
  }
}
