class ChartData {
  late String timeStamp;
  late String price;
  late String volume;
  late String marketCap;
  ChartData(
      {required this.timeStamp,
      required this.price,
      required this.volume,
      required this.marketCap});
}

List<ChartData> LChartData = [];
