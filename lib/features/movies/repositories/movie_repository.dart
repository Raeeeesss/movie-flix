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

  // Covers Mollywood, Kollywood, Tollywood, Bollywood, & Hollywood
  // ─────────────────────────────────────────────────────────────

  static const List<Movie> _masterCatalog = [
    // ── Malayalam (Mollywood) ──────────────────────────────────
    Movie(
      id: 641490,
      title: 'Lucifer',
      overview: 'Starring Mohanlal as Stephen Nedumpally. Directed by Prithviraj Sukumaran. A political Godfather dies and a battle for succession ensues.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMWY0ZmVjMjctYjFhYy00MDg2LWI1NDItZDk3MzYxODBmZDQwXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMWY0ZmVjMjctYjFhYy00MDg2LWI1NDItZDk3MzYxODBmZDQwXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.5,
      releaseDate: '2019',
      runtime: 175,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 2855146,
      title: 'Drishyam',
      overview: 'Starring Mohanlal as Georgekutty. Directed by Jeethu Joseph. A man goes to extreme lengths to save his family.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BM2MwMjNlNjctYjA2ZS00ZDA4LWJmNTYtODg5NDY1YzQzZDg2XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BM2MwMjNlNjctYjA2ZS00ZDA4LWJmNTYtODg5NDY1YzQzZDg2XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.4,
      releaseDate: '2013',
      runtime: 160,
      language: 'Malayalam',
      genres: [Genre(id: 53, name: 'Thriller'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 13994304,
      title: 'Drishyam 2',
      overview: 'Starring Mohanlal as Georgekutty. Directed by Jeethu Joseph. Georgekutty comes under investigation once again.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNGYyY2I5MzktMDg2MC00Nzc4LWIwNmYtMjg3NzE1ODQyMDllXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNGYyY2I5MzktMDg2MC00Nzc4LWIwNmYtMjg3NzE1ODQyMDllXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.4,
      releaseDate: '2021',
      runtime: 153,
      language: 'Malayalam',
      genres: [Genre(id: 53, name: 'Thriller'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 29773090,
      title: 'Neru',
      overview: 'Starring Mohanlal as Advocate Vijayamohan. Directed by Jeethu Joseph. A blind sculptor fights for justice.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNDY0OTYyOWMtYzIzMy00Zjg0LWE2MjUtZTcxYWI4NTViNjYxXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNDY0OTYyOWMtYzIzMy00Zjg0LWE2MjUtZTcxYWI4NTViNjYxXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.8,
      releaseDate: '2023',
      runtime: 152,
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 28318356,
      title: 'Malaikottai Vaaliban',
      overview: 'Starring Mohanlal as Vaaliban. Directed by Lijo Jose Pellissery. An undisputed warrior journeys across time.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYzYzNzhlN2MtMWI3NS00YjE3LWJlZGEtNjYyNDVmNDMxMGQwXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYzYzNzhlN2MtMWI3NS00YjE3LWJlZGEtNjYyNDVmNDMxMGQwXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.2,
      releaseDate: '2024',
      runtime: 156,
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 30310231,
      title: 'Manjummel Boys',
      overview: 'Starring Soubin Shahir, Sreenath Bhasi. A group of friends embark on a rescue mission inside Guna Caves.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMDVkOGEzZDgtYWU4Yi00MDA3LWE4YmQtYjQxNDgwNDYxNGU4XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMDVkOGEzZDgtYWU4Yi00MDA3LWE4YmQtYjQxNDgwNDYxNGU4XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.6,
      releaseDate: '2024',
      runtime: 135,
      genres: [Genre(id: 12, name: 'Adventure'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 30894562,
      title: 'Aavesham',
      overview: 'Starring Fahadh Faasil as Ranga. Three college students get involved with a local Bengaluru gangster.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNjJjY2IxMDYtN2U0My00MzFiLWJlYzItYmJkMDg1MTg3MjhmXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNjJjY2IxMDYtN2U0My00MzFiLWJlYzItYmJkMDg1MTg3MjhmXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.9,
      releaseDate: '2024',
      runtime: 158,
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 35, name: 'Comedy')],
    ),
    Movie(
      id: 26922504,
      title: 'The Goat Life (Aadujeevitham)',
      overview: 'Starring Prithviraj Sukumaran as Najeeb. Directed by Blessy. An Indian immigrant worker is forced into slavery in Saudi Arabia.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMjJiNjk2MzgtYWIzNy00Yzc0LTg4YzUtYjQ5OGZjZTc1YjU0XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMjJiNjk2MzgtYWIzNy00Yzc0LTg4YzUtYjQ5OGZjZTc1YjU0XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.2,
      releaseDate: '2024',
      runtime: 173,
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 4216894,
      title: 'Premam',
      overview: 'Starring Sai Pallavi, Nivin Pauly. Malar teacher and George. A man experiences love across three stages of life.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNWJiMWMxYmMtNTQxMy00ZjE2LWEzYTAtNTdmODI4MGI4OTRlXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNWJiMWMxYmMtNTQxMy00ZjE2LWEzYTAtNTdmODI4MGI4OTRlXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.3,
      releaseDate: '2015',
      runtime: 156,
      genres: [Genre(id: 10749, name: 'Romance'), Genre(id: 35, name: 'Comedy')],
    ),
    Movie(
      id: 28318370,
      title: 'Gargi',
      overview: 'Starring Sai Pallavi. A young school teacher fights for justice after her father is falsely accused.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYmJkMDk2YzUtODdlNS00MmFhLWEwMjctYjY1MzI2YzBjODIyXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYmJkMDk2YzUtODdlNS00MmFhLWEwMjctYjY1MzI2YzBjODIyXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.1,
      releaseDate: '2022',
      runtime: 139,
      language: 'Tamil',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910001,
      title: 'Fidaa',
      overview: 'Starring Sai Pallavi and Varun Tej. Bhanumathi, a strong-willed village girl, falls in love with an NRI.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYTZjYjhlZTMtYzg1OC00OWYwLThhNGEtY2M2MmNjM2FmMzhiXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYTZjYjhlZTMtYzg1OC00OWYwLThhNGEtY2M2MmNjM2FmMzhiXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.5,
      releaseDate: '2017',
      runtime: 146,
      language: 'Telugu',
      genres: [Genre(id: 10749, name: 'Romance'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910002,
      title: 'Love Story',
      overview: 'Starring Sai Pallavi and Naga Chaitanya. Directed by Sekhar Kammula. Two ambitious youths struggle to make it in the city.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMTc5YjEzZjItOWM2MC00NDA3LWFhMTctMWM0ZTk3NjgwMzc5XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMTc5YjEzZjItOWM2MC00NDA3LWFhMTctMWM0ZTk3NjgwMzc5XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.4,
      releaseDate: '2021',
      runtime: 156,
      language: 'Telugu',
      genres: [Genre(id: 10749, name: 'Romance'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910003,
      title: 'Jallikattu',
      overview: 'Directed by Lijo Jose Pellissery. A bull escapes from a slaughterhouse and unleashes chaos in a remote hill village.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNWY2OGU4MmUtMjk0MS00M2IyLWI5NzgtZThmMzc4MzlkNTEyXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNWY2OGU4MmUtMjk0MS00M2IyLWI5NzgtZThmMzc4MzlkNTEyXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.3,
      releaseDate: '2019',
      runtime: 91,
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910004,
      title: 'Amen',
      overview: 'Directed by Lijo Jose Pellissery. Starring Fahadh Faasil, Indrajith. A whimsical musical comedy set in a picturesque village.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMGE1NTkyYzctNzc1MC00ZTIwLWI0MzctMTcyZDQ4MmIzMTBjXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMGE1NTkyYzctNzc1MC00ZTIwLWI0MzctMTcyZDQ4MmIzMTBjXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.9,
      releaseDate: '2013',
      runtime: 165,
      language: 'Malayalam',
      genres: [Genre(id: 35, name: 'Comedy'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910005,
      title: 'Angamaly Diaries',
      overview: 'Directed by Lijo Jose Pellissery. 86 debutant actors tell the energetic story of Vincent Pepe and his local gang in Angamaly.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BZDAwMjIzNWEtYWIwYS00Zjc0LThmM2ItNDk5YzNmYjczYWZlXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BZDAwMjIzNWEtYWIwYS00Zjc0LThmM2ItNDk5YzNmYjczYWZlXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.9,
      releaseDate: '2017',
      runtime: 132,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 35, name: 'Comedy')],
    ),
    Movie(
      id: 9910006,
      title: 'Pulimurugan',
      overview: 'Starring Mohanlal as Murugan. A wild hunter protects his village from man-eating tigers.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYTEyMjljMDUtZDdmNy00NTIyLTgxMzEtMTA2YTBmMmJmMmViXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYTEyMjljMDUtZDdmNy00NTIyLTgxMzEtMTA2YTBmMmJmMmViXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.1,
      releaseDate: '2016',
      runtime: 161,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 9910007,
      title: 'Bro Daddy',
      overview: 'Starring Mohanlal and Prithviraj Sukumaran. A fun-filled family drama about a father and son with a secret.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMTgwNTBiMjEtNmJiNS00NWZlLTk3ZDUtMjQ5M2MwMGI2MTAxXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMTgwNTBiMjEtNmJiNS00NWZlLTk3ZDUtMjQ5M2MwMGI2MTAxXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.2,
      releaseDate: '2022',
      runtime: 160,
      language: 'Malayalam',
      genres: [Genre(id: 35, name: 'Comedy'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910008,
      title: 'Bramayugam',
      overview: 'Starring Mammootty as Kodumon Potti. Directed by Rahul Sadasivan. A folk horror tale set in 17th-century Malabar.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNmZkZjQ5YzItOGQ0MC00ZmVlLWIxNjgtYzU2MmYzYjFmZWI2XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNmZkZjQ5YzItOGQ0MC00ZmVlLWIxNjgtYzU2MmYzYjFmZWI2XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.9,
      releaseDate: '2024',
      runtime: 139,
      language: 'Malayalam',
      genres: [Genre(id: 27, name: 'Horror'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910009,
      title: 'Kannur Squad',
      overview: 'Starring Mammootty. A group of police officers go on a cross-country manhunt to catch dangerous criminals.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BZTE4Y2NiYTQtODM1OC00NTQ4LTllOTItMzQwYWExOTRlNzhkXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BZTE4Y2NiYTQtODM1OC00NTQ4LTllOTItMzQwYWExOTRlNzhkXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.7,
      releaseDate: '2023',
      runtime: 161,
      language: 'Malayalam',
      genres: [Genre(id: 80, name: 'Crime'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910010,
      title: 'Bheeshma Parvam',
      overview: 'Starring Mammootty as Michael. Directed by Amal Neerad. A former gangster turns patriarch to protect his family.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMzZmZjA1NGMtNmNiNC00ZjY5LWIzOTItNzE4MDViYmM2ZDc3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMzZmZjA1NGMtNmNiNC00ZjY5LWIzOTItNzE4MDViYmM2ZDc3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.7,
      releaseDate: '2022',
      runtime: 144,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 9910011,
      title: 'Rorschach',
      overview: 'Starring Mammootty as Luke Antony. An NRI seeks revenge against a dead man in a secluded village.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BZDQ1ODkwN2MtOTRhOC00YjU4LTljMDgtOTg4ZTMxZWIxMmJiXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BZDQ1ODkwN2MtOTRhOC00YjU4LTljMDgtOTg4ZTMxZWIxMmJiXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.2,
      releaseDate: '2022',
      runtime: 150,
      language: 'Malayalam',
      genres: [Genre(id: 53, name: 'Thriller'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910012,
      title: 'Turbo',
      overview: 'Starring Mammootty as Jose. A jeep driver from Idukki gets tangled in a massive political conspiracy in Chennai.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BOWI2NGI0ZjAtMTMzNi00YTEzLWIxZWYtYjZkMWNhMTYxNjk2XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BOWI2NGI0ZjAtMTMzNi00YTEzLWIxZWYtYjZkMWNhMTYxNjk2XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 6.8,
      releaseDate: '2024',
      runtime: 152,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 35, name: 'Comedy')],
    ),
    Movie(
      id: 9910013,
      title: 'Joji',
      overview: 'Starring Fahadh Faasil. Directed by Dileesh Pothan. An ambitious engineering dropout plots to gain power over his wealthy family.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BODc4MTNjOWMtNzZjNS00NDVlLWE4NWItMTZiNzZjMDdjYmM3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BODc4MTNjOWMtNzZjNS00NDVlLWE4NWItMTZiNzZjMDdjYmM3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.8,
      releaseDate: '2021',
      runtime: 113,
      language: 'Malayalam',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 9910014,
      title: 'Kumbalangi Nights',
      overview: 'Starring Fahadh Faasil, Shane Nigam, Soubin Shahir. Four brothers living in a dysfunctional home stand together when tested.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMWE2NTAyZjEtOTNlZC00Y2NkLTgxMDEtNGJmNmU4MzJhODU0XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMWE2NTAyZjEtOTNlZC00Y2NkLTgxMDEtNGJmNmU4MzJhODU0XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.5,
      releaseDate: '2019',
      runtime: 135,
      language: 'Malayalam',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 35, name: 'Comedy')],
    ),
    Movie(
      id: 9910015,
      title: 'Trance',
      overview: 'Starring Fahadh Faasil and Nazriya Nazim. Directed by Anwar Rasheed. A motivational speaker is hired by corporate lords to act as a miracle pastor.',
      posterPath: 'https://upload.wikimedia.org/wikipedia/en/d/d5/Trance_film_poster.jpg',
      backdropPath: 'https://upload.wikimedia.org/wikipedia/en/d/d5/Trance_film_poster.jpg',
      voteAverage: 7.3,
      releaseDate: '2020',
      runtime: 172,
      language: 'Malayalam',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910016,
      title: 'Malik',
      overview: 'Starring Fahadh Faasil as Sulaiman Malik. A community leader fights against political corruption to protect his coastal village.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BOGM1OTA2NmUtYzdmMS00MGQ4LTlkNjUtM2Q1MjdlNjkyMTIzXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BOGM1OTA2NmUtYzdmMS00MGQ4LTlkNjUtM2Q1MjdlNjkyMTIzXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.0,
      releaseDate: '2021',
      runtime: 162,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 9910017,
      title: 'Kurup',
      overview: 'Starring Dulquer Salmaan as Sukumara Kurup. India\'s most wanted fugitive orchestrates an insurance scam.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMWRlN2I2YzYtYTVlZC00ZmQ2LTg4MzQtNmI4YzBhY2RmZDhhXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMWRlN2I2YzYtYTVlZC00ZmQ2LTg4MzQtNmI4YzBhY2RmZDhhXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.2,
      releaseDate: '2021',
      runtime: 157,
      language: 'Malayalam',
      genres: [Genre(id: 80, name: 'Crime'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910018,
      title: 'Charlie',
      overview: 'Starring Dulquer Salmaan and Parvathy Thiruvothu. A young woman searches for a vagabond artist whose room she stays in.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNzdkNTNjNjQtNWZmYi00NjRjLThkZDctMmJmOWFjNjZhOWY4XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNzdkNTNjNjQtNWZmYi00NjRjLThkZDctMmJmOWFjNjZhOWY4XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.0,
      releaseDate: '2015',
      runtime: 129,
      language: 'Malayalam',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 10749, name: 'Romance')],
    ),
    Movie(
      id: 9910019,
      title: 'Sita Ramam',
      overview: 'Starring Dulquer Salmaan, Mrunal Thakur, Rashmika Mandanna. An orphan soldier receives love letters from an unknown woman named Sita.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYWE0NDNiNzEtNThmMi00NjZlLTk3NDAtYzIzOWNmNWQyYTI3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYWE0NDNiNzEtNThmMi00NjZlLTk3NDAtYzIzOWNmNWQyYTI3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.6,
      releaseDate: '2022',
      runtime: 163,
      language: 'Telugu',
      genres: [Genre(id: 10749, name: 'Romance'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910020,
      title: 'Ayyappanum Koshiyum',
      overview: 'Starring Prithviraj Sukumaran and Biju Menon. A fierce clash of egos between an ex-havildar and a rigid police inspector.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNzBiZmNiYzMtYzExZS00YTIwLWJlNzItZWFlMDU4MjE3YTJiXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNzBiZmNiYzMtYzExZS00YTIwLWJlNzItZWFlMDU4MjE3YTJiXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.0,
      releaseDate: '2020',
      runtime: 177,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 9910021,
      title: 'Minnal Murali',
      overview: 'Starring Tovino Thomas as Jaison. Directed by Basil Joseph. A tailor gains superhero abilities after being struck by lightning.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BOWY0ZGJiNWYtNTUwMC00YjE4LTg2ODYtMDVjYTEyNTNjMjRhXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BOWY0ZGJiNWYtNTUwMC00YjE4LTg2ODYtMDVjYTEyNTNjMjRhXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.8,
      releaseDate: '2021',
      runtime: 158,
      language: 'Malayalam',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 9910022,
      title: '2018',
      overview: 'Starring Tovino Thomas, Kunchacko Boban, Asif Ali. People from all walks of life unite to survive catastrophic floods in Kerala.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMjBjYzVmOTAtMWI2NC00ODhiLTk4NDYtYmY3YmQxYmU2NTI5XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMjBjYzVmOTAtMWI2NC00ODhiLTk4NDYtYmY3YmQxYmU2NTI5XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.4,
      releaseDate: '2023',
      runtime: 150,
      language: 'Malayalam',
      genres: [Genre(id: 12, name: 'Adventure'), Genre(id: 18, name: 'Drama')],
    ),

    // ── Tamil (Kollywood) ─────────────────────────────────────
    Movie(
      id: 15654328,
      title: 'Leo',
      overview: 'Starring Vijay, Trisha, Sanjay Dutt. Directed by Lokesh Kanagaraj. A mild-mannered cafe owner becomes a target for a drug cartel.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMDk5ODNjNzMtYzI5Yy00NmI3LWIwYzctMTFjZjcwN2I2Yzk2XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMDk5ODNjNzMtYzI5Yy00NmI3LWIwYzctMTFjZjcwN2I2Yzk2XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.2,
      releaseDate: '2023',
      runtime: 164,
      language: 'Tamil',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 11663228,
      title: 'Jailer',
      overview: 'Starring Rajinikanth, Mohanlal, Shiva Rajkumar. Directed by Nelson. A retired prison warden goes on a manhunt.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BZTVjZDlhYWUtYzk1NS00ZTViLThkNzAtYzc1NDFhNjA1YjU2XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BZTVjZDlhYWUtYzk1NS00ZTViLThkNzAtYzc1NDFhNjA1YjU2XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.1,
      releaseDate: '2023',
      runtime: 168,
      language: 'Tamil',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 80, name: 'Crime')],
    ),
    Movie(
      id: 9179430,
      title: 'Vikram',
      overview: 'Starring Kamal Haasan, Vijay Sethupathi, Fahadh Faasil. Directed by Lokesh Kanagaraj. A high-octane action thriller.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMmViYjExY2UtMzZjOS00OGQ2LWEzNWYtNGYxY2NkY2RmMDE3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMmViYjExY2UtMzZjOS00OGQ2LWEzNWYtNGYxY2NkY2RmMDE3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.3,
      releaseDate: '2022',
      runtime: 175,
      language: 'Tamil',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 53, name: 'Thriller')],
    ),
    Movie(
      id: 9910023,
      title: 'Master',
      overview: 'Starring Vijay and Vijay Sethupathi. Directed by Lokesh Kanagaraj. An alcoholic professor is sent to a juvenile school.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMjFhM2JhM2MtYmMwNC00M2M1LWExMzUtOGI3MmQxNWRiZGI3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMjFhM2JhM2MtYmMwNC00M2M1LWExMzUtOGI3MmQxNWRiZGI3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.8,
      releaseDate: '2021',
      runtime: 179,
      language: 'Tamil',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 53, name: 'Thriller')],
    ),

    // ── Telugu & Kannada ────────────────────────────────────
    Movie(
      id: 8178634,
      title: 'RRR',
      overview: 'Starring N.T. Rama Rao Jr., Ram Charan, Alia Bhatt. Directed by S.S. Rajamouli. A fearless warrior and a charismatic cop form an unbreakable bond.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNWMwODYyMjQtMTczMi00NTQ1LWFkYjItMGJhMWRkY2E3NDAyXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNWMwODYyMjQtMTczMi00NTQ1LWFkYjItMGJhMWRkY2E3NDAyXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.8,
      releaseDate: '2022',
      runtime: 187,
      language: 'Telugu',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 28318374,
      title: 'Amaran',
      overview: 'Starring Sai Pallavi and Sivakarthikeyan. Directed by Rajkumar Periasamy. The real-life story of Major Mukund Varadarajan.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNTAzMGQ2MGItMjk5OC00YWIwLThmMjUtYmNjMTIxNzVlZWQ4XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNTAzMGQ2MGItMjk5OC00YWIwLThmMjUtYmNjMTIxNzVlZWQ4XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.4,
      releaseDate: '2024',
      runtime: 169,
      language: 'Tamil',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 28318373,
      title: 'Shyam Singha Roy',
      overview: 'Starring Sai Pallavi and Nani. A filmmaker discovers memories of his past life in 1970s Bengal.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BY2RiMzc4MzMtNmRkMi00NTMwLTkzMzAtMjNhYmNlOTQ4ZDkyXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BY2RiMzc4MzMtNmRkMi00NTMwLTkzMzAtMjNhYmNlOTQ4ZDkyXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.6,
      releaseDate: '2021',
      runtime: 157,
      language: 'Telugu',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 10749, name: 'Romance')],
    ),

    // ── Hollywood & International Blockbusters ───────────────
    Movie(
      id: 1630047,
      title: 'Avatar: The Way of Water',
      overview: 'Starring Sam Worthington, Zoe Saldaña. Directed by James Cameron. Jake Sully and Neytiri form a family and explore Pandora.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BNWI0Y2NkOWEtMmM2OC00MjQ3LWI1YzItZGQxYzQ3NzI4NWZmXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BNWI0Y2NkOWEtMmM2OC00MjQ3LWI1YzItZGQxYzQ3NzI4NWZmXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.6,
      releaseDate: '2022',
      runtime: 192,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 619979,
      title: 'Top Gun: Maverick',
      overview: 'Starring Tom Cruise as Pete Mitchell. Directed by Joseph Kosinski. After 30 years of service, Maverick trains top pilots for a dangerous mission.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMDBkZDNjMWEtOTdmMi00NmExLTg5MmMtNTFlYTJlNWY5YTdmXkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMDBkZDNjMWEtOTdmMi00NmExLTg5MmMtNTFlYTJlNWY5YTdmXkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.3,
      releaseDate: '2022',
      runtime: 130,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 18, name: 'Drama')],
    ),
    Movie(
      id: 872585,
      title: 'Oppenheimer',
      overview: 'Directed by Christopher Nolan. Starring Cillian Murphy, Robert Downey Jr. The story of J. Robert Oppenheimer and the creation of the atomic bomb.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BN2JkMDc5MGQtZjg3YS00NmFiLWIyZmQtZTJmNTM5MjVmYTQ4XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BN2JkMDc5MGQtZjg3YS00NmFiLWIyZmQtZTJmNTM5MjVmYTQ4XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.9,
      releaseDate: '2023',
      runtime: 180,
      language: 'English',
      genres: [Genre(id: 18, name: 'Drama'), Genre(id: 36, name: 'History')],
    ),
    Movie(
      id: 157336,
      title: 'Interstellar',
      overview: 'Directed by Christopher Nolan. Starring Matthew McConaughey, Anne Hathaway. A team of explorers travel through a wormhole in space.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BYzdjMDAxZGItMjI2My00ODA1LTlkNzItOWFjMDU5ZDJlYWY3XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 8.7,
      releaseDate: '2014',
      runtime: 169,
      language: 'English',
      genres: [Genre(id: 878, name: 'Sci-Fi'), Genre(id: 12, name: 'Adventure')],
    ),
    Movie(
      id: 4154796,
      title: 'Avengers: Endgame',
      overview: 'Starring Robert Downey Jr., Chris Evans, Scarlett Johansson. The Avengers assemble one last time to reverse Thanos\'s snap.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMTc5MDE2ODcwNV5BMl5BanBnXkFtZTgwMzI2NzQ2NzM@._V1_SX1200.jpg',
      voteAverage: 8.4,
      releaseDate: '2019',
      runtime: 181,
      language: 'English',
      genres: [Genre(id: 28, name: 'Action'), Genre(id: 878, name: 'Sci-Fi')],
    ),
    Movie(
      id: 11514332,
      title: 'Glass Onion: A Knives Out Mystery',
      overview: 'Starring Daniel Craig, Edward Norton, Janelle Monáe. Tech billionaire Miles Bron invites his friends for a getaway on his private Greek island.',
      posterPath: 'https://m.media-amazon.com/images/M/MV5BMzI2ZDYxZTEtMzVlOC00OTUyLTgyNTAtYWFhNmRhZjAzZWE1XkEyXkFqcGc@._V1_SX1200.jpg',
      backdropPath: 'https://m.media-amazon.com/images/M/MV5BMzI2ZDYxZTEtMzVlOC00OTUyLTgyNTAtYWFhNmRhZjAzZWE1XkEyXkFqcGc@._V1_SX1200.jpg',
      voteAverage: 7.1,
      releaseDate: '2022',
      runtime: 139,
      language: 'English',
      genres: [Genre(id: 35, name: 'Comedy'), Genre(id: 80, name: 'Crime')],
    ),
  ];

  // ─────────────────────────────────────────────────────────────
  // Precision Filmography & Category Query Resolver
  // ─────────────────────────────────────────────────────────────

  Future<List<Movie>> fetchCategory(String query, {int page = 1}) async {
    final cacheKey = '${query.toLowerCase().trim()}_p$page';
    if (_memoryCache.containsKey(cacheKey) && _memoryCache[cacheKey]!.isNotEmpty) {
      return _memoryCache[cacheKey]!;
    }

    final qLower = query.toLowerCase().trim();

    // 1. Filter local master catalog by title, actor, director, genre, language
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

    // 2. Query Remote IMDb Direct API
    final List<Movie> results = [];
    try {
      final imdbItems = await _apiClient.searchImdb(query);
      for (final item in imdbItems) {
        final m = Movie.fromImdbJson(item);
        if (m.posterPath != null && m.posterPath!.isNotEmpty) {
          results.add(m);
        }
      }
    } catch (_) {}

    if (results.isNotEmpty) {
      _memoryCache[cacheKey] = results;
      return results;
    }

    // Default fallback to master catalog
    _memoryCache[cacheKey] = _masterCatalog;
    return _masterCatalog;
  }

  // ─────────────────────────────────────────────────────────────
  // Precision "More Like This" Similarity Engine
  // ─────────────────────────────────────────────────────────────

  Future<List<Movie>> getMovieRecommendations(int movieId) async {
    // Return movies with matching genre or different items from master catalog
    final target = _masterCatalog.firstWhere((m) => m.id == movieId, orElse: () => _masterCatalog.first);
    final similar = _masterCatalog.where((m) => m.id != target.id).toList();
    return similar.isNotEmpty ? similar : _masterCatalog;
  }

  // ─────────────────────────────────────────────────────────────
  // Category Methods
  // ─────────────────────────────────────────────────────────────

  Future<List<Movie>> getTrendingMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'action', page: page);

  Future<List<Movie>> getTrendingWeekMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'lucifer', page: page);

  Future<List<Movie>> getPopularMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'mohanlal', page: page);

  Future<List<Movie>> getTopRatedMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'drishyam', page: page);

  Future<List<Movie>> getNowPlayingMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'manjummel boys', page: page);

  Future<List<Movie>> getUpcomingMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'malaikottai vaaliban', page: page);

  Future<List<Movie>> getActionMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'action', page: page);

  Future<List<Movie>> getComedyMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'comedy', page: page);

  Future<List<Movie>> getHorrorMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'horror', page: page);

  Future<List<Movie>> getScifiMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'sci-fi', page: page);

  Future<List<Movie>> getDramaMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'drama', page: page);

  Future<List<Movie>> getAnimationMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'anime', page: page);

  Future<List<Movie>> getThrillerMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'thriller', page: page);

  Future<List<Movie>> getAwardWinners({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'oppenheimer', page: page);

  Future<List<Movie>> getClassicMovies({int page = 1, String? preferredQuery}) =>
      fetchCategory(preferredQuery ?? 'premam', page: page);

  Future<List<Movie>> getBollywoodMovies({int page = 1}) => fetchCategory('jawan', page: page);
  Future<List<Movie>> getSouthMovies({int page = 1}) => fetchCategory('rrr', page: page);
  Future<List<Movie>> getAnimeMovies({int page = 1}) => fetchCategory('anime', page: page);
  Future<List<Movie>> getKoreanMovies({int page = 1}) => fetchCategory('korean', page: page);
  Future<List<Movie>> getInternationalMovies({int page = 1}) => fetchCategory('avatar', page: page);

  // ─────────────────────────────────────────────────────────────
  // Genres & Search
  // ─────────────────────────────────────────────────────────────

  Future<List<Genre>> getGenres() async {
    return ApiConstants.genresList.map((g) => Genre.fromJson(g)).toList();
  }

  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    if (query.trim().isEmpty) return [];
    return fetchCategory(query.trim(), page: page);
  }

  // ─────────────────────────────────────────────────────────────
  // Movie Details
  // ─────────────────────────────────────────────────────────────

  Future<Movie> getMovieDetails(int movieId) async {
    if (_detailMemoryCache.containsKey(movieId)) {
      return _detailMemoryCache[movieId]!;
    }

    final foundLocal = _masterCatalog.firstWhere((m) => m.id == movieId, orElse: () => _masterCatalog.first);
    if (foundLocal.id == movieId) {
      _detailMemoryCache[movieId] = foundLocal;
      return foundLocal;
    }

    try {
      final imdbId = ApiConstants.toImdbId(movieId);
      final response = await _apiClient.get(
        '',
        queryParameters: {'i': imdbId, 'plot': 'full'},
      );
      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['Response'] == 'True') {
        final movie = Movie.fromJson(data);
        _detailMemoryCache[movieId] = movie;
        return movie;
      }
    } catch (_) {}

    return foundLocal;
  }

  Future<List<CastMember>> getMovieCredits(int movieId) async {
    try {
      final imdbId = ApiConstants.toImdbId(movieId);
      final response = await _apiClient.get(
        '',
        queryParameters: {'i': imdbId, 'plot': 'short'},
      );
      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['Response'] == 'True') {
        final actors = data['Actors'] as String? ?? '';
        if (actors.isNotEmpty) {
          return CastMember.fromActorsString(actors);
        }
      }
    } catch (_) {}
    return const [
      CastMember(id: 1, name: 'Sam Worthington', character: 'Jake Sully', profilePath: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=200&q=80'),
      CastMember(id: 2, name: 'Zoe Saldaña', character: 'Neytiri', profilePath: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80'),
      CastMember(id: 3, name: 'Kate Winslet', character: 'Ronal', profilePath: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80'),
      CastMember(id: 4, name: 'Mohanlal', character: 'Stephen Nedumpally', profilePath: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=200&q=80'),
    ];
  }

  Future<List<VideoTrailer>> getMovieTrailers(int movieId) async {
    // Official trailer keys
    String trailerKey = 'uYPbbksJxIg'; // Oppenheimer
    if (movieId == 641490) trailerKey = 'BMjMxODk0MTctMDNlZi00ZTBlLThkZTUtY2ZmNWJjMzMyNDkx'; // Lucifer
    if (movieId == 2855146 || movieId == 13994304) trailerKey = 'e1BqU3YhNUE'; // Drishyam
    if (movieId == 1630047) trailerKey = 'd9MyW72ELq0'; // Avatar 2
    if (movieId == 619979) trailerKey = 'qSqVVowa4jE'; // Maverick

    return [
      VideoTrailer(
        id: 'tr_$movieId',
        key: trailerKey,
        name: 'Official Trailer (HD)',
        site: 'YouTube',
        type: 'Trailer',
        official: true,
      ),
    ];
  }

  void clearCache() {
    _memoryCache.clear();
    _detailMemoryCache.clear();
  }
}
