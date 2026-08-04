class VideoTrailer {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  const VideoTrailer({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    required this.official,
  });

  bool get isYouTubeTrailer => site.toLowerCase() == 'youtube' && type.toLowerCase() == 'trailer';

  factory VideoTrailer.fromJson(Map<String, dynamic> json) {
    return VideoTrailer(
      id: json['id'] as String? ?? '',
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? 'Trailer',
      site: json['site'] as String? ?? '',
      type: json['type'] as String? ?? '',
      official: json['official'] as bool? ?? false,
    );
  }
}
