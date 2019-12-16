import 'package:flutter/material.dart';
import 'package:wallpapers_app/detail.dart';
import 'package:wallpapers_app/models/wallpaper.dart';
import 'package:wallpapers_app/network_helper.dart';

void main() => runApp(
      MaterialApp(
        home: WallpapersList(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
            primaryColor: Colors.black,
            accentColor: Colors.orange,
            scaffoldBackgroundColor: Colors.black),
      ),
    );

class WallpapersList extends StatefulWidget {
  @override
  _WallpapersListState createState() => _WallpapersListState();
}

class _WallpapersListState extends State<WallpapersList> {
  NetworkHelper networkHelper = NetworkHelper();
  Future<List<Wallpaper>> wallpapersList;

  @override
  void initState() {
    super.initState();
    wallpapersList = networkHelper.getWallpapersList();
  }

  Future<List<Wallpaper>> fetchWallpapers() async {
    return await networkHelper.getWallpapersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('/r/Wallpapers'),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: wallpapersList,
        builder: (context, AsyncSnapshot<List<Wallpaper>> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0),
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WallpaperDetail(snapshot.data[index])));
                  },
                  child: Hero(
                    tag: snapshot.data[index].url,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24.0),
                          image: DecorationImage(
                              image: NetworkImage(snapshot.data[index].url),
                              fit: BoxFit.cover)),
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
