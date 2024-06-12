import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText:
                        "Enter subreddit's name to fetch wallpapers from"),
              ),
            ),
            const Flex(
              direction: Axis.horizontal,
              
              children: [
                Chip(label: Text("r/iWallpaper")),
                Chip(label: Text("r/Anime"))
              ],
            )
          ],
        ),
      ),
    );
  }
}
