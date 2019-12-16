class Wallpaper {
  String url;
  String title;

  Wallpaper(this.url, this.title);

  Wallpaper.fromJSON(Map<String, dynamic> data) {
    this.url = data['data']['url'];
    this.title = data['data']['title'];
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
