import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _subreddits = [];

  @override
  void initState() {
    super.initState();
    _loadSubreddits();
  }

  _loadSubreddits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _subreddits = prefs.getStringList('subreddits') ?? [];
    });
  }

  _addSubreddit() async {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _subreddits.add(_controller.text);
      });
      _controller.clear();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setStringList('subreddits', _subreddits);
    }
  }

  _removeSubreddit(String subreddit) async {
    setState(() {
      _subreddits.remove(subreddit);
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('subreddits', _subreddits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preferences"),
      ),
      body: Container(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Enter subreddit name',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addSubreddit,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: _subreddits
                  .map((subreddit) => Chip(
                        label: Text(subreddit),
                        deleteIcon: Icon(Icons.close),
                        onDeleted: () => _removeSubreddit(subreddit),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
