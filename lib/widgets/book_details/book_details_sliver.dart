import 'package:flutter/material.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class BooksDetailsSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen to book's changes
    Book book = Provider.of<FirebaseModel>(context, listen: false).selectedBook;
    return Container(
      color: Theme.of(context).primaryColor,
      child: Container(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: _buildBookDetails(context, book),
      ),
    );
  }

  // Book's details column
  Column _buildBookDetails(BuildContext context, Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildBookType(context, book.type),
        SizedBox(height: 5),
        _buildBookTitle(book.title),
        SizedBox(height: 5),
        _buildBookAuthor(book.author),
        SizedBox(height: 10),
        _buildBookNominations(book.nominations),
        SizedBox(height: 15),
        _buildBookDescription(book.description),
      ],
    );
  }

  /// Builds [book.type]
  Widget _buildBookType(context, String type) {
    return Text(
      type,
      textDirection: TextDirection.rtl,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
    );
  }

  /// Builds [book.title]
  Text _buildBookTitle(String title) {
    return Text(
      title,
      textDirection: TextDirection.rtl,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
    );
  }

  /// Builds [book.author]
  Text _buildBookAuthor(String author) {
    return Text(
      author,
      textDirection: TextDirection.rtl,
      style: TextStyle(color: Color(0xff9a9899), fontSize: 17),
    );
  }

  /// Builds [book.nominations] message.
  Row _buildBookNominations(int nominations) {
    String nominationMessage = _generateNominationMessage(nominations);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          '${nominationMessage}',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 5),
        Icon(Icons.star, color: Colors.yellow),
      ],
    );
  }

  /// Nomination message depending on the [book.nominations] count
  // due to arabic language grammar variety in numbering system. (شخص | شخصان | 3 أشخاص | 20 شخص)
  String _generateNominationMessage(int nominations) {
    String nominatingMessage = (nominations != 2 && nominations != 0
        ? nominations.toString() + ' '
        : '');
    nominatingMessage += (nominations <= 10 ? 'أشخاص' : 'شخص');
    if (nominations == 2) nominatingMessage = 'شخصين';
    nominatingMessage += ' رشحوا هذا الكتاب';
    if (nominations == 1)
      nominatingMessage = 'شخص واحد رشح هذا الكتاب';
    else if (nominations == 0) nominatingMessage = 'لم يرشح أحد هذا الكتاب';
    return nominatingMessage;
  }

  /// Builds [book.description]
  Text _buildBookDescription(String description) {
    return Text(
      description,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 17,
      ),
    );
  }
}
