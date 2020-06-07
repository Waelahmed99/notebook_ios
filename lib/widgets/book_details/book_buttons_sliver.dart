import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:notebook_provider/widgets/book_details/read_book_button.dart';
import 'package:provider/provider.dart';
import 'listen_book_button.dart';

class BookButtonsSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 25),
          ReadBookButton(),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          ListenToBookButton(),
          SizedBox(height: 10),
          Divider(),
          SizedBox(height: 10),
          NominationButton(),
          SizedBox(height: 15),
        ],
      ),
    );
  }
}

// Toggle book's nomination.
class NominationButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Liste to nomination state changing.
    bool isNominated =
        Provider.of<FirebaseModel>(context).selectedBook.isNominated;
    return Row(
      children: [
        GestureDetector(
          // Toggle nomination.
          onTap: () => Provider.of<FirebaseModel>(context, listen: false)
              .toggleNomination(),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xffffb80f),
              borderRadius: BorderRadius.circular(20),
            ),
            child: _buildNominateButton(isNominated),
          ),
        )
      ],
    );
  }

  // Buids button's details.
  Row _buildNominateButton(bool isNominated) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Consumer<FirebaseModel>(
          builder: (context, FirebaseModel model, child) {
            return model.isLoading ? _buildProgressIndicator() : child;
          },
          child: Text(
            isNominated ? Values.UN_NOMINATE_BOOK : Values.NOMINATE_BOOK,
            textDirection: TextDirection.rtl,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
        SizedBox(width: 5),
        Icon(
          Icons.star,
          color: Colors.white,
        )
      ],
    );
  }

  // Build when nominating is loading.
  SizedBox _buildProgressIndicator() {
    return SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(),
    );
  }
}
