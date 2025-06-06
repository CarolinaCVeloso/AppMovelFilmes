import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                movie.imageUrl,
                width: 80,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 120,
                  color: Colors.grey[300],
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.genre,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    movie.duration,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Faixa etária: ${movie.ageRating}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  Text(
                    'Ano: ${movie.year}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RatingBarIndicator(
                    rating: movie.rating > 5 ? 5 : movie.rating,
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
            ),
          ],
        ),
      ),
    );
  }
} 