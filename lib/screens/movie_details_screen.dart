import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'movie_registration_screen.dart';

class TelaDetalhesFilme extends StatefulWidget {
  final Filme filme;

  const TelaDetalhesFilme({
    Key? key,
    required this.filme,
  }) : super(key: key);

  @override
  State<TelaDetalhesFilme> createState() => _TelaDetalhesFilmeState();
}

class _TelaDetalhesFilmeState extends State<TelaDetalhesFilme> {
  late Filme _filme;
  final FilmeService _servicoFilme = FilmeService();
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _filme = widget.filme;
  }

  Future<void> _atualizarFilme() async {
    setState(() => _carregando = true);
    try {
      final filmes = await _servicoFilme.buscarFilmes();
      final filmeAtualizado = filmes.firstWhere((m) => m.id == _filme.id);
      setState(() {
        _filme = filmeAtualizado;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao atualizar filme: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _editarFilme() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TelaCadastroFilme(filmeInicial: _filme),
      ),
    );

    if (resultado == true) {
      _atualizarFilme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _filme.urlImagem,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: _editarFilme,
                tooltip: 'Editar filme',
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _filme.titulo,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.movie, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        _filme.genero,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoLinha(Icons.access_time, 'Duração', _filme.duracao),
                          const SizedBox(height: 8),
                          _infoLinha(Icons.person_outline, 'Faixa Etária', _filme.faixaEtaria),
                          const SizedBox(height: 8),
                          _infoLinha(Icons.calendar_today, 'Ano', _filme.ano.toString()),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(
                                'Avaliação',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(width: 8),
                              RatingBarIndicator(
                                rating: _filme.pontuacao > 5 ? 5 : _filme.pontuacao,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 20,
                                unratedColor: Colors.grey[300],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Sinopse',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        _filme.descricao,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoLinha(IconData icone, String rotulo, String valor) {
    return Row(
      children: [
        Icon(icone, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          '$rotulo: ',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 