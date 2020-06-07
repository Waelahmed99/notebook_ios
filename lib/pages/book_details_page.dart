import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../widgets/book_details/book_buttons_sliver.dart';
import '../widgets/book_details/book_details_sliver.dart';
import '../widgets/book_details/book_selections_sliver.dart';
import '../widgets/book_details/sliver_app_bar.dart';
import '../widgets/horizontal_list_preview.dart';

class BookDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve selectedBook from the provider's model.
    // Book book = Provider.of<FirebaseModel>(context).selectedBook;
    // Increment selected book's view count.
    /* */

    // List of slivers that will be displayed on the Scrollable area.
    List<Widget> _slivers = [
      CustomSliverAppBar(),
      /* Top appbar */
      SliverToBoxAdapter(child: BooksDetailsSliver()),
      /* Book's details */
      SliverToBoxAdapter(child: BookButtonsSliver()),
      /* Read, Listen and Nominate buttons */
      SliverToBoxAdapter(child: BookSelectionsSliver()),
      /* Book's selections view */
      SliverToBoxAdapter(child: _buildMoreBooksSliver(context)),
      /* More books (Based on Type) */
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: _slivers,
      ),
    );
  }

  /* View more books based on book's type */
  Container _buildMoreBooksSliver(BuildContext context) {
    return Container(
      color: Values.GREY_BACKGROUND,
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          HorizontalPreview(
            Values.READ_MORE,
            mode: ListMode.MoreLike,
            type: Provider.of<FirebaseModel>(context).selectedBook.type,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
