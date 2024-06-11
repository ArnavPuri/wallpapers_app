import 'package:flutter/material.dart';
import 'package:reddit_wallpapers_app/wallpaper_list.dart';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
            primaryColor: Colors.black,
            hintColor: Colors.orange,
            scaffoldBackgroundColor: Colors.black),
      ),
    );

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('/r/Wallpapers'),
          bottom: TabBar(
            indicatorColor: Theme.of(context).hintColor,
            unselectedLabelColor: Colors.white,
            labelColor: Theme.of(context).hintColor,
            tabs: const [
              Tab(icon: Icon(Icons.new_releases)),
              Tab(icon: Icon(Icons.show_chart)),
              Tab(icon: Icon(Icons.whatshot)),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: const TabBarView(
          children: <Widget>[
            WallpaperList(category: 'new'),
            WallpaperList(category: 'top'),
            WallpaperList(category: 'hot'),
          ],
        ),
      ),
    );
  }
}
