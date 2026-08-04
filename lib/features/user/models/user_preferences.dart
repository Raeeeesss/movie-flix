class UserPreferences {
  final bool isFirstTime;
  final String userName;
  final String phoneNumber;
  final String username;
  final String userEmail;
  final String dob;
  final String gender;
  final String country;
  final String stateRegion;
  final String timeZone;
  final String avatarUrl;
  final String membershipType;

  final String preferredAppLanguage;
  final String preferredAudioLanguage;
  final String preferredSubtitleLanguage;

  final List<String> preferredLanguages;
  final List<String> favoriteIndustries;
  final List<String> favoriteGenres;
  final List<String> favoriteActors;
  final List<String> favoriteActresses;
  final List<String> favoriteDirectors;
  final List<String> contentTypes;

  final String watchingHabit;
  final String preferredMovieLength;
  final String favoriteDecade;
  final String streamingQuality;
  final String watchContext;
  final bool notificationsEnabled;

  final List<int> watchHistory;
  final Map<String, double> continueWatchingProgress;

  const UserPreferences({
    this.isFirstTime = true,
    this.userName = 'Cinematic Explorer',
    this.phoneNumber = '+91 98765 43210',
    this.username = 'cinephile_01',
    this.userEmail = 'explorer@cinestream.ai',
    this.dob = '1998-05-15',
    this.gender = 'Prefer not to say',
    this.country = 'India',
    this.stateRegion = 'Kerala',
    this.timeZone = 'IST (UTC+5:30)',
    this.avatarUrl = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
    this.membershipType = 'VIP Platinum Access',
    this.preferredAppLanguage = 'English',
    this.preferredAudioLanguage = 'Original / English',
    this.preferredSubtitleLanguage = 'English (CC)',
    this.preferredLanguages = const [],
    this.favoriteIndustries = const [],
    this.favoriteGenres = const [],
    this.favoriteActors = const [],
    this.favoriteActresses = const [],
    this.favoriteDirectors = const [],
    this.contentTypes = const [],
    this.watchingHabit = 'Weekends',
    this.preferredMovieLength = '90 - 120 min',
    this.favoriteDecade = '2020s & Modern',
    this.streamingQuality = 'Auto (4K HDR)',
    this.watchContext = 'Alone or with Partner',
    this.notificationsEnabled = true,
    this.watchHistory = const [],
    this.continueWatchingProgress = const {},
  });

  UserPreferences copyWith({
    bool? isFirstTime,
    String? userName,
    String? phoneNumber,
    String? username,
    String? userEmail,
    String? dob,
    String? gender,
    String? country,
    String? stateRegion,
    String? timeZone,
    String? avatarUrl,
    String? membershipType,
    String? preferredAppLanguage,
    String? preferredAudioLanguage,
    String? preferredSubtitleLanguage,
    List<String>? preferredLanguages,
    List<String>? favoriteIndustries,
    List<String>? favoriteGenres,
    List<String>? favoriteActors,
    List<String>? favoriteActresses,
    List<String>? favoriteDirectors,
    List<String>? contentTypes,
    String? watchingHabit,
    String? preferredMovieLength,
    String? favoriteDecade,
    String? streamingQuality,
    String? watchContext,
    bool? notificationsEnabled,
    List<int>? watchHistory,
    Map<String, double>? continueWatchingProgress,
  }) {
    return UserPreferences(
      isFirstTime: isFirstTime ?? this.isFirstTime,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      username: username ?? this.username,
      userEmail: userEmail ?? this.userEmail,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      stateRegion: stateRegion ?? this.stateRegion,
      timeZone: timeZone ?? this.timeZone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      membershipType: membershipType ?? this.membershipType,
      preferredAppLanguage: preferredAppLanguage ?? this.preferredAppLanguage,
      preferredAudioLanguage: preferredAudioLanguage ?? this.preferredAudioLanguage,
      preferredSubtitleLanguage: preferredSubtitleLanguage ?? this.preferredSubtitleLanguage,
      preferredLanguages: preferredLanguages ?? this.preferredLanguages,
      favoriteIndustries: favoriteIndustries ?? this.favoriteIndustries,
      favoriteGenres: favoriteGenres ?? this.favoriteGenres,
      favoriteActors: favoriteActors ?? this.favoriteActors,
      favoriteActresses: favoriteActresses ?? this.favoriteActresses,
      favoriteDirectors: favoriteDirectors ?? this.favoriteDirectors,
      contentTypes: contentTypes ?? this.contentTypes,
      watchingHabit: watchingHabit ?? this.watchingHabit,
      preferredMovieLength: preferredMovieLength ?? this.preferredMovieLength,
      favoriteDecade: favoriteDecade ?? this.favoriteDecade,
      streamingQuality: streamingQuality ?? this.streamingQuality,
      watchContext: watchContext ?? this.watchContext,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      watchHistory: watchHistory ?? this.watchHistory,
      continueWatchingProgress: continueWatchingProgress ?? this.continueWatchingProgress,
    );
  }

  Map<String, dynamic> toJson() => {
        'isFirstTime': isFirstTime,
        'userName': userName,
        'phoneNumber': phoneNumber,
        'username': username,
        'userEmail': userEmail,
        'dob': dob,
        'gender': gender,
        'country': country,
        'stateRegion': stateRegion,
        'timeZone': timeZone,
        'avatarUrl': avatarUrl,
        'membershipType': membershipType,
        'preferredAppLanguage': preferredAppLanguage,
        'preferredAudioLanguage': preferredAudioLanguage,
        'preferredSubtitleLanguage': preferredSubtitleLanguage,
        'preferredLanguages': preferredLanguages,
        'favoriteIndustries': favoriteIndustries,
        'favoriteGenres': favoriteGenres,
        'favoriteActors': favoriteActors,
        'favoriteActresses': favoriteActresses,
        'favoriteDirectors': favoriteDirectors,
        'contentTypes': contentTypes,
        'watchingHabit': watchingHabit,
        'preferredMovieLength': preferredMovieLength,
        'favoriteDecade': favoriteDecade,
        'streamingQuality': streamingQuality,
        'watchContext': watchContext,
        'notificationsEnabled': notificationsEnabled,
        'watchHistory': watchHistory,
        'continueWatchingProgress': continueWatchingProgress,
      };

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      isFirstTime: json['isFirstTime'] as bool? ?? true,
      userName: json['userName'] as String? ?? 'Cinematic Explorer',
      phoneNumber: json['phoneNumber'] as String? ?? '+91 98765 43210',
      username: json['username'] as String? ?? 'cinephile_01',
      userEmail: json['userEmail'] as String? ?? 'explorer@cinestream.ai',
      dob: json['dob'] as String? ?? '1998-05-15',
      gender: json['gender'] as String? ?? 'Prefer not to say',
      country: json['country'] as String? ?? 'India',
      stateRegion: json['stateRegion'] as String? ?? 'Kerala',
      timeZone: json['timeZone'] as String? ?? 'IST (UTC+5:30)',
      avatarUrl: json['avatarUrl'] as String? ?? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=300&q=80',
      membershipType: json['membershipType'] as String? ?? 'VIP Platinum Access',
      preferredAppLanguage: json['preferredAppLanguage'] as String? ?? 'English',
      preferredAudioLanguage: json['preferredAudioLanguage'] as String? ?? 'Original / English',
      preferredSubtitleLanguage: json['preferredSubtitleLanguage'] as String? ?? 'English (CC)',
      preferredLanguages: (json['preferredLanguages'] as List?)?.cast<String>() ?? [],
      favoriteIndustries: (json['favoriteIndustries'] as List?)?.cast<String>() ?? [],
      favoriteGenres: (json['favoriteGenres'] as List?)?.cast<String>() ?? [],
      favoriteActors: (json['favoriteActors'] as List?)?.cast<String>() ?? [],
      favoriteActresses: (json['favoriteActresses'] as List?)?.cast<String>() ?? [],
      favoriteDirectors: (json['favoriteDirectors'] as List?)?.cast<String>() ?? [],
      contentTypes: (json['contentTypes'] as List?)?.cast<String>() ?? [],
      watchingHabit: json['watchingHabit'] as String? ?? 'Weekends',
      preferredMovieLength: json['preferredMovieLength'] as String? ?? '90 - 120 min',
      favoriteDecade: json['favoriteDecade'] as String? ?? '2020s & Modern',
      streamingQuality: json['streamingQuality'] as String? ?? 'Auto (4K HDR)',
      watchContext: json['watchContext'] as String? ?? 'Alone or with Partner',
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      watchHistory: (json['watchHistory'] as List?)?.cast<int>() ?? [],
      continueWatchingProgress: (json['continueWatchingProgress'] as Map?)?.cast<String, double>() ?? {},
    );
  }
}
