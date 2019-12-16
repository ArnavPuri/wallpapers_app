import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpapers_app/models/wallpaper.dart';
import 'package:image_downloader/image_downloader.dart';

class WallpaperDetail extends StatefulWidget {
  final Wallpaper wallpaper;

  WallpaperDetail(this.wallpaper);

  @override
  _WallpaperDetailState createState() => _WallpaperDetailState();
}

class _WallpaperDetailState extends State<WallpaperDetail> {
  Future<void> downloadImage() async {
    try {
      // Saved with this method.
      var imageId = await ImageDownloader.downloadImage(widget.wallpaper.url);
      print(imageId);
      if (imageId == null) {
        return;
      }

      // Below is a method of obtaining saved image information.
      var fileName = await ImageDownloader.findName(imageId);
      var path = await ImageDownloader.findPath(imageId);
      var size = await ImageDownloader.findByteSize(imageId);
      var mimeType = await ImageDownloader.findMimeType(imageId);
      print('FileName: $fileName');
      print('Path: $path');
      print('Size: $size');
      print('MimeType: $mimeType');
    } on PlatformException catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.wallpaper.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.file_download), onPressed: downloadImage)
        ],
      ),
      body: SizedBox.expand(
        child: Hero(
          tag: widget.wallpaper.url,
          child: Image(
            image: NetworkImage(widget.wallpaper.url),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
