// lib/widgets/image_preview_widget.dart
import 'package:flutter/material.dart';

class ImagePreviewWidget extends StatelessWidget {
  final String imageUrl;
  final VoidCallback? onImageLoaded;
  final Function(String)? onImageError;
  final double height;

  const ImagePreviewWidget({
    Key? key,
    required this.imageUrl,
    this.onImageLoaded,
    this.onImageError,
    this.height = 200,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) {
      return _buildPlaceholder();
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              // Imagem carregada com sucesso
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onImageLoaded?.call();
              });
              return child;
            }
            return _buildLoadingIndicator(loadingProgress);
          },
          errorBuilder: (context, error, stackTrace) {
            // Erro ao carregar imagem
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onImageError?.call('Erro ao carregar imagem');
            });
            return _buildErrorWidget();
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie, size: 50, color: Colors.grey),
            SizedBox(height: 8),
            Text(
              'Prévia da imagem',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            SizedBox(height: 4),
            Text(
              'Digite uma URL válida acima',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(ImageChunkEvent loadingProgress) {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                  : null,
            ),
            const SizedBox(height: 16),
            const Text(
              'Carregando imagem...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.red[50],
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 40),
            SizedBox(height: 8),
            Text(
              'Erro ao carregar imagem',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              'Verifique se a URL está correta',
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}