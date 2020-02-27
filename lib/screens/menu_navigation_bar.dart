import 'package:flutter/material.dart';

const _walletPageName = 'Carteira';
const _historyPageName = 'Rentabilidade';
const _quotePageName = 'Cotações';

class MenuNavigationBar extends StatefulWidget{
  int currentPage;
  void Function(int) onChangePage;

  MenuNavigationBar(this.currentPage, this.onChangePage);

  @override
  _MenuNavigationBarState createState() => _MenuNavigationBarState();
}

class _MenuNavigationBarState extends State<MenuNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.pie_chart), title: Text(_walletPageName)),
        BottomNavigationBarItem(icon: Icon(Icons.show_chart), title: Text(_historyPageName)),
        BottomNavigationBarItem(icon: Icon(Icons.attach_money), title: Text(_quotePageName)),
      ],
      currentIndex: widget.currentPage,
      selectedItemColor: Colors.blue[700],
      onTap: widget.onChangePage,
    );
  }
}