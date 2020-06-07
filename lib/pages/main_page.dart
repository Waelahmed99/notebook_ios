import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/pages/home_page.dart';
import 'package:notebook_provider/pages/my_books_page.dart';
import 'package:notebook_provider/pages/search_page.dart';
import 'package:notebook_provider/widgets/rtl_bottom_bar.dart';

class MainPage extends StatefulWidget {
  @override
  createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final PageController _controller = PageController(initialPage: 0);
  int _currentIdx = 0;
  // Page view for swiping between pages.
  Widget _buildPageView() {
    List<Widget> _children = [
      HomePage(),
      SearchPage(),
      MyBooksPage(),
      Container(color: Colors.green),
    ];
    return PageView(
      controller: _controller,
      children: _children,
      reverse: true,
      onPageChanged: (idx) {
        setState(() => _currentIdx = idx);
      },
    );
  }

  Widget _buildRTLBottomBar() {
    // Bottom navigation items
    final List<RTLbottomItem> _items = [
      RTLbottomItem(title: Values.HOME, icon: Values.HOME_ASSET),
      RTLbottomItem(title: Values.SEARCH, icon: Values.SEARCH_ASSET),
      RTLbottomItem(title: Values.MY_BOOKS, icon: Values.BOOK_ASSET),
      RTLbottomItem(title: Values.MORE, icon: Values.MORE_ASSET),
    ];
    return RTLBottomBar(
      currentIndex: _currentIdx,
      onTap: (int idx) => _controller.animateToPage(idx,
          duration: Duration(milliseconds: 800), curve: Curves.ease),
      backgroundColor: Colors.white,
      items: _items,
      textColor: Theme.of(context).primaryColor,
      selectedItemColor: Theme.of(context).primaryColor,
      accentColor: Theme.of(context).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildPageView(),
      bottomNavigationBar: _buildRTLBottomBar(),
    );
  }
}
