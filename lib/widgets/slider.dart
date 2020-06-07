import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class SliderList extends StatelessWidget {
  final List<Widget> items = [
    Image.asset(
      'assets/book_image.png',
      width: 150,
      height: 250,
    ),
    Image.asset(
      'assets/book_image2.png',
      width: 150,
      height: 250,
    ),
    Image.asset(
      'assets/book_image.png',
      width: 150,
      height: 250,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.45,
        initialPage: 0,
        reverse: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
        pauseAutoPlayOnTouch: true,
      ),
      items: items,
    );
  }
}
