import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SearchBar extends StatelessWidget {
  final Function updateContent;
  BuildContext context;
  SearchBar(this.updateContent);

  Widget _buildSeparateLine() => Container(
      width: 1,
      color: Theme.of(context).primaryColor,
      margin: EdgeInsets.all(5));

  Widget _buildSvgIcon() => Container(
      padding: EdgeInsets.all(5),
      child: SvgPicture.asset('assets/search.svg', width: 15));

  Widget _buildText() => Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          onChanged: (value) {
            updateContent(value);
          },
          cursorColor: Theme.of(context).primaryColor,
          maxLines: 1,
          // textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'بحث',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        ),
      );

  @override
  Widget build(BuildContext ctx) {
    context = ctx;
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(child: _buildText()),
          _buildSeparateLine(),
          _buildSvgIcon(),
        ],
      ),
    );
  }
}
