import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class BookCard extends StatelessWidget {
  final String bookId;
  BookCard(this.bookId);

  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).books[bookId];
    return InkWell(
      /// Generate route like this -> /books/[book.id]
      onTap: () => Navigator.of(context).pushNamed(Values.BOOK_PAGE(book.id)),
      child: Container(
        padding: EdgeInsets.all(1),
        child: _buildBook(book),
      ),
    );
  }

  // Build book details column (Image|Title|Author).
  Column _buildBook(Book book) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        _buildBookImage(book.image),
        SizedBox(height: 5),
        _buildBookTitle(book.title),
        SizedBox(height: 5),
        _buildBookAuthor(book.author),
      ],
    );
  }

  /// Builds [book.image]
  Widget _buildBookImage(String image) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: FadeInImage(
        image: NetworkImage(image),
        fit: BoxFit.cover,
        height: 170,
        width: 120,
        placeholder: AssetImage(Values.PLACE_HOLDER),
      ),
    );
  }

  /// Builds [book.title]
  Text _buildBookTitle(String title) {
    return Text(
      title,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  /// Builds [book.author]
  Text _buildBookAuthor(String author) {
    return Text(
      author,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontSize: 13,
        color: Color(0xffbcbaba),
      ),
    );
  }
}
