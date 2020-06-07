import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class PersonalBookItem extends StatelessWidget {
  final String id;
  PersonalBookItem(this.id);

  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).books[id];
    return GestureDetector(
      /// Generates a route like this -> /books/[book.id]
      onTap: () => Navigator.of(context).pushNamed(Values.BOOK_PAGE(book.id)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 20, right: 40, bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: _buildBookStack(context, book),
      ),
    );
  }

  // Builds book details [Title|Type|Author|Image|Read|Listen]
  Stack _buildBookStack(BuildContext context, Book book) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        _buildBookTitle(book.title),
        _buildBookType(context, book.type),
        _buildBookAuthor(book.author),
        _buildBookImage(book.image),
        book.isReadBought
            ? _buildReadBookButton(context, book.id)
            : Container(),
      ],
    );
  }

  /// Builds [book.title]
  Align _buildBookTitle(String title) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(right: 45),
        child: Text(
          title,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }

  Align _buildBookType(BuildContext context, String type) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 45, top: 10),
        child: Text(
          type,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }

  Align _buildBookAuthor(String author) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: 45, bottom: 10),
        child: Text(
          author,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xffbcbaba),
          ),
        ),
      ),
    );
  }

  Positioned _buildBookImage(String image) {
    return Positioned(
      child: Image.asset(
        image,
        height: 90,
        width: 70,
      ),
      right: -30,
      top: 5,
    );
  }

  Align _buildReadBookButton(BuildContext context, String bookId) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: GestureDetector(
        /// Generates a route like this -> /PDF/[bookId]
        onTap: () => Navigator.of(context).pushNamed(Values.PDF_PAGE(bookId)),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          margin: EdgeInsets.only(left: 10, bottom: 5),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                Values.READ_BOOK,
                style: TextStyle(color: Colors.white),
                textDirection: TextDirection.rtl,
              ),
              SvgPicture.asset(Values.READ_ASSET)
            ],
          ),
        ),
      ),
    );
  }
}
