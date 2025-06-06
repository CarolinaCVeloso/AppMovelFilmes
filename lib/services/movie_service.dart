import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String baseUrl = 'https://6842015cd48516d1d35d857a.mockapi.io/api/movies';

  // Get all movies
  Future<List<Movie>> getMovies() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Movie.fromJson({
          'id': json['id'],
          'title': json['nome'],
          'imageUrl': json['url_imagem'],
          'genre': json['genero'],
          'ageRating': json['faixa_etaria'].toString(),
          'duration': json['duracao'],
          'year': json['ano'],
          'rating': (json['pontuacao'] ?? 0.0).toDouble() / 20, // Converte de 0-100 para 0-5
          'description': json['descricao'],
        })).toList();
      }
      throw Exception('Failed to load movies');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create a new movie
  Future<Movie> createMovie(Movie movie) async {
    try {
      // Converter a faixa etária para inteiro
      int faixaEtaria;
      try {
        // Remove "anos" e espaços, depois converte para inteiro
        faixaEtaria = int.parse(movie.ageRating.replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        faixaEtaria = 0; // valor padrão caso a conversão falhe
      }

      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': movie.title,
          'url_imagem': movie.imageUrl,
          'descricao': movie.description,
          'faixa_etaria': faixaEtaria,
          'genero': movie.genre,
          'duracao': movie.duration,
          'pontuacao': (movie.rating * 20).round(), // Converte para escala de 0-100
          'ano': movie.year,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        return Movie.fromJson({
          'id': data['id'],
          'title': data['nome'],
          'imageUrl': data['url_imagem'],
          'genre': data['genero'],
          'ageRating': data['faixa_etaria'].toString(),
          'duration': data['duracao'],
          'year': data['ano'],
          'rating': (data['pontuacao'] ?? 0.0).toDouble() / 20, // Converte de volta para escala 0-5
          'description': data['descricao'],
        });
      }
      throw Exception('Failed to create movie');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Update a movie
  Future<Movie> updateMovie(Movie movie) async {
    try {
      // Converter a faixa etária para inteiro
      int faixaEtaria;
      try {
        // Remove "anos" e espaços, depois converte para inteiro
        faixaEtaria = int.parse(movie.ageRating.replaceAll(RegExp(r'[^0-9]'), ''));
      } catch (e) {
        faixaEtaria = 0; // valor padrão caso a conversão falhe
      }

      final response = await http.put(
        Uri.parse('$baseUrl/${movie.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': movie.title,
          'url_imagem': movie.imageUrl,
          'descricao': movie.description,
          'faixa_etaria': faixaEtaria,
          'genero': movie.genre,
          'duracao': movie.duration,
          'pontuacao': (movie.rating * 20).round(), // Converte para escala de 0-100
          'ano': movie.year,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Movie.fromJson({
          'id': data['id'],
          'title': data['nome'],
          'imageUrl': data['url_imagem'],
          'genre': data['genero'],
          'ageRating': data['faixa_etaria'].toString(),
          'duration': data['duracao'],
          'year': data['ano'],
          'rating': (data['pontuacao'] ?? 0.0).toDouble() / 20, // Converte de volta para escala 0-5
          'description': data['descricao'],
        });
      }
      throw Exception('Failed to update movie');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Delete a movie
  Future<void> deleteMovie(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode != 200) {
        throw Exception('Failed to delete movie');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
