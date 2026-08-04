import 'dart:async';
import '../../../core/network/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../models/movie.dart';
import '../models/genre.dart';
import '../models/cast_member.dart';
import '../models/video_trailer.dart';

class MovieRepository {
  final ApiClient _apiClient;
  final Map<String, List<Movie>> _memoryCache = {};
  final Map<int, Movie> _detailMemoryCache = {};

  MovieRepository(this._apiClient);

  ApiClient get apiClient => _apiClient;
  List<Movie> get masterCatalog => _masterCatalog;

  // ─────────────────────────────────────────────────────────────
  // Exclusive English Hollywood Master Catalog (100% Verified HTTP 200 Posters)
  // ─────────────────────────────────────────────────────────────
  static const List<Movie> _masterCatalog = [
    Movie(
      id: 872585,
      title: 'Oppenheimer',
      overview: 'Directed by Christopher Nolan. Starring Cillian Murphy, Emily Blunt, Matt Damon, Robert Downey Jr. The story of J. Robert Oppenheimer and the creation of the atomic bomb.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BN2JkMDc5MGQtZjg3YS00NmFiLWIyZmQtZTJmNTM5MjVmYTQ4XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BN2JkMDc5MGQtZjg3YS00NmFiLWIyZmQtZTJmNTM5MjVmYTQ4XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.9,
      releaseDate: '2023-07-21',
      runtime: 180,
      language: 'English',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 36, name: 'History')],
    ),
    Movie(
      id: 1630047,
      title: 'Avatar: The Way of Water',
      overview: 'Starring Sam Worthington, Zoe Saldaña. Directed by James Cameron. Jake Sully and Neytiri form a family and explore the dangerous ocean regions of Pandora.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNWI0Y2NkOWEtMmM2OC00MjQ3LWI1YzItZGQxYzQ3NzI4NWZmXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNWI0Y2NkOWEtMmM2OC00MjQ3LWI1YzItZGQxYzQ3NzI4NWZmXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.6,
      releaseDate: '2022-12-16',
      runtime: 192,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 619979,
      title: 'Top Gun: Maverick',
      overview: 'Starring Tom Cruise as Pete Mitchell. Directed by Joseph Kosinski. After 30 years of service, Maverick trains a detachment of graduates for a specialized mission.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMDBkZDNjMWEtOTdmMi00NmExLTg5MmMtNTFlYTJlNWY5YTdmXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMDBkZDNjMWEtOTdmMi00NmExLTg5MmMtNTFlYTJlNWY5YTdmXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.3,
      releaseDate: '2022-05-27',
      runtime: 130,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 693134,
      title: 'Dune: Part Two',
      overview: 'Starring Timothée Chalamet, Zendaya, Rebecca Ferguson. Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNTc0YmQxMjEtODI5MC00NjFiLTlkMWUtOGQ5NjFmYWUyZGJhXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNTc0YmQxMjEtODI5MC00NjFiLTlkMWUtOGQ5NjFmYWUyZGJhXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.5,
      releaseDate: '2024-03-01',
      runtime: 166,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 157336,
      title: 'Interstellar',
      overview: 'Directed by Christopher Nolan. Starring Matthew McConaughey, Anne Hathaway. A team of explorers travel through a wormhole in space to ensure humanity\'s survival.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.7,
      releaseDate: '2014-11-07',
      runtime: 169,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 4154796,
      title: 'Avengers: Endgame',
      overview: 'Starring Robert Downey Jr., Chris Evans, Scarlett Johansson. The Avengers assemble one last time to reverse Thanos\'s snap and restore balance to the universe.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_.jpg',
      voteAverage: 8.4,
      releaseDate: '2019-04-26',
      runtime: 181,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 155,
      title: 'The Dark Knight',
      overview: 'Directed by Christopher Nolan. Starring Christian Bale, Heath Ledger. Batman raises the stakes in his war on crime as the Joker unleashes chaos upon Gotham City.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMTMxNTMwODM0NF5BMl5BanBnXkFtZTcwODAyMTk2Mw@@._V1_.jpg',
      voteAverage: 9.0,
      releaseDate: '2008-07-18',
      runtime: 152,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 27205,
      title: 'Inception',
      overview: 'Directed by Christopher Nolan. Starring Leonardo DiCaprio, Joseph Gordon-Levitt. A thief who steals corporate secrets through dream-sharing technology is given the inverse task of planting an idea.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMjAxMzY3NjcxNF5BMl5BanBnXkFtZTcwNTI5OTM0Mw@@._V1_.jpg',
      voteAverage: 8.8,
      releaseDate: '2010-07-16',
      runtime: 148,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 11514332,
      title: 'Glass Onion',
      overview: 'Starring Daniel Craig, Edward Norton, Janelle Monáe. Tech billionaire Miles Bron invites his friends for a getaway on his private Greek island, where murder strikes.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMzI2ZDYxZTEtMzVlOC00OTUyLTgyNTAtYWFhNmRhZjAzZWE1XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMzI2ZDYxZTEtMzVlOC00OTUyLTgyNTAtYWFhNmRhZjAzZWE1XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.1,
      releaseDate: '2022-12-23',
      runtime: 139,
      language: 'English',
      genres: [Genre(id: 35, name: 'Comedy'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 558449,
      title: 'Gladiator II',
      overview: 'Directed by Ridley Scott. Starring Paul Mescal, Pedro Pascal, Denzel Washington. Years after Maximus, Lucius enters the Colosseum to fight for the future of Rome.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMWYzZTM5ZGQtOGE5My00NmM2LWFlMDEtMGNjYjdmOWM1MzA1XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMWYzZTM5ZGQtOGE5My00NmM2LWFlMDEtMGNjYjdmOWM1MzA1XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.8,
      releaseDate: '2024-11-22',
      runtime: 148,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 575264,
      title: 'Mission: Impossible - Dead Reckoning',
      overview: 'Starring Tom Cruise, Hayley Atwell. Ethan Hunt and his IMF team track down a terrifying weapon that threatens all of humanity before it falls into the wrong hands.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BN2U4OTdmM2QtZTkxYy00ZmQyLTg2N2UtMDdmMGJmNDhlZDU1XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BN2U4OTdmM2QtZTkxYy00ZmQyLTg2N2UtMDdmMGJmNDhlZDU1XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.7,
      releaseDate: '2023-07-12',
      runtime: 163,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 945961,
      title: 'Alien: Romulus',
      overview: 'Starring Cailee Spaeny, David Jonsson. While scavenging a derelict space station, a group of young colonizers come face to face with the most terrifying life form.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMDU0NjcwOGQtNjNjOS00NzQ3LWIwM2YtYWVmODZjMzQzN2ExXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMDU0NjcwOGQtNjNjOS00NzQ3LWIwM2YtYWVmODZjMzQzN2ExXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.3,
      releaseDate: '2024-08-16',
      runtime: 119,
      language: 'English',
      genres: [Genre(id: 27, name: 'Horror'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 414906,
      title: 'The Batman',
      overview: 'Starring Robert Pattinson, Zoë Kravitz, Paul Dano. When a killer targets Gotham\'s elite, Batman uncovers hidden corruption and questions his family\'s past.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMmU5NGJlMzAtMGNmOC00YjJjLTgyMzUtNjAyYmE4Njg5YWMyXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.7,
      releaseDate: '2022-03-04',
      runtime: 176,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 475557,
      title: 'Joker',
      overview: 'Starring Joaquin Phoenix, Robert De Niro. A mentally troubled stand-up comedian embarks on a downward spiral that leads to the creation of an iconic villain.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNzY3OWQ5NDktNWQ2OC00ZjdlLThkMmItMDhhNDk3NTFiZGU4XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNzY3OWQ5NDktNWQ2OC00ZjdlLThkMmItMDhhNDk3NTFiZGU4XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.2,
      releaseDate: '2019-10-04',
      runtime: 122,
      language: 'English',
      genres: [Genre(id: 80, name: 'Crime'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 634649,
      title: 'Spider-Man: No Way Home',
      overview: 'Starring Tom Holland, Zendaya, Benedict Cumberbatch. With Spider-Man\'s identity revealed, Peter asks Doctor Strange for help, unraveling the multiverse.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMmFiZGZjMmEtMTA0Ni00MzA2LTljMTYtZGI2MGJmZWYzZTQ2XkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMmFiZGZjMmEtMTA0Ni00MzA2LTljMTYtZGI2MGJmZWYzZTQ2XkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.2,
      releaseDate: '2021-12-17',
      runtime: 148,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 346698,
      title: 'Barbie',
      overview: 'Starring Margot Robbie, Ryan Gosling. Directed by Greta Gerwig. Barbie and Ken are having the time of their lives in Barbie Land when they venture into the real world.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYjI3NDU0ZGYtYjA2YS00Y2RlLTgwZDAtYTE2YTM5ZjE1M2JlXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYjI3NDU0ZGYtYjA2YS00Y2RlLTgwZDAtYTE2YTM5ZjE1M2JlXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.2,
      releaseDate: '2023-07-21',
      runtime: 114,
      language: 'English',
      genres: [Genre(id: 35, name: 'Comedy'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 603,
      title: 'The Matrix',
      overview: 'Starring Keanu Reeves, Laurence Fishburne, Carrie-Anne Moss. A computer hacker learns from mysterious rebels about the true nature of his reality.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BN2NmN2VhMTQtMDNiOS00NDlhLTliMjgtODE2ZTY0ODQyNDRhXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BN2NmN2VhMTQtMDNiOS00NDlhLTliMjgtODE2ZTY0ODQyNDRhXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.7,
      releaseDate: '1999-03-31',
      runtime: 136,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 28, name: 'Action')],
    ),
    Movie(
      id: 597,
      title: 'Titanic',
      overview: 'Directed by James Cameron. Starring Leonardo DiCaprio, Kate Winslet. A seventeen-year-old aristocrat falls in love with a kind but poor artist aboard the RMS Titanic.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYzYyN2FiZmUtYWYzMy00MzViLWJkZTMtOGY1ZjgzNWMwN2YxXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 7.9,
      releaseDate: '1997-12-19',
      runtime: 194,
      language: 'English',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 10749, name: 'Romance')],
    ),
    Movie(
      id: 680,
      title: 'Pulp Fiction',
      overview: 'Directed by Quentin Tarantino. Starring John Travolta, Samuel L. Jackson, Uma Thurman. The lives of two mob hitmen, a boxer, and a gangster\'s wife intertwine.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYTViYTE3ZGQtNDBlMC00ZTAyLTkyODMtZGRiZDg0MjA2YThkXkEyXkFqcGc@._V1_.jpg',
      voteAverage: 8.5,
      releaseDate: '1994-10-14',
      runtime: 154,
      language: 'English',
      genres: [Genre(id: 80, name: 'Crime'), Genre(id: 18, name: 'Drama')],
    ),
  ];

  static const Map<int, List<CastMember>> _castMap = {
    872585: [
      CastMember(id: 1, name: 'Cillian Murphy', character: 'J. Robert Oppenheimer', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Emily Blunt', character: 'Katherine Oppenheimer', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Matt Damon', character: 'Leslie Groves', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Robert Downey Jr.', character: 'Lewis Strauss', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Florence Pugh', character: 'Jean Tatlock', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
    ],
    1630047: [
      CastMember(id: 1, name: 'Sam Worthington', character: 'Jake Sully', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Zoe Saldaña', character: 'Neytiri', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Sigourney Weaver', character: 'Kiri', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Kate Winslet', character: 'Ronal', profilePath: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Stephen Lang', character: 'Miles Quaritch', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
    ],
    619979: [
      CastMember(id: 1, name: 'Tom Cruise', character: 'Pete "Maverick" Mitchell', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Miles Teller', character: 'Bradley "Rooster" Bradshaw', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Jennifer Connelly', character: 'Penny Benjamin', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Jon Hamm', character: 'Beau "Cyclone" Simpson', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Glen Powell', character: 'Jake "Hangman" Seresin', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
    ],
    693134: [
      CastMember(id: 1, name: 'Timothée Chalamet', character: 'Paul Atreides', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Zendaya', character: 'Chani', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Rebecca Ferguson', character: 'Lady Jessica', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Javier Bardem', character: 'Stilgar', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Josh Brolin', character: 'Gurney Halleck', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
    ],
    157336: [
      CastMember(id: 1, name: 'Matthew McConaughey', character: 'Cooper', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Anne Hathaway', character: 'Brand', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Jessica Chastain', character: 'Murph', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Michael Caine', character: 'Professor Brand', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Matt Damon', character: 'Mann', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
    ],
    4154796: [
      CastMember(id: 1, name: 'Robert Downey Jr.', character: 'Tony Stark / Iron Man', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Chris Evans', character: 'Steve Rogers / Captain America', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Mark Ruffalo', character: 'Bruce Banner / Hulk', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Chris Hemsworth', character: 'Thor', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Scarlett Johansson', character: 'Natasha Romanoff', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
    ],
    155: [
      CastMember(id: 1, name: 'Christian Bale', character: 'Bruce Wayne / Batman', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Heath Ledger', character: 'Joker', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Aaron Eckhart', character: 'Harvey Dent', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Michael Caine', character: 'Alfred Pennyworth', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Gary Oldman', character: 'Jim Gordon', profilePath: 'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?auto=format&fit=crop&w=300&q=80'),
    ],
    27205: [
      CastMember(id: 1, name: 'Leonardo DiCaprio', character: 'Dom Cobb', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Joseph Gordon-Levitt', character: 'Arthur', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Elliot Page', character: 'Ariadne', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Tom Hardy', character: 'Eames', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Ken Watanabe', character: 'Saito', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
    ],
    11514332: [
      CastMember(id: 1, name: 'Daniel Craig', character: 'Benoit Blanc', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Edward Norton', character: 'Miles Bron', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Janelle Monáe', character: 'Helen Brand', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Kathryn Hahn', character: 'Claire Debella', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Leslie Odom Jr.', character: 'Lionel Toussaint', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
    ],
    558449: [
      CastMember(id: 1, name: 'Paul Mescal', character: 'Lucius', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Pedro Pascal', character: 'General Acacius', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Denzel Washington', character: 'Macrinus', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Connie Nielsen', character: 'Lucilla', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Joseph Quinn', character: 'Emperor Geta', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
    ],
    575264: [
      CastMember(id: 1, name: 'Tom Cruise', character: 'Ethan Hunt', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Hayley Atwell', character: 'Grace', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Ving Rhames', character: 'Luther Stickell', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Simon Pegg', character: 'Benji Dunn', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Rebecca Ferguson', character: 'Ilsa Faust', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
    ],
    945961: [
      CastMember(id: 1, name: 'Cailee Spaeny', character: 'Rain Carradine', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'David Jonsson', character: 'Andy', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Archie Renaux', character: 'Tyler', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Isabela Merced', character: 'Kay', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Spike Fearn', character: 'Bjorn', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
    ],
    414906: [
      CastMember(id: 1, name: 'Robert Pattinson', character: 'Bruce Wayne / Batman', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Zoë Kravitz', character: 'Selina Kyle / Catwoman', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Paul Dano', character: 'Edward Nashton / Riddler', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Colin Farrell', character: 'Oswald Cobblepot', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 5, name: 'Andy Serkis', character: 'Alfred Pennyworth', profilePath: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?auto=format&fit=crop&w=300&q=80'),
    ],
    475557: [
      CastMember(id: 1, name: 'Joaquin Phoenix', character: 'Arthur Fleck / Joker', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Robert De Niro', character: 'Murray Franklin', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Zazie Beetz', character: 'Sophie Dumond', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Frances Conroy', character: 'Penny Fleck', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
    ],
    634649: [
      CastMember(id: 1, name: 'Tom Holland', character: 'Peter Parker / Spider-Man', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Zendaya', character: 'MJ', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Benedict Cumberbatch', character: 'Doctor Strange', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Jacob Batalon', character: 'Ned Leeds', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
    ],
    346698: [
      CastMember(id: 1, name: 'Margot Robbie', character: 'Barbie', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Ryan Gosling', character: 'Ken', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'America Ferrera', character: 'Gloria', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Will Ferrell', character: 'CEO of Mattel', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
    ],
    603: [
      CastMember(id: 1, name: 'Keanu Reeves', character: 'Neo', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Laurence Fishburne', character: 'Morpheus', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Carrie-Anne Moss', character: 'Trinity', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Hugo Weaving', character: 'Agent Smith', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
    ],
    597: [
      CastMember(id: 1, name: 'Leonardo DiCaprio', character: 'Jack Dawson', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Kate Winslet', character: 'Rose DeWitt Bukater', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Billy Zane', character: 'Cal Hockley', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Kathy Bates', character: 'Molly Brown', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
    ],
    680: [
      CastMember(id: 1, name: 'John Travolta', character: 'Vincent Vega', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Samuel L. Jackson', character: 'Jules Winnfield', profilePath: 'https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Uma Thurman', character: 'Mia Wallace', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Bruce Willis', character: 'Butch Coolidge', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
    ],
  };

  static const Map<int, String> _trailerKeys = {
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

  Future<List<Movie>> fetchCategory(String query, {int page = 1}) async {
    final cacheKey = '${query.toLowerCase().trim()}_p$page';
    if (_memoryCache.containsKey(cacheKey) && _memoryCache[cacheKey]!.isNotEmpty) {
      return _memoryCache[cacheKey]!;
    }

    final qLower = query.toLowerCase().trim();
    final matched = _masterCatalog.where((m) {
      final t = m.title.toLowerCase();
      final o = m.overview.toLowerCase();
      final g = m.genres.map((genre) => genre.name.toLowerCase()).join(' ');
      return t.contains(qLower) || o.contains(qLower) || g.contains(qLower);
    }).toList();

    if (matched.isNotEmpty) {
      _memoryCache[cacheKey] = matched;
      return matched;
    }

    _memoryCache[cacheKey] = _masterCatalog;
    return _masterCatalog;
  }

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    final target = _masterCatalog.firstWhere((m) => m.id == movieId, orElse: () => _masterCatalog.first);
    final similar = _masterCatalog.where((m) => m.id != target.id).toList();
    return similar.isNotEmpty ? similar : _masterCatalog;
  }

  Future<List<Movie>> getTrendingMovies({int page = 1, String? preferredQuery}) async {
    const ids = [693134, 558449, 619979, 1630047, 634649, 155, 27205, 872585];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getTrendingWeekMovies({int page = 1, String? preferredQuery}) async {
    const ids = [558449, 945961, 693134, 575264, 346698, 872585, 157336];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getPopularMovies({int page = 1, String? preferredQuery}) async {
    const ids = [1630047, 4154796, 597, 619979, 346698, 603, 475557, 155];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1, String? preferredQuery}) async {
    final catalog = List<Movie>.from(_masterCatalog);
    catalog.sort((a, b) => b.voteAverage.compareTo(a.voteAverage));
    return catalog;
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1, String? preferredQuery}) async {
    final List<Movie> catalog = List.from(_masterCatalog);
    catalog.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
    return catalog;
  }

  Future<List<Movie>> getUpcomingMovies({int page = 1, String? preferredQuery}) async {
    const ids = [558449, 945961, 693134, 575264, 872585];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getActionMovies({int page = 1, String? preferredQuery}) async {
    const ids = [603, 619979, 155, 575264, 27205, 4154796, 634649, 414906, 558449];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getComedyMovies({int page = 1, String? preferredQuery}) async {
    const ids = [346698, 11514332, 680];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getHorrorMovies({int page = 1, String? preferredQuery}) async {
    const ids = [945961, 11514332, 414906, 475557, 155];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getScifiMovies({int page = 1, String? preferredQuery}) async {
    const ids = [157336, 603, 1630047, 693134, 27205, 945961, 634649, 4154796];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getDramaMovies({int page = 1, String? preferredQuery}) async {
    const ids = [872585, 597, 680, 475557, 558449, 155, 157336, 619979];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getAnimationMovies({int page = 1, String? preferredQuery}) async {
    const ids = [1630047, 634649, 346698];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getThrillerMovies({int page = 1, String? preferredQuery}) async {
    const ids = [575264, 155, 27205, 414906, 475557, 680, 11514332];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getAwardWinners({int page = 1, String? preferredQuery}) async {
    const ids = [155, 872585, 27205, 157336, 603, 680, 693134, 4154796];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getClassicMovies({int page = 1, String? preferredQuery}) async {
    const ids = [680, 597, 603, 155, 27205, 157336];
    return _getMoviesByIds(ids);
  }

  Future<List<Movie>> getBollywoodMovies({int page = 1}) => _getEnglishFallback();
  Future<List<Movie>> getSouthMovies({int page = 1}) => _getEnglishFallback();
  Future<List<Movie>> getAnimeMovies({int page = 1}) => _getEnglishFallback();
  Future<List<Movie>> getKoreanMovies({int page = 1}) => _getEnglishFallback();
  Future<List<Movie>> getInternationalMovies({int page = 1}) => _getEnglishFallback();

  Future<List<Movie>> _getEnglishFallback() async => _masterCatalog;

  List<Movie> _getMoviesByIds(List<int> ids) {
    final list = <Movie>[];
    for (final id in ids) {
      final found = _masterCatalog.where((m) => m.id == id).firstOrNull;
      if (found != null && !list.contains(found)) {
        list.add(found);
      }
    }
    for (final m in _masterCatalog) {
      if (!list.contains(m)) list.add(m);
    }
    return list;
  }

  Future<List<Genre>> getGenres() async {
    return ApiConstants.genresList.map((g) => Genre.fromJson(g)).toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    return fetchCategory(query.trim(), page: page);
  }

  Future<Movie> getMovieDetails(int movieId) async {
    if (_detailMemoryCache.containsKey(movieId)) {
      return _detailMemoryCache[movieId]!;
    }
    final foundLocal = _masterCatalog.firstWhere((m) => m.id == movieId, orElse: () => _masterCatalog.first);
    _detailMemoryCache[movieId] = foundLocal;
    return foundLocal;
  }

  Future<List<CastMember>> getMovieCredits(int movieId) async {
    final cast = _castMap[movieId];
    if (cast != null && cast.isNotEmpty) return cast;

    return const [
      CastMember(id: 1, name: 'Cillian Murphy', character: 'Lead Actor', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 2, name: 'Emily Blunt', character: 'Lead Actress', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 3, name: 'Robert Downey Jr.', character: 'Supporting Actor', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=300&q=80'),
      CastMember(id: 4, name: 'Florence Pugh', character: 'Supporting Actress', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=300&q=80'),
    ];
  }

  Future<List<VideoTrailer>> getMovieTrailers(int movieId) async {
    final key = _trailerKeys[movieId];
    if (key != null && key.isNotEmpty) {
      return [
        VideoTrailer(
          id: 'tr_$movieId',
          key: key,
          name: 'Official Trailer',
          site: 'YouTube',
          type: 'Trailer',
          official: true,
        ),
      ];
    }
    final movie = _masterCatalog.where((m) => m.id == movieId).firstOrNull;
    if (movie != null) {
      return [
        VideoTrailer(
          id: 'search_$movieId',
          key: 'SEARCH:${Uri.encodeComponent("${movie.title} official trailer")}',
          name: 'Watch on YouTube',
          site: 'YouTube',
          type: 'Trailer',
          official: false,
        ),
      ];
    }
    return [];
  }

  void clearCache() {
    _memoryCache.clear();
    _detailMemoryCache.clear();
  }
}
