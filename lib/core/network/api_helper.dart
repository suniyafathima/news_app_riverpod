import 'dart:developer';

import 'package:http/http.dart' as http;

class AppConfig{
  static const String baseUrl = "https://newsapi.org";
    static const String apiKey = "3aeeb62a8c5b4471af0f71e9e8f1b21b";
}

class ApiHelper {
static Future<String?>getData({required String endpoint}) async {
    final url=Uri.parse(AppConfig.baseUrl+endpoint);
    try{
      final response=await http.get(url);
      if(response.statusCode==200){
        log("Response: ${response.body}");
        return response.body;
      }
      else{
        log("Error: ${response.statusCode}");
      }
    }
    catch(e){
      log("Error: $e");
    }
    return null;
 }
}