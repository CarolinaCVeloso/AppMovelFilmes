// lib/models/movie.dart
class Filme {
  final String id;
  final String titulo;
  final String urlImagem;
  final String genero;
  final String faixaEtaria;
  final String duracao;
  final int ano;
  final double pontuacao;
  final String descricao;

  Filme({
    required this.id,
    required this.titulo,
    required this.urlImagem,
    required this.genero,
    required this.faixaEtaria,
    required this.duracao,
    required this.ano,
    required this.pontuacao,
    required this.descricao,
  });

  // Converter para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'urlImagem': urlImagem,
      'genero': genero,
      'faixaEtaria': faixaEtaria,
      'duracao': duracao,
      'ano': ano,
      'pontuacao': pontuacao,
      'descricao': descricao,
    };
  }

  // Criar instância a partir de JSON
  factory Filme.fromJson(Map<String, dynamic> json) {
    return Filme(
      id: json['id'] ?? '',
      titulo: json['titulo'] ?? '',
      urlImagem: json['urlImagem'] ?? '',
      genero: json['genero'] ?? '',
      faixaEtaria: json['faixaEtaria'] ?? '',
      duracao: json['duracao'] ?? '',
      ano: json['ano'] ?? 0,
      pontuacao: (json['pontuacao'] ?? 0.0).toDouble(),
      descricao: json['descricao'] ?? '',
    );
  }

  // Criar cópia com modificações
  Filme copyWith({
    String? id,
    String? titulo,
    String? urlImagem,
    String? genero,
    String? faixaEtaria,
    String? duracao,
    int? ano,
    double? pontuacao,
    String? descricao,
  }) {
    return Filme(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      urlImagem: urlImagem ?? this.urlImagem,
      genero: genero ?? this.genero,
      faixaEtaria: faixaEtaria ?? this.faixaEtaria,
      duracao: duracao ?? this.duracao,
      ano: ano ?? this.ano,
      pontuacao: pontuacao ?? this.pontuacao,
      descricao: descricao ?? this.descricao,
    );
  }

  @override
  String toString() {
    return 'Filme(id: $id, titulo: $titulo, genero: $genero, ano: $ano)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Filme && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}