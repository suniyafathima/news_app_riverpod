import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:news_app/presentation/news_screen/controller/news_screen_controller.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((timestamp) async {
    await ref.read(newsScreenProvider.notifier).fetchTopHeadlines();
  });
}

@override
Widget build(BuildContext context) {
   final screenstate = ref.watch(newsScreenProvider);

final topHeadlines = screenstate.topHeadlines ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Discover', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: Icon(Icons.search, color: Colors.black), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: topHeadlines.length,
        itemBuilder: (context, index) {
          
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( topHeadlines[index].source?.name ?? 'Unknown Source', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  //   CachedNetworkImage(
//   imageUrl: article.urlToImage ?? "",
//   width: 100,
//   height: 100,
//   fit: BoxFit.cover,
//   placeholder: (context, url) => CircularProgressIndicator(),
//   errorWidget: (context, url, error) => Icon(Icons.broken_image),
                  child: CachedNetworkImage(
                    imageUrl: topHeadlines[index].urlToImage ?? "",
                   placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.broken_image),
                 ) ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 300,
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width:1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(child: Text(topHeadlines[index].author ?? "")),
                    ),
                    Spacer(),
                    Icon(Icons.bookmark_border),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        topHeadlines[index].title ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                      ),
                    ),
                    
                  ],
                ),
                SizedBox(height: 6),
                Text(topHeadlines[index].description ?? ""),
                SizedBox(height: 4),
               Text(
                 topHeadlines[index].publishedAt != null
                 ? DateFormat('dd MMM yyyy').format(topHeadlines[index].publishedAt!)
                 : '',
                 style: TextStyle(color: Colors.grey),
                ),

                SizedBox(height: 10,)
              ],
            ),
          );
        },
      ),
   
    );
  }
}
