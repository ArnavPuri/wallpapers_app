import 'package:flutter/material.dart';
import 'package:reddit_wallpapers_app/detail.dart';
import 'package:reddit_wallpapers_app/models/wallpaper.dart';
import 'package:reddit_wallpapers_app/network_helper.dart';

class WallpaperList extends StatefulWidget {
  final String category;

  const WallpaperList({
    required this.category,
  });

  @override
  _WallpaperListState createState() => _WallpaperListState();
}

class _WallpaperListState extends State<WallpaperList>
    with AutomaticKeepAliveClientMixin<WallpaperList> {
  late Future<List<Wallpaper>> wallpapersList;
  NetworkHelper networkHelper = NetworkHelper();

  @override
  void initState() {
    super.initState();
    wallpapersList = networkHelper.getWallpapersList(widget.category);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: wallpapersList,
      builder: (context, AsyncSnapshot<List<Wallpaper>> snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 1.0, mainAxisSpacing: 1.0),
            shrinkWrap: true,
            itemCount: snapshot.data?.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              WallpaperDetail(snapshot.data![index])));
                },
                child: Hero(
                  tag: snapshot.data![index].url + snapshot.data![index].title,
                  child: AspectRatio(
                      aspectRatio: 9 / 16,
                      child: Stack(
                        children: [
                          Image.network(
                            snapshot.data![index].thumbnailUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(
                                  Icons.thumb_up,
                                  color: Colors.white70,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  snapshot.data![index].upvotes.toString(),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 18.0,
                                    shadows: [
                                      Shadow(
                                          color: Colors.black,
                                          offset: Offset(1, 1),
                                          blurRadius: 4)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
