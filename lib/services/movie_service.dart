import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class FilmeService {
  static const String urlBase = 'https://6842015cd48516d1d35d857a.mockapi.io/api/movies';

  // Get all movies
  Future<List<Filme>> buscarFilmes() async {
    try {
      final resposta = await http.get(Uri.parse(urlBase));
      if (resposta.statusCode == 200) {
        final List<dynamic> dados = json.decode(resposta.body);
        return dados.map((json) {
          String faixaEtariaStr;
          int faixaEtaria = json['faixa_etaria'] ?? 0;
          if (faixaEtaria == 0) {
            faixaEtariaStr = 'Livre';
          } else {
            faixaEtariaStr = '$faixaEtaria anos';
          }
          return Filme.fromJson({
            'id': json['id'],
            'titulo': json['nome'],
            'urlImagem': json['url_imagem'],
            'genero': json['genero'],
            'faixaEtaria': faixaEtariaStr,
            'duracao': json['duracao'],
            'ano': json['ano'],
            'pontuacao': (json['pontuacao'] ?? 0.0).toDouble() / 20,
            'descricao': json['descricao'],
          });
        }).toList();
      }
      throw Exception('Erro ao carregar filmes');
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Create a new movie
  Future<Filme> criarFilme(Filme filme) async {
    try {
      int faixaEtaria;
      if (filme.faixaEtaria == 'Livre') {
        faixaEtaria = 0;
      } else {
        faixaEtaria = int.parse(filme.faixaEtaria.replaceAll(RegExp(r'[^0-9]'), ''));
      }
      final resposta = await http.post(
        Uri.parse(urlBase),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': filme.titulo,
          'url_imagem': filme.urlImagem,
          'descricao': filme.descricao,
          'faixa_etaria': faixaEtaria,
          'genero': filme.genero,
          'duracao': filme.duracao,
          'pontuacao': (filme.pontuacao * 20).round(),
          'ano': filme.ano,
        }),
      );
      if (resposta.statusCode == 201) {
        final data = json.decode(resposta.body);
        String faixaEtariaStr;
        int faixaEtaria = data['faixa_etaria'] ?? 0;
        if (faixaEtaria == 0) {
          faixaEtariaStr = 'Livre';
        } else {
          faixaEtariaStr = '$faixaEtaria anos';
        }
        return Filme.fromJson({
          'id': data['id'],
          'titulo': data['nome'],
          'urlImagem': data['url_imagem'],
          'genero': data['genero'],
          'faixaEtaria': faixaEtariaStr,
          'duracao': data['duracao'],
          'ano': data['ano'],
          'pontuacao': (data['pontuacao'] ?? 0.0).toDouble() / 20,
          'descricao': data['descricao'],
        });
      }
      throw Exception('Erro ao criar filme');
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Update a movie
  Future<Filme> atualizarFilme(Filme filme) async {
    try {
      int faixaEtaria;
      if (filme.faixaEtaria == 'Livre') {
        faixaEtaria = 0;
      } else {
        faixaEtaria = int.parse(filme.faixaEtaria.replaceAll(RegExp(r'[^0-9]'), ''));
      }
      final resposta = await http.put(
        Uri.parse('$urlBase/${filme.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nome': filme.titulo,
          'url_imagem': filme.urlImagem,
          'descricao': filme.descricao,
          'faixa_etaria': faixaEtaria,
          'genero': filme.genero,
          'duracao': filme.duracao,
          'pontuacao': (filme.pontuacao * 20).round(),
          'ano': filme.ano,
        }),
      );
      if (resposta.statusCode == 200) {
        final data = json.decode(resposta.body);
        String faixaEtariaStr;
        int faixaEtaria = data['faixa_etaria'] ?? 0;
        if (faixaEtaria == 0) {
          faixaEtariaStr = 'Livre';
        } else {
          faixaEtariaStr = '$faixaEtaria anos';
        }
        return Filme.fromJson({
          'id': data['id'],
          'titulo': data['nome'],
          'urlImagem': data['url_imagem'],
          'genero': data['genero'],
          'faixaEtaria': faixaEtariaStr,
          'duracao': data['duracao'],
          'ano': data['ano'],
          'pontuacao': (data['pontuacao'] ?? 0.0).toDouble() / 20,
          'descricao': data['descricao'],
        });
      }
      throw Exception('Erro ao atualizar filme');
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }

  // Delete a movie
  Future<void> deletarFilme(String id) async {
    try {
      final resposta = await http.delete(Uri.parse('$urlBase/$id'));
      if (resposta.statusCode != 200) {
        throw Exception('Erro ao deletar filme');
      }
    } catch (e) {
      throw Exception('Erro: $e');
    }
  }
}
