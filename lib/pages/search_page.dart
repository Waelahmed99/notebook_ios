import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:notebook_provider/widgets/book/book_item.dart';
import 'package:notebook_provider/widgets/center_title.dart';
import 'package:notebook_provider/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _content = '';

  void updateContent(String content) {
    setState(() {
      _content = content;
    });
  }

  Firestore firestore;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff6be7e6e7),
      body: Column(
        children: <Widget>[
          _buildCenterTitle(), // Center title.
          SizedBox(height: 10),
          SearchBar(updateContent), // search textfield.
          SizedBox(height: 2),
          _buildBooksStream(context), // Stream of books.
        ],
      ),
    );
  }

  // Page's title
  SafeArea _buildCenterTitle() {
    return SafeArea(
      child: CenteredTitle(Values.SEARCH, backgroundColor: Colors.white),
    );
  }

  //
  StreamBuilder<QuerySnapshot> _buildBooksStream(BuildContext context) {
    FirebaseModel firebaseModel =
        Provider.of<FirebaseModel>(context, listen: false);
    return StreamBuilder(
      stream: firebaseModel.getBooks(ListMode.All),
      builder: (context, AsyncSnapshot<QuerySnapshot> snap) {
        // Still loading data.
        // if (snap.connectionState == ConnectionState.waiting)
        //   return _buildWaitingState(context);
        // No books found.
        if (!snap.hasData) return _buildNoBooksFound();
        // Data loaded, View it.
        List<DocumentSnapshot> data = snap.data.documents;
        // Save downloaded list locally (Caching)
        firebaseModel.addBooks(data);
        List<DocumentSnapshot> matchData = data
            .where(
              (element) =>
                  element.data[Values.BOOK_TITLE].toString().contains(_content),
            )
            .toList();

        // No matched content
        if (matchData.length == 0) return _buildNoBooksFound();

        return _buildBooksList(matchData);
      },
    );
  }

  // Builds matched books.
  Expanded _buildBooksList(List<DocumentSnapshot> matchData) {
    return Expanded(
      child: ListView.builder(
        itemBuilder: (_, int idx) {
          return ZoomIn(
            duration: Duration(milliseconds: 600),
            child: BookItem(matchData[idx].documentID),
          );
        },
        itemCount: matchData.length,
      ),
    );
  }

  // Data is still loading.
  Center _buildWaitingState(BuildContext context) {
    return Center(
        child: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  // No books found or matched the search.
  Center _buildNoBooksFound() {
    return Center(
      child: Text(Values.NO_BOOK_FOUND),
    );
  }
}
