import 'package:flutter/material.dart';
import 'package:portfolio_follow/screens/history_performance.dart';
import 'package:portfolio_follow/screens/menu_navigation_bar.dart';
import 'package:portfolio_follow/screens/realtime_quote.dart';
import 'package:portfolio_follow/screens/wallet_allocation.dart';

void main() => runApp(MaterialApp(
      title: 'Portfolio',
      home: PortfolioApp(title: 'Minha Carteira', animate: true),
    ));

class PortfolioApp extends StatefulWidget {
  final String title;
  final bool animate;

  PortfolioApp({Key key, this.title, this.animate}) : super(key: key);

  @override
  _PortfolioApp createState() => _PortfolioApp();
}

class _PortfolioApp extends State<PortfolioApp> {
  int currentPage = 0;

  void updateData(int index) {
    setState(() {
      currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: renderPage(currentPage),
        bottomNavigationBar: MenuNavigationBar(currentPage, updateData));
  }

  Widget renderPage(int index) {
    switch (index) {
      case 1:
        return HistoryPerformance(animate: widget.animate);
      case 2:
        return RealtimeQuote();
      default:
        return WalletAllocation(animate: widget.animate);
    }
  }
}
