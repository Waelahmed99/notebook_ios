import 'package:flutter/material.dart';
import 'package:notebook_provider/models/book.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/models/payment.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';

class ListenToBookButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Book book = Provider.of<FirebaseModel>(context).selectedBook;
    return Consumer<FirebaseModel>(
      builder: (_, FirebaseModel firebaseModel, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            book.isListenBought
                ? _buildListenButton()
                : _buildBuyButton(context),
            child,
          ],
        );
      },
      child: Text(
        'نسخة مسموعة',
        textDirection: TextDirection.rtl,
        style: TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildListenButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
        decoration: BoxDecoration(
          color: Color(0xff459232),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'استمع',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildBuyButton(BuildContext context) {
    FirebaseModel model = Provider.of<FirebaseModel>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Payment payment = Payment(
          onSuccess: model.buyBook,
          mode: BuyMode.Listen,
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
