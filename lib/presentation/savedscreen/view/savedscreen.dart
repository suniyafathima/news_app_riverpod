import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/presentation/savedscreen/controller/savedscreencontroller.dart';
import 'package:news_app/sqflite_class/news_db.dart';

class SavedScreen extends ConsumerStatefulWidget {
  const SavedScreen({super.key});

  @override
  ConsumerState<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends ConsumerState<SavedScreen> {

   
  @override
   Widget build(BuildContext context) {
final savedArticles = ref.watch(savedNewsProvider);
    return Scaffold( 
      appBar: AppBar(
        title:
            Text('Saved News', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: savedArticles.isEmpty
      ? Center(child: Text("No saved news yet"))
      :ListView.builder(
  padding: EdgeInsets.all(16),
  itemCount: savedArticles.length,
  itemBuilder: (context, index) {
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Image.network(
  savedArticles[index]['url'] ?? "",
  width: 100,
  height: 80,
  fit: BoxFit.cover,
  errorBuilder: (context, error, stackTrace) => Container(
    width: 100,
    height: 80,
    color: Colors.grey[300],
    child: Icon(Icons.broken_image),
  ),
),

          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  savedArticles[index]['title'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  savedArticles[index]['description'],
                  style: TextStyle(color: Colors.grey[700]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 8),
         // Icon(Icons.bookmark, color: Colors.black),
       IconButton(
                        icon: Icon(Icons.bookmark, color: Colors.black),
                        onPressed: () async {
                          final url = savedArticles[index]['url'];
                          if (url != null) {
                            // Call the delete function
                            await ref.read(savedNewsProvider.notifier).deleteSavedNewsById(url);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Removed from saved articles")),
                            );
                          }
                        },
                      ),


        ],
      ),
    );
  },
)

    );
  }
}
