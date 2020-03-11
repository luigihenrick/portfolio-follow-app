import 'package:flutter/material.dart';
import 'package:portfolio_follow/commons/variables.dart';
import 'package:portfolio_follow/screens/history_performance.dart';
import 'package:portfolio_follow/screens/asset_list.dart';
import 'package:portfolio_follow/screens/summary_navigation_bar.dart';
import 'package:portfolio_follow/screens/realtime_quote.dart';
import 'package:portfolio_follow/screens/wallet_allocation.dart';

void main() => runApp(MaterialApp(
      title: 'PortfolioApp',
      home: PortfolioApp(),
    ));

class PortfolioApp extends StatefulWidget {
  @override
  _PortfolioApp createState() => _PortfolioApp();
}

class _PortfolioApp extends State<PortfolioApp> {
  static int _currentPage = 0;
  static List<Page> _pages = [
    Page(
      title: 'Minha Carteira',
      page: WalletAllocation(animate: GlobalVariables.animate),
      showBottomNavigation: true,
    ),
    Page(
      title: 'Rentabilidade',
      page: HistoryPerformance(animate: GlobalVariables.animate),
      showBottomNavigation: true,
    ),
    Page(
      title: 'Cotação',
      page: RealtimeQuote(),
      showBottomNavigation: true,
    ),
    Page(
      title: 'Meus Ativos',
      page: AssetList(),
      showBottomNavigation: false,
    )
  ];

  void updateData(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_currentPage].title),
      ),
      body: _pages[_currentPage].page,
      bottomNavigationBar: _pages[_currentPage].showBottomNavigation
          ? SummaryNavigationBar(_currentPage, updateData)
          : null,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child:
                  Text('PortfolioApp', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text('Resumo da Posição'),
              onTap: () {
                setState(() {
                  _currentPage = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Meus Ativos'),
              onTap: () {
                setState(() {
                  _currentPage = 3;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class Page {
  String title;
  Widget page;
  bool showBottomNavigation;

  Page({
    this.title,
    this.page,
    this.showBottomNavigation,
  });
}
