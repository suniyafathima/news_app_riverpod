import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class NewsDb {
  static late Database database;
   static List<Map> newsList = [];
  static Future<void> initDb() async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWeb;
    }

    // open the database
    database = await openDatabase("newss.db", version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE News (id INTEGER PRIMARY KEY, author TEXT, title TEXT, urlToImage TEXT, description TEXT, publishedAt TEXT, content TEXT, url TEXT)');
    });
  } 

static Future<void> saveNews({
  String? author,
  String? title,
  String? urlToImage,
  String? description,
  String? publishedAt,
  String? content,
  String? url
}) async {
  if (url == null) return;

  // Check if article with this URL already exists
  final List<Map<String, dynamic>> existing = await database.rawQuery(
    'SELECT * FROM News WHERE url = ?',
    [url],
  );

  if (existing.isEmpty) {
    await database.rawInsert(
      'INSERT INTO News(author, title, urlToImage, description, publishedAt, content, url) '
      'VALUES(?, ?, ?, ?, ?, ?, ?)',
      [author, title, urlToImage, description, publishedAt, content, url],
    );

    await getSavedNews();
  } else {
    log('Article already saved');
  }
}

  
  static Future<void> getSavedNews() async {
    newsList = await database.rawQuery('SELECT * FROM News ');
    log(newsList.toString());
    
  }

  static Future<void> deleteNewsById(String url) async {
  await database.rawDelete( 'DELETE FROM News WHERE url = ?', [url]);
  await getSavedNews();
 }
}