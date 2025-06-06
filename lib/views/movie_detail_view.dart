import 'package:flutter/material.dart';
import '../models/movie.dart';

class MovieDetailView extends StatelessWidget {
  final Movie movie;

  const MovieDetailView({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.imageUrl,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: Icon(Icons.movie, size: 100),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              movie.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Chip(
                  label: Text(movie.genre),
                  backgroundColor: Colors.blue[100],
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text(movie.ageRating),
                  backgroundColor: Colors.orange[100],
                ),
                SizedBox(width: 8),
                Chip(
                  label: Text('${movie.year}'),
                  backgroundColor: Colors.green[100],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  '${movie.duration} minutos',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text('Avaliação: ', style: TextStyle(fontSize: 16)),
                RatingBarIndicator(
                  rating: movie.rating,
                  itemBuilder: (context, index) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 24.0,
                ),
                SizedBox(width: 8),
                Text(
                  '(${movie.rating.toStringAsFixed(1)})',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Descrição',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              movie.description,
              style: TextStyle(fontSize: 16, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}