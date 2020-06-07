import 'package:flutter/cupertino.dart';

class CenteredTitle extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  CenteredTitle(this.title, {this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 5),
      color: backgroundColor,
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
