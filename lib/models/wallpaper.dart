class Wallpaper {
  final String url;
  final String title;
  final String thumbnailUrl;
  final int upvotes;
  final String subreddit;
  final String created;

  Wallpaper(this.url, this.title, this.thumbnailUrl, this.upvotes,
      this.subreddit, this.created);

  factory Wallpaper.fromJSON(Map<String, dynamic> data) {
    String thumbnailUrlFromJSON = data['data']['thumbnail'];
    String detailUrl = data['data']['url'];
    return Wallpaper(
        detailUrl,
        data['data']['title'],
        thumbnailUrlFromJSON.contains("http")
            ? thumbnailUrlFromJSON
            : detailUrl,
        data['data']['ups'],
        data['data']['subreddit_name_prefixed'],
        data['data']['created_utc'].toString());
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
