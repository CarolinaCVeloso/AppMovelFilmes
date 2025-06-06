import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../database/database_helper.dart';

class MovieController extends ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _movies = await _dbHelper.getAllMovies();
    } catch (e) {
      print('Erro ao carregar filmes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addMovie(Movie movie) async {
    try {
      await _dbHelper.insertMovie(movie);
      await loadMovies();
      return true;
    } catch (e) {
      print('Erro ao adicionar filme: $e');
      return false;
    }
  }

  Future<bool> updateMovie(Movie movie) async {
    try {
      await _dbHelper.updateMovie(movie);
      await loadMovies();
      return true;
    } catch (e) {
      print('Erro ao atualizar filme: $e');
      return false;
    }
  }

  Future<bool> deleteMovie(int id) async {
    try {
      await _dbHelper.deleteMovie(id);
      await loadMovies();
      return true;
    } catch (e) {
      print('Erro ao deletar filme: $e');
      return false;
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      return await _dbHelper.searchMovies(query);
    } catch (e) {
      print('Erro ao buscar filmes: $e');
      return [];
    }
  }

  Future<Movie?> getMovie(int id) async {
    try {
      return await _dbHelper.getMovie(id);
    } catch (e) {
      print('Erro ao buscar filme: $e');
      return null;
    }
  }
}
