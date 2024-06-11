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
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                            Icons.thumb_up,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            snapshot.data![index].upvotes.toString(),
                            style: TextStyle(
                              color: Colors.white,
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
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                snapshot.data![index].thumbnailUrl),
                            fit: BoxFit.cover)),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(
            color: Colors.amber,
          ),
        );
      },
    );
  }
}
