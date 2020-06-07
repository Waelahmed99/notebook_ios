import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class BookSelectionsSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).selectedBook;
    return Container(
      color: Color(0xfff6f6f6),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            _buildSelectionTitle(),
            SizedBox(height: 20),
            _buildSelectionsList(context, book.selections),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTitle() {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        'مقتطفات من الكتاب',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _buildSelectionsList(context, List<dynamic> selections) {
    return Column(
      children: selections
          .asMap()
          .map(
            (idx, element) => MapEntry(
              idx,
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerRight,
                      child: SvgPicture.asset(
                        'assets/quote_up.svg',
                        height: 10,
                        width: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        element,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 5),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: SvgPicture.asset(
                        'assets/quote_down.svg',
                        height: 10,
                        width: 10,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    SizedBox(height: 5),
                    (idx == selections.length - 1)
                        ? SizedBox(height: 5)
                        : Divider(),
                  ],
                ),
              ),
            ),
          )
          .values
          .toList(),
    );
  }
}
