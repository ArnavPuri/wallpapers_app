import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reddit_wallpapers_app/models/wallpaper.dart';
import 'package:http/http.dart' as http;

class WallpaperDetail extends StatefulWidget {
  final Wallpaper wallpaper;
  final String tag;

  const WallpaperDetail(this.wallpaper, this.tag, {super.key});

  @override
  _WallpaperDetailState createState() => _WallpaperDetailState();
}

class _WallpaperDetailState extends State<WallpaperDetail> {
  Future<void> _saveImage() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    String message = "Image saved to disk";

    try {
      // Download image
      final http.Response response =
          await http.get(Uri.parse(widget.wallpaper.url));

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var filename = '${dir.path}/SaveImage${Random().nextInt(100)}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.bodyBytes);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.amber,
      ));
    }

    scaffoldMessenger.showSnackBar(SnackBar(
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }

  void _setWallpaper() async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    dynamic dialogContext;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return const AlertDialog(
          title: Text('Setting Wallpaper'),
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Expanded(
                  child: Text('Please wait while we set your wallpaper...')),
            ],
          ),
        );
      },
    );
    try {
      final response = await http.get(Uri.parse(widget.wallpaper.url));
      if (response.statusCode == 200) {
        Uint8List imageData = response.bodyBytes;
        const platform =
            MethodChannel('com.arnavpuri.reddit_wallpapers_app/setWallpaper');
        final result = await platform.invokeMethod('setWallpaper', imageData);
        if (dialogContext.mounted) {
          Navigator.pop(dialogContext); // Close the loading dialog
        }
        scaffoldMessenger.showSnackBar(SnackBar(content: Text(result)));
      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      if (dialogContext.mounted) {
        Navigator.pop(dialogContext); // Close the loading dialog
      }
      scaffoldMessenger
          .showSnackBar(SnackBar(content: Text('Failed to set wallpaper: $e')));
    }
  }

  void _showSetWallpaperDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Wallpaper'),
          content: Text('Do you want to set this image as your wallpaper?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _setWallpaper();
              },
              child: Text('Set Wallpaper'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallpaper.title),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.file_download),
            onPressed: _saveImage,
          ),
          IconButton(
            icon: const Icon(Icons.wallpaper),
            onPressed: _showSetWallpaperDialog,
          )
        ],
      ),
      body: SizedBox.expand(
        child: Hero(
          tag: widget.tag,
          child: Image(
              image: NetworkImage(widget.wallpaper.url),
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                );
              }),
        ),
      ),
    );
  }
}
