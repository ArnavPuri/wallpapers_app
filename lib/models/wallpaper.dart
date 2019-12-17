class Wallpaper {
  String url;
  String title;
  String thumbnailUrl;

  Wallpaper(this.url, this.title, this.thumbnailUrl);

  Wallpaper.fromJSON(Map<String, dynamic> data) {
    this.url = data['data']['url'];
    this.title = data['data']['title'];
    this.thumbnailUrl = data['data']['thumbnail'];
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
