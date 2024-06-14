class Wallpaper {
  final String url;
  final String title;
  final String thumbnailUrl;
  final int upvotes;
  final String subreddit;

  Wallpaper(
      this.url, this.title, this.thumbnailUrl, this.upvotes, this.subreddit);

  factory Wallpaper.fromJSON(Map<String, dynamic> data) {
    return Wallpaper(
        data['data']['url'],
        data['data']['title'],
        data['data']['thumbnail'],
        data['data']['ups'],
        data['data']['subreddit_name_prefixed']);
  }

  @override
  String toString() {
    return "$url: $title";
  }
}
