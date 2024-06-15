import 'package:flutter/material.dart';
import 'package:reddit_wallpapers_app/settings_screen.dart';
import 'package:reddit_wallpapers_app/wallpaper_list.dart';

void main() => runApp(
      MaterialApp(
        home: HomePage(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData().copyWith(
          scaffoldBackgroundColor: Colors.black,
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              iconTheme: IconThemeData(color: Colors.white),
              actionsIconTheme: IconThemeData(color: Colors.white),
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 22)),
        ),
        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.dark,
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
          title: const Text('iWallpaper'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingsScreen()))
              },
            )
          ],
          bottom: const TabBar(
            indicatorColor: Colors.amber,
            unselectedLabelColor: Colors.white54,
            labelColor: Colors.amber,
            tabs: const [
              Tab(
                icon: Icon(Icons.card_giftcard),
                text: "New",
              ),
              Tab(icon: Icon(Icons.show_chart), text: "Top"),
              Tab(icon: Icon(Icons.whatshot), text: "Hot"),
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
