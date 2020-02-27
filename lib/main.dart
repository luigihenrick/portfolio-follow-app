import 'package:flutter/material.dart';
import 'package:portfolio_follow/screens/history_performance.dart';
import 'package:portfolio_follow/screens/menu_navigation_bar.dart';
import 'package:portfolio_follow/screens/realtime_quote.dart';
import 'package:portfolio_follow/screens/wallet_allocation.dart';

import 'components/donut_chart.dart';
import 'models/history_price.dart';
import 'models/quote.dart';

void main() => runApp(
    MaterialApp(
      title: 'Portfolio',
      home: PortfolioApp(title: 'Minha Carteira', animate: true),
    )
);

class PortfolioApp extends StatefulWidget{
  final String title;
  final bool animate;

  PortfolioApp({Key key, this.title, this.animate}) : super(key: key);

  @override
  _PortfolioApp createState() => _PortfolioApp();

}

class _PortfolioApp extends State<PortfolioApp>{
  int currentPage;

  Future<Quote> _futureQuote;
  Future<PriceHistoryDaily> _futurePriceHistoryDaily;
  List<DonutChartItem> _walletAllocationData;

  void updateData(int index){
    setState(() {
      currentPage = index;

      _futureQuote = RealtimeQuote.fetchQuoteData();
      _futurePriceHistoryDaily = HistoryPerformance.fetchPriceHistoryData();
      _walletAllocationData = WalletAllocation.fetchWalletAllocationData();
    });
  }

  @override
  void initState() {
    super.initState();

    currentPage = 0;

    _futureQuote = RealtimeQuote.fetchQuoteData();
    _futurePriceHistoryDaily = HistoryPerformance.fetchPriceHistoryData();
    _walletAllocationData = WalletAllocation.fetchWalletAllocationData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      backgroundColor: Colors.white,
      body: renderPage(currentPage),
      floatingActionButton: FloatingActionButton(
        onPressed: () => updateData(currentPage),
        child: Icon(Icons.refresh),
        backgroundColor: Colors.blue,
      ),
      bottomNavigationBar: MenuNavigationBar(currentPage, updateData)
    );
  }

  Widget renderPage(int index){
    switch(index){
      case 1:
        return HistoryPerformance(_futurePriceHistoryDaily, animate: widget.animate); //HistoryPage(_futurePriceHistoryDaily);
      case 2:
        return RealtimeQuote(_futureQuote);
      default:
        return WalletAllocation(_walletAllocationData, animate: widget.animate);
    }
  }
}