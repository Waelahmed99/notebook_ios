import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/models/payment.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class ReadBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).selectedBook;
    bool isBought = book.isReadBought;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          isBought
              ? _buildReadButton(context, book.id)
              : _buildBuyButton(context, book.id),
          Text('نسخة مقروءة',
              textDirection: TextDirection.rtl, style: TextStyle(fontSize: 16)),
        ]);
  }

  // If book is bought, build a READ button to PDFViewer.
  Widget _buildReadButton(context, String bookId) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(Values.PDF_PAGE(bookId)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xff459232),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'اقرأ',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // If book is not bought, build a BUY button to Pay.
  Widget _buildBuyButton(BuildContext context, String bookId) {
    FirebaseModel model = Provider.of<FirebaseModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Payment payment = Payment(
          onSuccess: model.buyBook,
          mode: BuyMode.Read,
        );
        payment.startPayment();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'شراء',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
