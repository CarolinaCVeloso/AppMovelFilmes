// lib/utils/form_validators.dart
class FormValidators {
  
  /// Valida se um campo obrigatório foi preenchido
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName é obrigatório';
    }
    return null;
  }

  /// Valida o campo de ano
  static String? validateYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ano é obrigatório';
    }
    
    final year = int.tryParse(value);
    if (year == null) {
      return 'Digite apenas números';
    }
    
    if (year < 1900 || year > DateTime.now().year + 5) {
      return 'Digite um ano válido (1900-${DateTime.now().year + 5})';
    }
    
    return null;
  }

  /// Valida o campo de pontuação/rating
  static String? validateRating(String? value) {
    if (value == null || value.isEmpty) {
      return 'Pontuação é obrigatória';
    }
    
    final rating = double.tryParse(value);
    if (rating == null) {
      return 'Digite um número válido';
    }
    
    if (rating < 0 || rating > 10) {
      return 'A pontuação deve estar entre 0 e 10';
    }
    
    return null;
  }

  /// Valida URL de imagem
  static String? validateImageUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL da imagem é obrigatória';
    }
    
    final uri = Uri.tryParse(value);
    if (uri == null || !uri.hasScheme) {
      return 'Digite uma URL válida';
    }
    
    if (!uri.scheme.startsWith('http')) {
      return 'A URL deve começar com http:// ou https://';
    }
    
    return null;
  }

  /// Valida campo de duração
  static String? validateDuration(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Duração é obrigatória';
    }
    
    // Aceita formatos: "120", "120 min", "2:00", "2h 30min", etc.
    final cleanValue = value.trim().toLowerCase();
    
    // Verifica se contém pelo menos um número
    if (!RegExp(r'\d').hasMatch(cleanValue)) {
      return 'Digite a duração em minutos ou formato hh:mm';
    }
    
    return null;
  }

  /// Valida campo de descrição com limite de caracteres
  static String? validateDescription(String? value, {int maxLength = 500}) {
    if (value == null || value.trim().isEmpty) {
      return 'Descrição é obrigatória';
    }
    
    if (value.length > maxLength) {
      return 'A descrição deve ter no máximo $maxLength caracteres';
    }
    
    return null;
  }

  /// Valida email (caso precise no futuro)
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'E-mail é obrigatório';
    }
    
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    
    return null;
  }
}