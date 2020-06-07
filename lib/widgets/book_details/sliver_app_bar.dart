import 'package:flutter/material.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

import '../../constant_values.dart';

class CustomSliverAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context, listen: true).selectedBook;
    return SliverAppBar(
      expandedHeight: 150.0,
      actions: <Widget>[
        _buildActionsContainer(context, book),
      ],
    );
  }

  // Align actions buttons.
  Container _buildActionsContainer(BuildContext context, Book book) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          _buildShareButton(book),
          _buildFavoriteButton(context, book.isFavorite),
          _buildBackButton(context),
        ],
      ),
    );
  }

  // Builds share button to share book details.
  IconButton _buildShareButton(Book book) {
    return IconButton(
      icon: const Icon(Icons.share),
      tooltip: 'مشاركة',
      onPressed: () => Values.SHARE_BOOK(book.title, book.description),
    );
  }

  // Builds favorite icon button.
  Widget _buildFavoriteButton(BuildContext context, bool isFavorite) {
    return IconButton(
      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
      tooltip: 'مفضلة',
      // Toggle book's favorite
      onPressed: () => Provider.of<FirebaseModel>(context, listen: false).toggleFavorite(),
    );
  }

  // Back button to return to previous page.
  Expanded _buildBackButton(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Align(
            child: IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              tooltip: 'العودة',
              // Pop view.
              onPressed: () => Navigator.of(context).pop(),
            ),
            alignment: Alignment.topRight,
          )
        ],
      ),
    );
  }
}
