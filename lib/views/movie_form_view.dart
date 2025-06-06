import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/movie_controller.dart';
import '../models/movie.dart';

class MovieFormView extends StatefulWidget {
  final Movie? movie;

  const MovieFormView({Key? key, this.movie}) : super(key: key);

  @override
  _MovieFormViewState createState() => _MovieFormViewState();
}

class _MovieFormViewState extends State<MovieFormView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _genreController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  final _imageUrlController = TextEditingController();

  String _selectedAgeRating = 'Livre';
  double _rating = 0.0;

  final List<String> _ageRatings = ['Livre', '10', '12', '14', '16', '18'];

  @override
  void initState() {
    super.initState();
    if (widget.movie != null) {
      _titleController.text = widget.movie!.title;
      _genreController.text = widget.movie!.genre;
      _durationController.text = widget.movie!.duration.toString();
      _descriptionController.text = widget.movie!.description;
      _yearController.text = widget.movie!.year.toString();
      _imageUrlController.text = widget.movie!.imageUrl;
      _selectedAgeRating = widget.movie!.ageRating;
      _rating = widget.movie!.rating;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _genreController.dispose();
    _durationController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveMovie() async {
    if (_formKey.currentState!.validate()) {
      final movie = Movie(
        id: widget.movie?.id,
        title: _titleController.text,
        genre: _genreController.text,
        duration: int.parse(_durationController.text),
        description: _descriptionController.text,
        year: int.parse(_yearController.text),
        imageUrl: _imageUrlController.text,
        ageRating: _selectedAgeRating,
        rating: _rating,
      );

      final controller = Provider.of<MovieController>(context, listen: false);
      bool success;

      if (widget.movie == null) {
        success = await controller.addMovie(movie);
      } else {
        success = await controller.updateMovie(movie);
      }

      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.movie == null 
              ? 'Filme cadastrado com sucesso!' 
              : 'Filme atualizado com sucesso!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar filme')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie == null ? 'Cadastrar Filme' : 'Alterar Filme'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveMovie,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _genreController,
                decoration: InputDecoration(
                  labelText: 'Gênero',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o gênero';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedAgeRating,
                decoration: InputDecoration(
                  labelText: 'Faixa Etária',
                  border: OutlineInputBorder(),
                ),
                items: _ageRatings.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedAgeRating = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(
                  labelText: 'Duração (minutos)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a duração';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: InputDecoration(
                  labelText: 'Ano',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o ano';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText: 'URL da Imagem',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a URL da imagem';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Pontuação:', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  SmoothStarRating(
                    allowHalfRating: true,
                    onRated: (v) {
                      setState(() {
                        _rating = v;
                      });
                    },
                    starCount: 5,
                    rating: _rating,
                    size: 40.0,
                    color: Colors.amber,
                    borderColor: Colors.amber,
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveMovie,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    widget.movie == null ? 'Cadastrar Filme' : 'Atualizar Filme',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
