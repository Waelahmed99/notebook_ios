import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notebook_provider/models/quote.dart';

class QuoteWidget extends StatelessWidget {
  double _height = 170;
  Quote quote;
  Firestore firestore;

  Widget _buildUpperQuote() => Positioned(
      child: SvgPicture.asset('assets/quote_up.svg'), left: 20, top: 15);

  Widget _buildLowerQuote() => Positioned(
      child: SvgPicture.asset('assets/quote_down.svg'), bottom: 15, right: 100);

  Widget _buildBookPicture() => Positioned(
      height: _height,
      child: Center(
        child: Image.asset('assets/book_image.png', width: 100),
      ),
      right: -10);

  Widget _buildBookDetails() => Positioned(
      child: Text('${quote.writerName} - ${quote.bookName}',
          style: TextStyle(color: Colors.white)),
      bottom: 15,
      left: 30);

  Widget _buildBookContent(BuildContext context) => Container(
        width: MediaQuery.of(context).size.width - 130,
        height: _height,
        child: Center(
          child: Text(
            quote.content,
            style: TextStyle(color: Colors.white, fontSize: 13),
            textDirection: TextDirection.rtl,
          ),
        ),
      );

  void configHeight(context) {
    int length = quote != null ? quote.content.length : 170;
    _height = length * 10 / (MediaQuery.of(context).size.width);
    if (MediaQuery.of(context).orientation == Orientation.portrait)
      _height *= 25;
    else
      _height *= 40;
    _height = max(_height, 170);
  }

  @override
  Widget build(BuildContext context) {
    firestore = Firestore.instance;
    return StreamBuilder(
      stream: firestore.collection('quote').document('general').snapshots(),
      builder: (context, AsyncSnapshot snap) {
        Widget child;
        if (!snap.hasData)
          child = Center(child: CircularProgressIndicator());
        else {
          DocumentSnapshot data = snap.data;
          quote = Quote(
            bookName: data['bookName'],
            content: data['content'],
            writerName: data['writerName'],
          );
          configHeight(context);
          child = Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              _buildBookContent(context),
              _buildBookDetails(),
              _buildBookPicture(),
              _buildUpperQuote(),
              _buildLowerQuote(),
            ],
          );
        }
        return Container(
          margin: EdgeInsets.all(15.0),
          height: _height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).primaryColor,
          ),
          child: child,
        );
      },
    );
  }
}
