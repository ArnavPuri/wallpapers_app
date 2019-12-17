class Wallpaper {
  String url;
  String title;
  String thumbnailUrl;
  int upvotes;

  Wallpaper(this.url, this.title, this.thumbnailUrl);

  Wallpaper.fromJSON(Map<String, dynamic> data) {
    this.url = data['data']['url'];
    this.title = data['data']['title'];
    this.thumbnailUrl = data['data']['thumbnail'];
    this.upvotes = data['data']['ups'];
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
