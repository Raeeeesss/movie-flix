import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_preferences.dart';

final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier();
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  static const String _boxName = 'user_prefs_box';
  static const String _prefKey = 'user_preferences_json';

  UserPreferencesNotifier() : super(const UserPreferences()) {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final box = await Hive.openBox(_boxName);
      final raw = box.get(_prefKey);
      if (raw != null) {
        final decoded = jsonDecode(raw as String) as Map<String, dynamic>;
        state = UserPreferences.fromJson(decoded);
      }
    } catch (_) {}
  }

  Future<void> _saveState() async {
    try {
      final box = await Hive.openBox(_boxName);
      final encoded = jsonEncode(state.toJson());
      await box.put(_prefKey, encoded);
    } catch (_) {}
  }

  Future<void> saveFullOnboarding(UserPreferences updated) async {
    state = updated.copyWith(isFirstTime: false);
    await _saveState();
  }

  Future<void> updateProfile({
    String? userName,
    String? username,
    String? userEmail,
    String? dob,
    String? gender,
    String? country,
    String? stateRegion,
    String? preferredAppLanguage,
    String? preferredAudioLanguage,
    String? preferredSubtitleLanguage,
    String? avatarUrl,
    List<String>? preferredLanguages,
    List<String>? favoriteGenres,
    List<String>? favoriteIndustries,
    List<String>? favoriteActors,
    List<String>? favoriteActresses,
    List<String>? favoriteDirectors,
  }) async {
    state = state.copyWith(
      userName: userName,
      username: username,
      userEmail: userEmail,
      dob: dob,
      gender: gender,
      country: country,
      stateRegion: stateRegion,
      preferredAppLanguage: preferredAppLanguage,
      preferredAudioLanguage: preferredAudioLanguage,
      preferredSubtitleLanguage: preferredSubtitleLanguage,
      avatarUrl: avatarUrl,
      preferredLanguages: preferredLanguages,
      favoriteGenres: favoriteGenres,
      favoriteIndustries: favoriteIndustries,
      favoriteActors: favoriteActors,
      favoriteActresses: favoriteActresses,
      favoriteDirectors: favoriteDirectors,
    );
    await _saveState();
  }

  Future<void> recordWatchHistory(int movieId) async {
    final updated = [movieId, ...state.watchHistory.where((id) => id != movieId)].take(50).toList();
    state = state.copyWith(watchHistory: updated);
    await _saveState();
  }

  Future<void> updateContinueWatching(int movieId, double progress) async {
    final map = Map<String, double>.from(state.continueWatchingProgress);
    map[movieId.toString()] = progress;
    state = state.copyWith(continueWatchingProgress: map);
    await _saveState();
  }
}
