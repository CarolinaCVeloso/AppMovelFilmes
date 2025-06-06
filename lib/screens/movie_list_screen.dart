import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../services/movie_service.dart';
import 'movie_registration_screen.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({Key? key}) : super(key: key);

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  late Future<List<Movie>> _moviesFuture;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    setState(() {
      _moviesFuture = _movieService.getMovies();
    });
  }

  void _showGroupInfo() {
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

  Future<void> _openAddMovie() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MovieRegistrationScreen()),
    );
    if (result == true) {
      _loadMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Filmes'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showGroupInfo,
            tooltip: 'Informações do grupo',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMovies,
        child: FutureBuilder<List<Movie>>(
          future: _moviesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Carregando filmes...',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erro ao carregar filmes',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${snapshot.error}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _loadMovies,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            final movies = snapshot.data ?? [];
            if (movies.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.movie_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nenhum filme cadastrado',
                      style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Clique no botão + para adicionar um novo filme',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MovieCard(movie: movies[index]),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddMovie,
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar novo filme',
      ),
    );
  }
} 