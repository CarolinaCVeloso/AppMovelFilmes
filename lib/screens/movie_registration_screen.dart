// lib/screens/movie_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import '../widgets/image_preview_widget.dart';
import '../utils/form_validators.dart';
import '../constants/movie_constants.dart';
import '../services/movie_service.dart';

class MovieRegistrationScreen extends StatefulWidget {
  final Movie? initialMovie;

  const MovieRegistrationScreen({
    Key? key,
    this.initialMovie,
  }) : super(key: key);

  @override
  State<MovieRegistrationScreen> createState() => _MovieRegistrationScreenState();
}

class _MovieRegistrationScreenState extends State<MovieRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  final _ratingController = TextEditingController();

  String? _selectedGenre;
  String? _selectedAgeRating;
  String _movieId = '';
  bool _imageLoaded = false;
  String? _imageError;
  final MovieService _movieService = MovieService();

  @override
  void initState() {
    super.initState();
    if (widget.initialMovie != null) {
      _movieId = widget.initialMovie!.id;
      _titleController.text = widget.initialMovie!.title;
      _imageUrlController.text = widget.initialMovie!.imageUrl;
      _durationController.text = widget.initialMovie!.duration;
      _descriptionController.text = widget.initialMovie!.description;
      _yearController.text = widget.initialMovie!.year.toString();
      _ratingController.text = widget.initialMovie!.rating.toString();
      _selectedGenre = widget.initialMovie!.genre;
      _selectedAgeRating = widget.initialMovie!.ageRating;
    } else {
      _generateMovieId();
    }
    _imageUrlController.addListener(_onImageUrlChanged);
  }

  void _generateMovieId() {
    _movieId = 'FILM_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _onImageUrlChanged() {
    if (_imageUrlController.text.isNotEmpty) {
      setState(() {
        _imageLoaded = false;
        _imageError = null;
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _imageUrlController.clear();
    _durationController.clear();
    _descriptionController.clear();
    _yearController.clear();
    _ratingController.clear();
    setState(() {
      _selectedGenre = null;
      _selectedAgeRating = null;
      _imageLoaded = false;
      _imageError = null;
    });
    _generateMovieId();
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      try {
        final movie = Movie(
          id: _movieId,
          title: _titleController.text.trim(),
          imageUrl: _imageUrlController.text.trim(),
          genre: _selectedGenre!,
          ageRating: _selectedAgeRating!,
          duration: _durationController.text.trim(),
          year: int.parse(_yearController.text),
          rating: double.parse(_ratingController.text),
          description: _descriptionController.text.trim(),
        );
        
        if (widget.initialMovie != null) {
          await _movieService.updateMovie(movie);
        } else {
          await _movieService.createMovie(movie);
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Filme "${movie.title}" ${widget.initialMovie != null ? 'atualizado' : 'cadastrado'} com sucesso!'),
                ],
              ),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Erro ao ${widget.initialMovie != null ? 'atualizar' : 'cadastrar'} filme: ${e.toString()}'),
                ],
              ),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(widget.initialMovie != null ? 'Editar Filme' : 'Cadastro de Filme'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildImageSection(),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(),
                  const SizedBox(height: 16),
                  _buildCategorySection(),
                  const SizedBox(height: 16),
                  _buildDetailsSection(),
                  const SizedBox(height: 16),
                  _buildDescriptionSection(),
                  const SizedBox(height: 32),
                  _buildActionButtons(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple[50]!, Colors.deepPurple[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.badge, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ID do Filme',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _movieId,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Imagem do Filme',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _imageUrlController,
          decoration: InputDecoration(
            labelText: 'URL da Imagem',
            hintText: MovieConstants.imageUrlPlaceholder,
            prefixIcon: const Icon(Icons.image, color: Colors.deepPurple),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
          validator: FormValidators.validateImageUrl,
        ),
        const SizedBox(height: 12),
        ImagePreviewWidget(
          imageUrl: _imageUrlController.text,
          onImageLoaded: () => setState(() {
            _imageLoaded = true;
            _imageError = null;
          }),
          onImageError: (error) => setState(() {
            _imageLoaded = false;
            _imageError = error;
          }),
        ),
        if (_imageError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _imageError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Informações Básicas',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _titleController,
          decoration: InputDecoration(
            labelText: 'Título do Filme',
            hintText: MovieConstants.titlePlaceholder,
            prefixIcon: const Icon(Icons.movie, color: Colors.deepPurple),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
          validator: (value) => FormValidators.validateRequired(value, 'Título'),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categoria e Classificação',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedGenre,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                items: MovieConstants.genres.map((String genre) {
                  return DropdownMenuItem<String>(
                    value: genre,
                    child: Text(genre),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGenre = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione um gênero';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedAgeRating,
                decoration: const InputDecoration(
                  labelText: 'Faixa Etária',
                  prefixIcon: Icon(Icons.family_restroom, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                items: MovieConstants.ageRatings.map((String rating) {
                  return DropdownMenuItem<String>(
                    value: rating,
                    child: Text(rating),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAgeRating = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Selecione a faixa etária';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detalhes do Filme',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duração',
                  hintText: MovieConstants.durationPlaceholder,
                  prefixIcon: const Icon(Icons.schedule, color: Colors.deepPurple),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                validator: FormValidators.validateDuration,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Ano',
                  hintText: MovieConstants.yearPlaceholder,
                  prefixIcon: const Icon(Icons.calendar_today, color: Colors.deepPurple),
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: FormValidators.validateYear,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _ratingController,
          decoration: InputDecoration(
            labelText: 'Pontuação (0-10)',
            hintText: MovieConstants.ratingPlaceholder,
            prefixIcon: const Icon(Icons.star, color: Colors.deepPurple),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            suffixText: '/ 10',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
          ],
          validator: FormValidators.validateRating,
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Descrição',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            labelText: 'Descrição do Filme',
            hintText: MovieConstants.descriptionPlaceholder,
            prefixIcon: const Icon(Icons.description, color: Colors.deepPurple),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
            alignLabelWithHint: true,
          ),
          maxLines: 4,
          maxLength: MovieConstants.maxDescriptionLength,
          validator: (value) => FormValidators.validateDescription(
            value, 
            maxLength: MovieConstants.maxDescriptionLength,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _clearForm,
            icon: const Icon(Icons.clear),
            label: const Text('Limpar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey[400]!),
              foregroundColor: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: _saveMovie,
            icon: const Icon(Icons.save),
            label: const Text('Salvar Filme'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageUrlController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}