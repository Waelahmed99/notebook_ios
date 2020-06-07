import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class BookItem extends StatelessWidget {
  final String bookId;
  BookItem(this.bookId);

  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).books[bookId];
    return GestureDetector(
      /// generate a route like this -> /books/[book.id]
      onTap: () => Navigator.of(context).pushNamed(Values.BOOK_PAGE(book.id)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(left: 20, right: 40, bottom: 10),
        width: MediaQuery.of(context).size.width,
        height: 100,
        child: _buildItemStack(context, book),
      ),
    );
  }

  // Build book item [favorite|cost|title|type|author|image]
  Stack _buildItemStack(BuildContext context, Book book) {
    return Stack(
      overflow: Overflow.visible,
      children: <Widget>[
        _buildFavoriteButton(context, book.isFavorite, book.id),
        _buildBookCost(book.readCost, context),
        _buildBookTitle(book.title),
        _buildBookType(book.type, context),
        _buildBookAuthor(book.author),
        _buildBookImage(book.image),
      ],
    );
  }

  // Toggle favorite state from Firebase Provider.
  Align _buildFavoriteButton(
      BuildContext context, bool isFavorite, String bookId) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        // margin: EdgeInsets.only(left: 10, top: 10),
        child: IconButton(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Theme.of(context).primaryColor,
          ),
          onPressed: () => Provider.of<FirebaseModel>(context, listen: false)
              .toggleFavorite(bookId: bookId),
        ),
      ),
    );
  }

  /// Builds [book.readCost]
  Align _buildBookCost(int readCost, BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        margin: EdgeInsets.only(left: 10, bottom: 7),
        child: Text(
          '${readCost.toString()} ${Values.CURRENCY}',
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
        ),
      ),
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

  /// Builds [book.type]
  Align _buildBookType(String type, BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
        margin: EdgeInsets.only(right: 45, top: 10),
        child: Text(
          type,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  /// Builds [book.author]
  Align _buildBookAuthor(String author) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.only(right: 45, bottom: 10),
        child: Text(
          author,
          textDirection: TextDirection.rtl,
          style: TextStyle(fontSize: 14, color: Color(0xffbcbaba)),
        ),
      ),
    );
  }

  /// Builds [book.image]
  Positioned _buildBookImage(String image) {
    return Positioned(
      child: FadeInImage(
        image: NetworkImage(image),
        height: 90,
        width: 70,
        placeholder: AssetImage(Values.PLACE_HOLDER),
      ),
      right: -30,
      top: 5,
    );
  }
}
