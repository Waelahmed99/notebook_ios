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
    return StreamBuilder(
      stream:
          model.getBooks(mode), // Retrieving books depending on the given mode.
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        // Check if still loading.
        if (!snap.hasData) return _buildLoadingStat(context);
        // Stream loaded, build the list.
        return _buildBooksList(snap.data.documents);
      },
    );
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
  Widget _buildBooksList(List<DocumentSnapshot> data) {
    Map<int, dynamic> dataMap = data.asMap();
    return Column(
        children: dataMap
            .map(
              (idx, element) {
                return MapEntry(
                  idx,
                  _buildBookCard(data[idx].documentID),
                );
              },
            )
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
