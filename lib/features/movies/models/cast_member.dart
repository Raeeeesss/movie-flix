class CastMember {
  final int id;
  final String name;
  final String character;
  final String? profilePath;

  const CastMember({
    required this.id,
    required this.name,
    required this.character,
    this.profilePath,
  });

  // Profile URL getter
  String? get profileUrl => null;

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unknown',
      character: json['character'] as String? ?? '',
      profilePath: json['profile_path'] as String?,
    );
  }

  /// Parse from IMDb comma-separated actors string.
  /// e.g. "Robert Downey Jr., Gwyneth Paltrow, Terrence Howard"
  static List<CastMember> fromActorsString(String actors) {
    return actors
        .split(',')
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty && name != 'N/A')
        .toList()
        .asMap()
        .entries
        .map((e) => CastMember(
              id: e.key,
              name: e.value,
              character: 'Actor',
            ))
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'character': character,
      'profile_path': profilePath,
    };
  }
}
