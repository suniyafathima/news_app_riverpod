import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_app/repository/api/news_screen/news_res_model.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsDetails extends StatelessWidget {
  const NewsDetails({super.key, required this.article});

  final Article article;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          article.source?.name ?? "News",
          style: TextStyle(fontSize: 18),
        ),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                  placeholder: (context, url) => CircularProgressIndicator(),
                   errorWidget: (context, url, error) => Icon(Icons.broken_image)
                ),
              ),
            SizedBox(height: 16),

            // Title
            Text(
              article.title ?? "No Title",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 8),

            // Author and date
            Row(
              children: [
                if (article.author != null)
                  Text("By ${article.author}",
                      style: TextStyle(fontStyle: FontStyle.italic)),
                Spacer(),
                if (article.publishedAt != null)
                  Text(
                    article.publishedAt!.toLocal().toString().split(' ')[0],
                    style: TextStyle(color: Colors.grey),
                  ),
              ],
            ),

            SizedBox(height: 16),

            // Description
            if (article.description != null)
              Text(
                article.description!,
                style: TextStyle(fontSize: 16),
              ),

            SizedBox(height: 16),

            // Full content
            if (article.content != null)
              Text(
                article.content!,
                style: TextStyle(fontSize: 15),
              ),
           TextButton(
  onPressed: () async {
    final url = article.url;

    if (url == null || url.isEmpty) {
      debugPrint("❌ No URL provided.");
      return;
    }

    final uri = Uri.tryParse(url);
    if (uri == null) {
      debugPrint("❌ Invalid URI: $url");
      return;
    }

    debugPrint("🔗 Attempting to open in Chrome: $url");

    try {
      final launched = await launchUrl(uri);

      debugPrint(launched
          ? "✅ URL launch successful"
          : "❌ URL launch failed");
    } catch (e) {
      debugPrint("🚨 Exception launching URL: $e");
    }
  },
  child: Text("Read More"),
)
          ],
        ),
      ),
    );
  }
}
