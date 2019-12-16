import 'dart:convert';

import 'package:wallpapers_app/models/wallpaper.dart';
import 'package:http/http.dart' as http;

class NetworkHelper {
  Future<List<Wallpaper>> getWallpapersList() async {
    http.Response response =
        await http.get('https://www.reddit.com/r/iWallpaper.json');
    if(response.statusCode == 200){
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      List<dynamic> wallpapersData = resultMap['data']['children'];
      List<Wallpaper> wallpapers = [];

      wallpapersData.forEach((wallpaperJSON) {
        if (isWallpaper(wallpaperJSON)) {
          wallpapers.add(Wallpaper.fromJSON(wallpaperJSON));
        }
      });
      print(wallpapers.length);
      print(wallpapers);
      return wallpapers;
    }else{
      print(response.statusCode);
      print(response.body);
      return null;
    }

  }

  Future<http.Response> fetchPost() {
    return http.get('https://jsonplaceholder.typicode.com/posts/1');
  }

  bool isWallpaper(Map<String, dynamic> wallpaperJSON) {
    String url = wallpaperJSON['data']['url'];
    return url.contains('png') || url.contains('jpg') || url.contains('jpeg');
  }
}
