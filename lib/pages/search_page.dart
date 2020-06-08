import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/book.dart';
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
  Widget _buildBooksStream(BuildContext context) {
    FirebaseModel model = Provider.of<FirebaseModel>(context, listen: false);
    Map<String, Book> books = model.getMatchedBooks(_content);
    return model.isLoading ? Container() : _buildBooksList(books);
  }

  // Builds matched books.
  Expanded _buildBooksList(Map<String, Book> matchData) {
    var dataList = matchData
        .map((key, value) => MapEntry(key, BookItem(key)))
        .values
        .toList();
    return Expanded(
      child: ListView.builder(
        itemBuilder: (_, int idx) {
          return ZoomIn(
            duration: Duration(milliseconds: 600),
            child: dataList[idx],
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
