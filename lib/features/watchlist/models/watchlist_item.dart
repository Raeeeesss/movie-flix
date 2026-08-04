import 'package:hive/hive.dart';
import '../../movies/models/movie.dart';

class WatchlistItem extends HiveObject {
  final int id;
  final String title;
  final String? posterPath;
  final double voteAverage;
  final String releaseDate;
  final String overview;

  WatchlistItem({
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
  });

  /// Genre names — not stored in Hive to preserve backward compat.
  /// Returns empty list; will be populated once IMDb genre data is cached.
  List<String> get genres => const [];

  factory WatchlistItem.fromMovie(Movie movie) {
    return WatchlistItem(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      overview: movie.overview,
    );
  }

  Movie toMovie() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterPath: posterPath,
      voteAverage: voteAverage,
      releaseDate: releaseDate,
    );
  }
}

class WatchlistItemAdapter extends TypeAdapter<WatchlistItem> {
  @override
  final int typeId = 0;

  @override
  WatchlistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistItem(
      id: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String?,
      voteAverage: fields[3] as double,
      releaseDate: fields[4] as String,
      overview: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.voteAverage)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.overview);
  }
}
