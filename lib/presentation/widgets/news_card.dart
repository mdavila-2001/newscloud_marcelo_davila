import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/news_model.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final VoidCallback onTap;

  const NewsCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Colores extraídos de tu diseño de Stitch
    const colorSurface = Color(0xFF1E2020);
    const colorOnSurface = Color(0xFFE2E2E2);
    const colorOnSurfaceVariant = Color(0xFFC0C9BC);
    const colorPrimary = Color(0xFF9CE39E);
    const colorSecondary = Color(0xFF7FD6C3);
    const colorOnSecondary = Color(0xFF00382F);

    return Container(
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: colorSurface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage ?? 'https://via.placeholder.com/400x250?text=NewsCloud',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator(color: colorPrimary)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        color: Colors.grey[800],
                        child: const Icon(Icons.broken_image, color: Colors.grey, size: 50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: colorSecondary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        article.source.name.toUpperCase(),
                        style: const TextStyle(
                          color: colorOnSecondary,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: colorOnSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      article.description ?? 'Sin descripción disponible.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: colorOnSurfaceVariant,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      article.publishedAt != null ? 'ACTUALIZADO RECIENTEMENTE' : '',
                      style: const TextStyle(
                        color: colorPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}