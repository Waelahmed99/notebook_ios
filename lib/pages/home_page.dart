import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:notebook_provider/widgets/center_title.dart';
import 'package:notebook_provider/widgets/horizontal_list_preview.dart';
import 'package:notebook_provider/widgets/quote_widget.dart';
import 'package:notebook_provider/widgets/slider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    FirebaseModel model = Provider.of<FirebaseModel>(context, listen: false);
    if (!model.downloadedOnce)
      model.getBooks();
    super.initState();
  }

  // List of widgets inside the home page
  final List<Widget> _children = [
    // Page's title
    SafeArea(child: CenteredTitle(Values.HOME)),
    // Top 3 Slider list.
    SizedBox(height: 15),
    SliderList(),
    SizedBox(height: 15),
    // Horizontal List of books  (Most recent)
    HorizontalPreview(Values.MOST_RECENT, mode: ListMode.MostRecent),
    SizedBox(height: 10),
    // Quote of the day.
    QuoteWidget(),
    SizedBox(height: 10),
    // Horizontal list of books (Best selling)
    HorizontalPreview(Values.BEST_SELLING, mode: ListMode.MostSelling),
    SizedBox(height: 10)
  ];

  // Scrollable column to display above content.
  Widget _buildColumnWidget() {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: _children,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: _buildColumnWidget(),
    );
  }
}
