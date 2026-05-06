import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/news_model.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailScreen extends StatelessWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    const colorBg = Color(0xFF121414);
    const colorSurface = Color(0xFF1E2020);
    const colorPrimary = Color(0xFF9CE39E);
    const colorSecondary = Color(0xFFA7FFEB);
    const colorTextMain = Color(0xFFE2E2E2);
    const colorTextVariant = Color(0xFFC0C9BC);

    return Scaffold(
      backgroundColor: colorBg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: article.urlToImage ?? article.title,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    child: CachedNetworkImage(
                      imageUrl: article.urlToImage ?? 'https://via.placeholder.com/800x600',
                      height: 400,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 10,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorSecondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              article.source.name,
                              style: const TextStyle(
                                color: Color(0xFF00382F),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const CircleAvatar(radius: 3, backgroundColor: Color(0xFF286B33)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Lectura de 5 min",
                        style: TextStyle(color: colorTextVariant, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Text(
                    article.title,
                    style: const TextStyle(
                      color: colorTextMain,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundColor: colorSurface,
                        child: Icon(Icons.person, color: colorPrimary),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Redacción NewsCloud", style: TextStyle(color: colorTextMain, fontWeight: FontWeight.w600)),
                          Text("Corresponsal", style: TextStyle(color: colorTextVariant, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 48, color: Colors.white10),

                  Text(
                    article.description ?? "No hay descripción disponible para este artículo.",
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      color: colorTextMain,
                      fontSize: 18,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  if (article.content != null)
                    Text(
                      article.content!.split('[')[0],
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        color: colorTextVariant,
                        fontSize: 16,
                        height: 1.6,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: colorSurface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorPrimary,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () async {
            if (article.url != null) {
              final Uri url = Uri.parse(article.url!);

              if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se pudo abrir la noticia original')),
                );
              }
            }
          },
          child: const Text(
            "Leer noticia completa",
            style: TextStyle(color: Color(0xFF003911), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}