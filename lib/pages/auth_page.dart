import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/widgets/auth_form.dart';

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              SizedBox(height: 70),
              _buildTitleWidget(primaryColor),
              SizedBox(height: 20),
              _buildLogoWidget(primaryColor),
              SizedBox(height: 20),
              _buildQuoteWidget(primaryColor),
              SizedBox(height: 70),
              AuthenticationFrom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleWidget(Color primaryColor) {
    return Center(
      child: Text(
        Values.AUTH_TITLE,
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
      ),
    );
  }

  Widget _buildLogoWidget(Color primaryColor) {
    return SvgPicture.asset(
      Values.LOGO_ASSET,
      color: primaryColor,
    );
  }

  Widget _buildQuoteWidget(Color primaryColor) {
    return Center(
      child: Text(
        Values.AUTH_QUOTE,
        style: TextStyle(
          fontSize: 20,
          color: primaryColor,
        ),
      ),
    );
  }
}
