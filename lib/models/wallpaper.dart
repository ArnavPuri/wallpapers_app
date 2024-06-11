class Wallpaper {
  final String url;
  final String title;
  final String thumbnailUrl;
  final int upvotes;

  Wallpaper(this.url, this.title, this.thumbnailUrl, this.upvotes);

  factory Wallpaper.fromJSON(Map<String, dynamic> data) {
    return Wallpaper(data['data']['url'], data['data']['title'],
        data['data']['thumbnail'], data['data']['ups']);
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
