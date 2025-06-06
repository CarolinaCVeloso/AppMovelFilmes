import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../widgets/movie_card.dart';
import '../services/movie_service.dart';
import 'movie_registration_screen.dart';
import 'movie_details_screen.dart';

class TelaListaFilmes extends StatefulWidget {
  const TelaListaFilmes({Key? key}) : super(key: key);

  @override
  State<TelaListaFilmes> createState() => _TelaListaFilmesState();
}

class _TelaListaFilmesState extends State<TelaListaFilmes> {
  late Future<List<Filme>> _futuroFilmes;
  final FilmeService _servicoFilme = FilmeService();

  @override
  void initState() {
    super.initState();
    _carregarFilmes();
  }

  Future<void> _carregarFilmes() async {
    setState(() {
      _futuroFilmes = _servicoFilme.buscarFilmes();
    });
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
    if (resultado == true) {
      _carregarFilmes();
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
            onPressed: _mostrarInfoGrupo,
            tooltip: 'Informações do grupo',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _carregarFilmes,
        child: FutureBuilder<List<Filme>>(
          future: _futuroFilmes,
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
                      onPressed: _carregarFilmes,
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

            final filmes = snapshot.data ?? [];
            if (filmes.isEmpty) {
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
              itemCount: filmes.length,
              itemBuilder: (context, index) {
                final filme = filmes[index];
                return Dismissible(
                  key: Key(filme.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white, size: 32),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirmar exclusão'),
                        content: Text('Deseja realmente excluir o filme "${filme.titulo}"?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancelar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Excluir'),
                          ),
                        ],
                      ),
                    );
                  },
                  onDismissed: (direction) async {
                    final idRemovido = filme.id;
                    setState(() {
                      filmes.removeAt(index);
                    });
                    try {
                      await _servicoFilme.deletarFilme(idRemovido);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Filme excluído com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao excluir filme: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      _carregarFilmes();
                    }
                  },
                  child: GestureDetector(
                    onTap: () => _abrirDetalhesFilme(filmes[index]),
                    child: CartaoFilme(filme: filmes[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirCadastroFilme,
        backgroundColor: Colors.deepPurple,
        elevation: 8,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar novo filme',
      ),
    );
  }
} 