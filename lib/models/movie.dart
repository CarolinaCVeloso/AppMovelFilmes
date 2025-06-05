// lib/models/movie.dart
class Movie {
  final String id;
  final String title;
  final String imageUrl;
  final String genre;
  final String ageRating;
  final String duration;
  final int year;
  final double rating;
  final String description;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.genre,
    required this.ageRating,
    required this.duration,
    required this.year,
    required this.rating,
    required this.description,
  });

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'genre': genre,
      'ageRating': ageRating,
      'duration': duration,
      'year': year,
      'rating': rating,
      'description': description,
    };
  }

  // Criar instância a partir de JSON
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      genre: json['genre'] ?? '',
      ageRating: json['ageRating'] ?? '',
      duration: json['duration'] ?? '',
      year: json['year'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  // Criar cópia com modificações
  Movie copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? genre,
    String? ageRating,
    String? duration,
    int? year,
    double? rating,
    String? description,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      genre: genre ?? this.genre,
      ageRating: ageRating ?? this.ageRating,
      duration: duration ?? this.duration,
      year: year ?? this.year,
      rating: rating ?? this.rating,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'Movie(id: $id, title: $title, genre: $genre, year: $year)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Movie && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}