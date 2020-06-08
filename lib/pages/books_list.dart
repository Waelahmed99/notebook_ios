import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:notebook_provider/widgets/book/book_item.dart';
import 'package:provider/provider.dart';

class BooksListPage extends StatelessWidget {
  final ListMode mode;
  final String type;
  BooksListPage({
    this.mode,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 30),
        child: SingleChildScrollView(
          child: _buildStreamBuilder(context),
        ),
      ),
    );
  }

  /* Building books list using Streams from Firebase Provider */
  Widget _buildStreamBuilder(context) {
    FirebaseModel model = Provider.of<FirebaseModel>(context);
    Map<String, Book> books = model.getBooksByMode(mode);
    return model.isLoading
        ? _buildLoadingStat(context)
        : _buildBooksList(books);
  }

  // Loading Circular indicator.
  Widget _buildLoadingStat(context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Build books list using a column.
  Widget _buildBooksList(Map<String, Book> data) {
    return Column(
        children: data
            .map((key, value) => MapEntry(key, _buildBookCard(key)))
            .values
            .toList());
  }

  // Book item inside the list.
  Padding _buildBookCard(String bookId) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BookItem(bookId),
    );
  }
}
