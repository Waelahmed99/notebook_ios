import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/pages/books_list.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

import 'book/book_card.dart';

class HorizontalPreview extends StatelessWidget {
  final String title;
  final ListMode mode;
  final String type;
  HorizontalPreview(this.title, {this.mode, this.type});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildInfoRow(context),
        Container(
          height: 250,
          width: MediaQuery.of(context).size.width,
          child: _buildItemsList(context),
        ),
      ],
    );
  }

  // Builds more button.
  Widget _buildMoreButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BooksListPage(
            mode: mode,
            type: type,
          ),
        ),
      ),
      child: _buildMoreButtonContent(context),
    );
  }

  Container _buildMoreButtonContent(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).accentColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
        child: Text(
          'المزيد',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  // builds list title
  Widget _buildTitleText() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // Combine list's information.
  Widget _buildInfoRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildMoreButton(context),
        _buildTitleText(),
      ],
    );
  }

  // Builds list.
  Widget _buildItemsList(context) {
    return Consumer<FirebaseModel>(
      builder: (_, FirebaseModel model, child) {
        Map<String, Book> books = model.getBooksByMode(mode);
        return model.isLoading
            ? _buildCircularIndicator(context)
            : _buildBooksList(books, context);
      },
    );
  }

  // Loading state.
  Center _buildCircularIndicator(context) {
    return Center(
      child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Show Books' list.
  Widget _buildBooksList(Map<String, Book> data, context) {
    var dataList = data
        .map((key, value) => MapEntry(
            key,
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: BookCard(key),
            )))
        .values
        .toList();
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      reverse: true,
      itemBuilder: (context, int idx) {
        return dataList[idx];
      },
      itemCount: min(data.length, 6),
    );
  }
}
