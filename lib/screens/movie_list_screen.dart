import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import 'movie_registration_screen.dart';
import 'movie_details_screen.dart';

class TelaListaFilmes extends StatefulWidget {
  const TelaListaFilmes({Key? key}) : super(key: key);

  @override
  State<TelaListaFilmes> createState() => _TelaListaFilmesState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;

  @override
  void initState() {
    super.initState();
    _moviesFuture = _fetchMovies();
  }

  Future<List<Movie>> _fetchMovies() async {
    final url = Uri.parse('https://6842015cd48516d1d35d857a.mockapi.io/api/movies');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Movie(
        id: json['id'] ?? '',
        title: json['nome'] ?? '',
        imageUrl: json['url_imagem'] ?? '',
        description: json['descricao'] ?? '',
        ageRating: json['faixa_etaria'].toString(),
        genre: json['genero'] ?? '',
        duration: json['duracao'] ?? '',
        rating: (json['pontuacao'] is int ? (json['pontuacao'] as int).toDouble() : (json['pontuacao'] ?? 0.0).toDouble()) / 20, // normaliza para 0-5
        year: int.tryParse(json['ano'].toString()) ?? 0,
      )).toList();
    } else {
      throw Exception('Erro ao carregar filmes da API');
    }
  }

  void _mostrarInfoGrupo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informação'),
        content: const Text('Grupo Carolina, Camilly, Maysa e Rafael'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _abrirCadastroFilme() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TelaCadastroFilme()),
    );
    if (result == true) {
      setState(() {
        _moviesFuture = _fetchMovies();
      });
    }
  }

  void _abrirDetalhesFilme(Filme filme) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaDetalhesFilme(filme: filme),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Filmes'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _mostrarInfoGrupo,
            tooltip: 'Informações do grupo',
          ),
        ],
      ),
      body: FutureBuilder<List<Movie>>(
        future: _moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro:  ${snapshot.error}'));
          }
          final movies = snapshot.data ?? [];
          if (movies.isEmpty) {
            return const Center(child: Text('Nenhum filme cadastrado.'));
          }
          return ListView.builder(
            itemCount: movies.length,
            itemBuilder: (context, index) {
              return MovieCard(movie: movies[index]);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddMovie,
        backgroundColor: Colors.blue,
        elevation: 8,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar novo filme',
      ),
    );
  }
} 