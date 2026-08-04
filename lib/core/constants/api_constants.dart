class ApiConstants {
  static const String imdbBaseUrl     = 'https://v3.sg.media-imdb.com/suggestion/';
  static const String imdbTitleBaseUrl= 'https://www.imdb.com/title/';
  static const String baseUrl          = 'https://v3.sg.media-imdb.com/suggestion/';

  // Convert numeric id → IMDb ID format (e.g. 848228 → "tt0848228")
  static String toImdbId(int id) => 'tt${id.toString().padLeft(7, '0')}';

  // ─────────────────────────────────────────────────────────────────────────
  // Curated IMDb ID lists for home screen categories (numeric, "tt" stripped)
  // ─────────────────────────────────────────────────────────────────────────

  /// 🔥 Trending Today
  static const List<int> trendingIds = [
    9362722, // Spider-Man: No Way Home (2021)
    4154796, // Avengers: Endgame (2019)
    4154756, // Avengers: Infinity War (2018)
    1877830, // The Batman (2022)
    6710474, // Everything Everywhere All at Once (2022)
    1745960, // Top Gun: Maverick (2022)
    7286456, // Joker (2019)
    5884052, // Knives Out (2019)
    6751668, // Parasite (2019)
    1375666, // Inception (2010)
    468569,  // The Dark Knight (2008)
    816692,  // Interstellar (2014)
    848228,  // The Avengers (2012)
    2395427, // Avengers: Age of Ultron (2015)
    6320628, // Spider-Man: Homecoming (2017)
    3896198, // Guardians of the Galaxy Vol. 2 (2017)
    993846,  // The Wolf of Wall Street (2013)
    2096673, // Inside Out (2015)
    317705,  // The Incredibles (2004)
    266543,  // Finding Nemo (2003)
  ];

  /// 📈 Trending This Week
  static const List<int> trendingWeekIds = [
    816692,  // Interstellar (2014)
    1375666, // Inception (2010)
    468569,  // The Dark Knight (2008)
    133093,  // The Matrix (1999)
    137523,  // Fight Club (1999)
    109830,  // Forrest Gump (1994)
    111161,  // The Shawshank Redemption (1994)
    110912,  // Pulp Fiction (1994)
    993846,  // The Wolf of Wall Street (2013)
    99685,   // Goodfellas (1990)
    7286456, // Joker (2019)
    5884052, // Knives Out (2019)
    6751668, // Parasite (2019)
    6710474, // Everything Everywhere All at Once (2022)
    1877830, // The Batman (2022)
    1745960, // Top Gun: Maverick (2022)
    2096673, // Inside Out (2015)
    382932,  // Ratatouille (2007)
    910970,  // WALL-E (2008)
    435761,  // Toy Story 3 (2010)
  ];

  /// ⭐ Top Rated All Time
  static const List<int> topRatedIds = [
    111161,  // The Shawshank Redemption (1994)
    68646,   // The Godfather (1972)
    468569,  // The Dark Knight (2008)
    71562,   // The Godfather Part II (1974)
    50083,   // 12 Angry Men (1957)
    108052,  // Schindler's List (1993)
    167260,  // The Lord of the Rings: Return of the King (2003)
    110912,  // Pulp Fiction (1994)
    60196,   // The Good, the Bad and the Ugly (1966)
    120737,  // The Lord of the Rings: Fellowship of the Ring (2001)
    137523,  // Fight Club (1999)
    109830,  // Forrest Gump (1994)
    1375666, // Inception (2010)
    80684,   // Star Wars: The Empire Strikes Back (1980)
    167261,  // The Lord of the Rings: The Two Towers (2002)
    133093,  // The Matrix (1999)
    73486,   // One Flew Over the Cuckoo's Nest (1975)
    99685,   // Goodfellas (1990)
    47478,   // Seven Samurai (1954)
    317248,  // City of God (2002)
  ];

  /// 🎬 Popular Movies
  static const List<int> popularIds = [
    4154796, // Avengers: Endgame (2019)
    4154756, // Avengers: Infinity War (2018)
    9362722, // Spider-Man: No Way Home (2021)
    848228,  // The Avengers (2012)
    2395427, // Avengers: Age of Ultron (2015)
    1825683, // Black Panther (2018)
    369610,  // Jurassic World (2015)
    2250912, // Spider-Man: Far From Home (2019)
    6320628, // Spider-Man: Homecoming (2017)
    3896198, // Guardians of the Galaxy Vol. 2 (2017)
    5884052, // Knives Out (2019)
    6751668, // Parasite (2019)
    7286456, // Joker (2019)
    1877830, // The Batman (2022)
    6710474, // Everything Everywhere All at Once (2022)
    1745960, // Top Gun: Maverick (2022)
    993846,  // The Wolf of Wall Street (2013)
    2096673, // Inside Out (2015)
    317705,  // The Incredibles (2004)
    382932,  // Ratatouille (2007)
  ];

  /// 🎞️ Now Playing
  static const List<int> nowPlayingIds = [
    816692,  // Interstellar (2014)
    1375666, // Inception (2010)
    468569,  // The Dark Knight (2008)
    110912,  // Pulp Fiction (1994)
    133093,  // The Matrix (1999)
    167260,  // Lord of the Rings: Return of the King
    910970,  // WALL-E (2008)
    435761,  // Toy Story 3 (2010)
    2380307, // Coco (2017)
    266543,  // Finding Nemo (2003)
    317705,  // The Incredibles (2004)
    382932,  // Ratatouille (2007)
    2096673, // Inside Out (2015)
    1745960, // Top Gun: Maverick (2022)
    6710474, // Everything Everywhere All at Once (2022)
    1877830, // The Batman (2022)
    7286456, // Joker (2019)
    5884052, // Knives Out (2019)
    993846,  // The Wolf of Wall Street (2013)
    111161,  // The Shawshank Redemption (1994)
  ];

  /// 📅 Coming Soon
  static const List<int> upcomingIds = [
    9362722, // Spider-Man: No Way Home
    4154796, // Avengers: Endgame
    1825683, // Black Panther (2018)
    3498820, // Captain America: Civil War (2016)
    2395427, // Avengers: Age of Ultron
    848228,  // The Avengers (2012)
    1300854, // Iron Man 3 (2013)
    2250912, // Spider-Man: Far From Home
    6320628, // Spider-Man: Homecoming
    3896198, // Guardians of the Galaxy Vol.2
    369610,  // Jurassic World (2015)
    266543,  // Finding Nemo (2003)
    317705,  // The Incredibles (2004)
    382932,  // Ratatouille (2007)
    435761,  // Toy Story 3 (2010)
    2380307, // Coco (2017)
    910970,  // WALL-E (2008)
    2096673, // Inside Out (2015)
    1745960, // Top Gun: Maverick (2022)
    6710474, // Everything Everywhere All at Once
  ];

  /// 💥 Action & Adventure
  static const List<int> actionIds = [
    468569,  // The Dark Knight (2008)
    4154796, // Avengers: Endgame
    4154756, // Avengers: Infinity War
    848228,  // The Avengers (2012)
    1745960, // Top Gun: Maverick
    9362722, // Spider-Man: No Way Home
    1877830, // The Batman (2022)
    1825683, // Black Panther
    3498820, // Captain America: Civil War
    80684,   // Star Wars: The Empire Strikes Back
    120737,  // Lord of the Rings: Fellowship
    167260,  // Lord of the Rings: Return of the King
    133093,  // The Matrix (1999)
    167261,  // Lord of the Rings: Two Towers
    369610,  // Jurassic World
    2250912, // Spider-Man: Far From Home
    6320628, // Spider-Man: Homecoming
    3896198, // Guardians of the Galaxy Vol.2
    1300854, // Iron Man 3
    2395427, // Age of Ultron
  ];

  /// 😂 Comedy
  static const List<int> comedyIds = [
    109830,  // Forrest Gump (1994)
    266543,  // Finding Nemo (2003)
    317705,  // The Incredibles (2004)
    382932,  // Ratatouille (2007)
    910970,  // WALL-E (2008)
    2096673, // Inside Out (2015)
    435761,  // Toy Story 3 (2010)
    2380307, // Coco (2017)
    5884052, // Knives Out (2019)
    6710474, // Everything Everywhere All at Once
    993846,  // The Wolf of Wall Street (2013)
    7286456, // Joker (2019)
    317248,  // City of God (2002)
    115912,  // Superbad (2007)
    266856,  // The Grand Budapest Hotel (2014)
    378320,  // The Nice Guys (2016)
    258489,  // This Is the End (2013)
    98978,   // Due Date (2010)
    75612,   // Ferris Bueller's Day Off (1986)
    97576,   // The Hangover (2009)
  ];

  /// 👻 Horror
  static const List<int> horrorIds = [
    4232099, // Hereditary (2018)
    1099212, // The Conjuring (2013)
    167404,  // Get Out (2017)
    421205,  // A Quiet Place (2018)
    6723592, // Midsommar (2019)
    1457767, // The Witch (2015)
    1844919, // It (2017)
    3672954, // Us (2019)
    482571,  // Halloween (2018)
    88751,   // The Shining (1980)
    11280,   // A Nightmare on Elm Street (1984)
    40095,   // Poltergeist (1982)
    83666,   // Sinister (2012)
    236492,  // Insidious (2010)
    138879,  // The Cabin in the Woods (2011)
    338596,  // Don't Breathe (2016)
    363590,  // It Follows (2014)
    263115,  // The Babadook (2014)
    344830,  // 10 Cloverfield Lane (2016)
    1119997, // The Invisible Man (2020)
  ];

  /// 🚀 Science Fiction
  static const List<int> scifiIds = [
    816692,  // Interstellar (2014)
    1375666, // Inception (2010)
    133093,  // The Matrix (1999)
    910970,  // WALL-E (2008)
    4154796, // Avengers: Endgame
    9362722, // Spider-Man: No Way Home
    1877830, // The Batman (2022)
    81549,   // Arrival (2016)
    490087,  // The Martian (2015)
    78748,   // Alien (1979)
    89765,   // Blade Runner (1982)
    1856101, // Blade Runner 2049 (2017)
    167261,  // Lord of the Rings: Two Towers
    384682,  // Ex Machina (2014)
    335988,  // Ghost in the Shell (2017)
    167260,  // Lord of the Rings: Return of the King
    114709,  // Toy Story (1995)
    266543,  // Finding Nemo (2003)
    2096673, // Inside Out (2015)
    120737,  // Lord of the Rings: Fellowship
  ];

  /// 🎭 Drama
  static const List<int> dramaIds = [
    111161,  // The Shawshank Redemption
    68646,   // The Godfather
    71562,   // The Godfather Part II
    50083,   // 12 Angry Men
    108052,  // Schindler's List
    110912,  // Pulp Fiction
    109830,  // Forrest Gump
    99685,   // Goodfellas
    317248,  // City of God
    73486,   // One Flew Over the Cuckoo's Nest
    6751668, // Parasite (2019)
    5884052, // Knives Out (2019)
    993846,  // The Wolf of Wall Street
    266856,  // The Grand Budapest Hotel
    7286456, // Joker (2019)
    6710474, // Everything Everywhere All at Once
    120689,  // The Green Mile (1999)
    40096,   // Schindler's List (1993)
    112573,  // The Pursuit of Happyness (2006)
    375366,  // La La Land (2016)
  ];

  /// 🎨 Animation
  static const List<int> animationIds = [
    266543,  // Finding Nemo (2003)
    317705,  // The Incredibles (2004)
    382932,  // Ratatouille (2007)
    910970,  // WALL-E (2008)
    435761,  // Toy Story 3 (2010)
    2380307, // Coco (2017)
    2096673, // Inside Out (2015)
    114709,  // Toy Story (1995)
    120591,  // A Bug's Life (1998)
    298230,  // The Lego Movie (2014)
    223808,  // Finding Dory (2016)
    6466538, // Incredibles 2 (2018)
    374720,  // Zootopia (2016)
    169102,  // Frozen (2013)
    172985,  // Moana (2016)
    508439,  // Onward (2020)
    508947,  // Turning Red (2022)
    478108,  // Soul (2020)
    105734,  // Brave (2012)
    82695,   // Up (2009)
  ];

  /// 😱 Thriller
  static const List<int> thrillerIds = [
    137523,  // Fight Club (1999)
    468569,  // The Dark Knight (2008)
    110912,  // Pulp Fiction (1994)
    816692,  // Interstellar (2014)
    1375666, // Inception (2010)
    7286456, // Joker (2019)
    5884052, // Knives Out (2019)
    6751668, // Parasite (2019)
    993846,  // The Wolf of Wall Street
    99685,   // Goodfellas (1990)
    167404,  // Get Out (2017)
    421205,  // A Quiet Place (2018)
    338596,  // Don't Breathe (2016)
    266856,  // The Grand Budapest Hotel
    375366,  // La La Land (2016)
    384682,  // Ex Machina (2014)
    490087,  // The Martian (2015)
    1856101, // Blade Runner 2049
    317248,  // City of God (2002)
    108052,  // Schindler's List
  ];

  /// 🏆 Award Winners
  static const List<int> awardWinnersIds = [
    111161,  // The Shawshank Redemption
    68646,   // The Godfather
    108052,  // Schindler's List
    167260,  // The Lord of the Rings: Return of the King
    109830,  // Forrest Gump
    73486,   // One Flew Over the Cuckoo's Nest
    47478,   // Seven Samurai
    317248,  // City of God
    6751668, // Parasite (2019)
    375366,  // La La Land (2016)
    209144,  // 12 Years a Slave (2013)
    266856,  // The Grand Budapest Hotel
    50083,   // 12 Angry Men
    60196,   // The Good, the Bad and the Ugly
    71562,   // The Godfather Part II
    6710474, // Everything Everywhere All at Once
    119488,  // The Artist (2011)
    477347,  // Spotlight (2015)
    167404,  // Get Out (2017)
    338896,  // Moonlight (2016)
  ];

  /// 🎬 Classic Cinema (pre-2000)
  static const List<int> classicIds = [
    68646,   // The Godfather (1972)
    71562,   // The Godfather Part II (1974)
    50083,   // 12 Angry Men (1957)
    108052,  // Schindler's List (1993)
    60196,   // The Good, the Bad and the Ugly (1966)
    133093,  // The Matrix (1999)
    137523,  // Fight Club (1999)
    109830,  // Forrest Gump (1994)
    111111,  // The Shawshank Redemption (1994)
    110912,  // Pulp Fiction (1994)
    73486,   // One Flew Over the Cuckoo's Nest (1975)
    99685,   // Goodfellas (1990)
    47478,   // Seven Samurai (1954)
    80684,   // Star Wars: The Empire Strikes Back (1980)
    88751,   // The Shining (1980)
    56801,   // Apocalypse Now (1979)
    77338,   // Raging Bull (1980)
    78748,   // Alien (1979)
    89765,   // Blade Runner (1982)
    76759,   // Star Wars (1977)
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Standard IMDb genre taxonomy list
  // ─────────────────────────────────────────────────────────────────────────
  static const List<Map<String, dynamic>> genresList = [
    {'id': 28,    'name': 'Action'},
    {'id': 12,    'name': 'Adventure'},
    {'id': 16,    'name': 'Animation'},
    {'id': 35,    'name': 'Comedy'},
    {'id': 80,    'name': 'Crime'},
    {'id': 99,    'name': 'Documentary'},
    {'id': 18,    'name': 'Drama'},
    {'id': 10751, 'name': 'Family'},
    {'id': 14,    'name': 'Fantasy'},
    {'id': 36,    'name': 'History'},
    {'id': 27,    'name': 'Horror'},
    {'id': 9648,  'name': 'Mystery'},
    {'id': 10749, 'name': 'Romance'},
    {'id': 878,   'name': 'Sci-Fi'},
    {'id': 53,    'name': 'Thriller'},
    {'id': 10752, 'name': 'War'},
    {'id': 37,    'name': 'Western'},
  ];
}
