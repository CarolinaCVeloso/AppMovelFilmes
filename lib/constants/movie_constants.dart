// lib/constants/movie_constants.dart
class MovieConstants {
  
  /// Lista de gêneros disponíveis para filmes
  static const List<String> genres = [
    'Ação',
    'Aventura',
    'Comédia',
    'Drama',
    'Ficção Científica',
    'Romance',
    'Terror',
    'Suspense',
    'Animação',
    'Documentário',
    'Musical',
    'Guerra',
    'Biografia',
    'Fantasia',
    'Crime',
    'Família',
    'História',
    'Mistério',
    'Western',
    'Thriller',
  ];

  /// Lista de classificações etárias brasileiras
  static const List<String> ageRatings = [
    'Livre',
    '10 anos',
    '12 anos',
    '14 anos',
    '16 anos',
    '18 anos',
  ];

  /// Mapa de classificações com suas descrições
  static const Map<String, String> ageRatingDescriptions = {
    'Livre': 'Livre para todos os públicos',
    '10 anos': 'Não recomendado para menores de 10 anos',
    '12 anos': 'Não recomendado para menores de 12 anos',
    '14 anos': 'Não recomendado para menores de 14 anos',
    '16 anos': 'Não recomendado para menores de 16 anos',
    '18 anos': 'Não recomendado para menores de 18 anos',
  };

  /// Mapa de gêneros com suas cores temáticas
  static const Map<String, int> genreColors = {
    'Ação': 0xFFFF5722,
    'Aventura': 0xFF4CAF50,
    'Comédia': 0xFFFFEB3B,
    'Drama': 0xFF9C27B0,
    'Ficção Científica': 0xFF2196F3,
    'Romance': 0xFFE91E63,
    'Terror': 0xFF424242,
    'Suspense': 0xFF795548,
    'Animação': 0xFFFF9800,
    'Documentário': 0xFF607D8B,
    'Musical': 0xFF9C27B0,
    'Guerra': 0xFF455A64,
    'Biografia': 0xFF8BC34A,
    'Fantasia': 0xFF673AB7,
    'Crime': 0xFF424242,
    'Família': 0xFF4CAF50,
    'História': 0xFF8D6E63,
    'Mistério': 0xFF37474F,
    'Western': 0xFFFF6F00,
    'Thriller': 0xFF424242,
  };

  /// Constantes para validação
  static const int minYear = 1900;
  static const int maxDescriptionLength = 500;
  static const double minRating = 0.0;
  static const double maxRating = 10.0;

  /// Mensagens de erro padrão
  static const String requiredFieldError = 'Este campo é obrigatório';
  static const String invalidYearError = 'Digite um ano válido';
  static const String invalidRatingError = 'A pontuação deve estar entre 0 e 10';
  static const String invalidUrlError = 'Digite uma URL válida';

  /// Placeholder texts
  static const String titlePlaceholder = 'Digite o título do filme';
  static const String imageUrlPlaceholder = 'https://exemplo.com/imagem.jpg';
  static const String durationPlaceholder = '120 min ou 2:00';
  static const String yearPlaceholder = '2024';
  static const String ratingPlaceholder = '8.5';
  static const String descriptionPlaceholder = 'Digite uma breve descrição do filme...';
}