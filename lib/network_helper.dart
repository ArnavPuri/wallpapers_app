import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:reddit_wallpapers_app/models/wallpaper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkHelper {
  Future<List<Wallpaper>> getWallpapersList(
      String category, bool newFirst) async {
    List<String> subReddits = await _loadSubreddits();
    List<List<Wallpaper>> wallpapers = [];

    wallpapers = await Future.wait(subReddits.map(
        (subReddit) => _fetchWallpapersFromAPI('r/$subReddit/$category.json')));
    List<Wallpaper> flattenWallpapers = [];
    for (var wallpapersList in wallpapers) {
      flattenWallpapers.addAll(wallpapersList);
    }
    if (newFirst) {
      flattenWallpapers.sort((a, b) => b.created.compareTo(a.created));
    } else {
      flattenWallpapers.sort((a, b) => b.upvotes.compareTo(a.upvotes));
    }
    return flattenWallpapers;
  }

  Future<List<Wallpaper>> _fetchWallpapersFromAPI(
      String subRedditAndCategory) async {
    List<Wallpaper> wallpapers = [];
    var url = Uri.https('www.reddit.com', subRedditAndCategory, {"t": "month"});
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> resultMap = jsonDecode(response.body);
      List<dynamic> wallpapersData = resultMap['data']['children'];
      for (var wallpaperJSON in wallpapersData) {
        if (isWallpaper(wallpaperJSON)) {
          wallpapers.add(Wallpaper.fromJSON(wallpaperJSON));
        }
      }
    }
    return wallpapers;
  }

  _loadSubreddits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedSubreddits = prefs.getStringList('subreddits');
    if (storedSubreddits == null || storedSubreddits.isEmpty) {
      // Setting default values
      storedSubreddits = [
        'MobileWallpaper',
        'iWallpaper',
        'iPhoneWallpapers',
        'AmoledBackgrounds'
      ];
      prefs.setStringList('subreddits', storedSubreddits);
    }
    return storedSubreddits;
  }

  Future<http.Response> fetchPost() {
    var url = Uri.https('jsonplaceholder.typicode.com', 'posts/1');
    return http.get(url);
  }

  bool isWallpaper(Map<String, dynamic> wallpaperJSON) {
    String url = wallpaperJSON['data']['url'];
    return url.contains('png') || url.contains('jpg') || url.contains('jpeg');
  }
}
