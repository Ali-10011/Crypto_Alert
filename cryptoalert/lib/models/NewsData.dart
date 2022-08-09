class NewsCard {
  late String title;
  late String url;
  late String source;
  late String publish_time;

  NewsCard({required this.title, required this.url, required this.source, required this.publish_time});
}

List<NewsCard> NewsInstance = [];
