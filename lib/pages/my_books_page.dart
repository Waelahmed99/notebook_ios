import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:notebook_provider/widgets/book/personal_book_item.dart';
import 'package:notebook_provider/widgets/center_title.dart';
import 'package:provider/provider.dart';

class MyBooksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Values.BACKGROUND_COLOR,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            _buildCenterTitle(),
            SizedBox(height: 10),
            _buildMyBooksList(context),
          ],
        ),
      ),
    );
  }

  // Page's title
  SafeArea _buildCenterTitle() {
    return SafeArea(
      child: CenteredTitle(
        Values.MY_BOOKS,
        backgroundColor: Colors.white,
      ),
    );
  }

  // Stream the personal books from firebase Provider.
  Widget _buildMyBooksList(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<FirebaseModel>(context).getPersonalBooks(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        // Data is loading
        if (snap.connectionState == ConnectionState.waiting)
          return _buildLoadingProgress(context);
        // No data to be shown.
        if (!snap.hasData) return _buildNoBooksWidget();
        // Data is loaded, view it.
        return _buildBooksList(snap.data.documents, context);
      },
    );
  }

  // No bought books, notify the user.
  Widget _buildNoBooksWidget() => Center(child: Text(Values.NO_BOUGHT_BOOKS));

  // Build the scrollable list of books after loading it.
  Expanded _buildBooksList(List<DocumentSnapshot> data, context) {
    //todo: Need configurations.
    Provider.of<FirebaseModel>(context, listen: false).addBooks(data);
    return Expanded(
      child: ListView.builder(
        itemBuilder: (context, int idx) =>
            PersonalBookItem(data[idx].documentID),
        itemCount: data.length,
      ),
    );
  }

  // build a loading indicator.
  Center _buildLoadingProgress(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
