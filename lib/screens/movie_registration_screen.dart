// lib/screens/movie_registration_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/movie.dart';
import '../widgets/image_preview_widget.dart';
import '../utils/form_validators.dart';
import '../constants/movie_constants.dart';
import '../services/movie_service.dart';

class TelaCadastroFilme extends StatefulWidget {
  final Filme? filmeInicial;

  const TelaCadastroFilme({
    Key? key,
    this.filmeInicial,
  }) : super(key: key);

  @override
  State<TelaCadastroFilme> createState() => _TelaCadastroFilmeState();
}

class _TelaCadastroFilmeState extends State<TelaCadastroFilme> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _urlImagemController = TextEditingController();
  final _duracaoController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _anoController = TextEditingController();
  final _pontuacaoController = TextEditingController();

  String? _generoSelecionado;
  String? _faixaEtariaSelecionada;
  String _idFilme = '';
  bool _imagemCarregada = false;
  String? _erroImagem;
  final FilmeService _servicoFilme = FilmeService();

  @override
  void initState() {
    super.initState();
    if (widget.filmeInicial != null) {
      _idFilme = widget.filmeInicial!.id;
      _tituloController.text = widget.filmeInicial!.titulo;
      _urlImagemController.text = widget.filmeInicial!.urlImagem;
      _duracaoController.text = widget.filmeInicial!.duracao;
      _descricaoController.text = widget.filmeInicial!.descricao;
      _anoController.text = widget.filmeInicial!.ano.toString();
      _pontuacaoController.text = widget.filmeInicial!.pontuacao.toString();
      if (MovieConstants.genres.contains(widget.filmeInicial!.genero)) {
        _generoSelecionado = widget.filmeInicial!.genero;
      } else {
        _generoSelecionado = null;
      }
      _faixaEtariaSelecionada = widget.filmeInicial!.faixaEtaria;
    } else {
      _gerarIdFilme();
    }
    _urlImagemController.addListener(_aoAlterarUrlImagem);
  }

  void _gerarIdFilme() {
    _idFilme = 'FILM_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _aoAlterarUrlImagem() {
    if (_urlImagemController.text.isNotEmpty) {
      setState(() {
        _imagemCarregada = false;
        _erroImagem = null;
      });
    }
  }

  void _limparFormulario() {
    _formKey.currentState?.reset();
    _tituloController.clear();
    _urlImagemController.clear();
    _duracaoController.clear();
    _descricaoController.clear();
    _anoController.clear();
    _pontuacaoController.clear();
    setState(() {
      _generoSelecionado = null;
      _faixaEtariaSelecionada = null;
      _imagemCarregada = false;
      _erroImagem = null;
    });
    _gerarIdFilme();
  }

  Future<void> _salvarFilme() async {
    if (_formKey.currentState!.validate()) {
      try {
        final filme = Filme(
          id: _idFilme,
          titulo: _tituloController.text.trim(),
          urlImagem: _urlImagemController.text.trim(),
          genero: _generoSelecionado!,
          faixaEtaria: _faixaEtariaSelecionada!,
          duracao: _duracaoController.text.trim(),
          ano: int.parse(_anoController.text),
          pontuacao: double.parse(_pontuacaoController.text),
          descricao: _descricaoController.text.trim(),
        );
        if (widget.filmeInicial != null) {
          await _servicoFilme.atualizarFilme(filme);
        } else {
          await _servicoFilme.criarFilme(filme);
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Filme "${filme.titulo}" ${widget.filmeInicial != null ? 'atualizado' : 'cadastrado'} com sucesso!'),
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
                  Text('Erro ao ${widget.filmeInicial != null ? 'atualizar' : 'cadastrar'} filme: ${e.toString()}'),
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
        title: Text(widget.filmeInicial != null ? 'Editar Filme' : 'Cadastro de Filme'),
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
                  _cabecalho(),
                  const SizedBox(height: 24),
                  _secaoImagem(),
                  const SizedBox(height: 24),
                  _secaoInfoBasica(),
                  const SizedBox(height: 16),
                  _secaoCategoria(),
                  const SizedBox(height: 16),
                  _secaoDetalhes(),
                  const SizedBox(height: 16),
                  _secaoDescricao(),
                  const SizedBox(height: 32),
                  _botoesAcoes(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cabecalho() {
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
                  _idFilme,
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

  Widget _secaoImagem() {
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
          controller: _urlImagemController,
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
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _urlImagemController,
          builder: (context, value, child) {
            return ImagePreviewWidget(
              imageUrl: value.text,
              onImageLoaded: () => setState(() {
                _imagemCarregada = true;
                _erroImagem = null;
              }),
              onImageError: (erro) => setState(() {
                _imagemCarregada = false;
                _erroImagem = erro;
              }),
            );
          },
        ),
        if (_erroImagem != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _erroImagem!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _secaoInfoBasica() {
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
          controller: _tituloController,
          decoration: InputDecoration(
            labelText: 'Título do Filme',
            hintText: MovieConstants.titlePlaceholder,
            prefixIcon: const Icon(Icons.movie, color: Colors.deepPurple),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
          validator: (valor) => FormValidators.validateRequired(valor, 'Título'),
        ),
      ],
    );
  }

  Widget _secaoCategoria() {
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
                value: _generoSelecionado,
                decoration: const InputDecoration(
                  labelText: 'Gênero',
                  prefixIcon: Icon(Icons.category, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                items: MovieConstants.genres.map((String genero) {
                  return DropdownMenuItem<String>(
                    value: genero,
                    child: Text(genero),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setState(() {
                    _generoSelecionado = novoValor;
                  });
                },
                validator: (valor) {
                  if (valor == null) {
                    return 'Selecione um gênero';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _faixaEtariaSelecionada,
                decoration: const InputDecoration(
                  labelText: 'Faixa Etária',
                  prefixIcon: Icon(Icons.family_restroom, color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple, width: 2),
                  ),
                ),
                items: MovieConstants.ageRatings.map((String faixa) {
                  return DropdownMenuItem<String>(
                    value: faixa,
                    child: Text(faixa),
                  );
                }).toList(),
                onChanged: (String? novoValor) {
                  setState(() {
                    _faixaEtariaSelecionada = novoValor;
                  });
                },
                validator: (valor) {
                  if (valor == null) {
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

  Widget _secaoDetalhes() {
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
                controller: _duracaoController,
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
                controller: _anoController,
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
          controller: _pontuacaoController,
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

  Widget _secaoDescricao() {
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
          controller: _descricaoController,
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
          validator: (valor) => FormValidators.validateDescription(
            valor, 
            maxLength: MovieConstants.maxDescriptionLength,
          ),
        ),
      ],
    );
  }

  Widget _botoesAcoes() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _limparFormulario,
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
            onPressed: _salvarFilme,
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
    _tituloController.dispose();
    _urlImagemController.dispose();
    _duracaoController.dispose();
    _descricaoController.dispose();
    _anoController.dispose();
    _pontuacaoController.dispose();
    super.dispose();
  }
}