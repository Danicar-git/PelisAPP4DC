import 'dart:convert';

class TvSeries {
  int id;
  String name; // En series es 'name', no 'title'
  String overview;
  String posterPath;
  double voteAverage;

  TvSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  factory TvSeries.fromMap(Map<String, dynamic> map) {
    return TvSeries(
      id: map['id'] as int,
      name: map['name'] ?? '',
      overview: map['overview'] ?? '',
      posterPath: map['poster_path'] ?? '',
      voteAverage: (map['vote_average'] as num).toDouble(),
    );
  }

  factory TvSeries.fromJson(String source) =>
      TvSeries.fromMap(json.decode(source) as Map<String, dynamic>);
}