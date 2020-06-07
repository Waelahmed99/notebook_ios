import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AuthenticationFrom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationFrom> {
  UserModel userModel;
  Authentication auth =
      Authentication.Login; // Login is the default authentication state.

  // Only Authenticate function from UserModel is used here.
  // todo: Think of a way to reduce this cost.
  @override
  Widget build(BuildContext context) {
    userModel = Provider.of<UserModel>(context);
    return Column(
      children: [
        _buildForm(),
        SizedBox(height: 20),
        _willBuildAuthButton(),
        SizedBox(height: 5),
        _buildSwapState()
      ],
    );
  }

  // To request focus from [currentFocus] to [nextFocus].
  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  // Email field
  final FocusNode _emailFocus = FocusNode();
  TextDirection _emailDirection = TextDirection.rtl;
  Widget _buildEmailField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Directionality(
        textDirection: _emailDirection,
        child: TextFormField(
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          focusNode: _emailFocus,
          onFieldSubmitted: (value) {
            _fieldFocusChange(context, _emailFocus, _passwordFocus);
          },
          validator: (value) {
            if (value.isEmpty || !_checkEmail(value)) {
              return Values.ENTER_RIGHT_EMAIL;
            }
          },
          onChanged: (value) {
            setState(() {
              _emailDirection =
                  (value.isEmpty ? TextDirection.rtl : TextDirection.ltr);
            });
          },
          onSaved: (value) => _formData[Values.EMAIL] = value,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            fillColor: Colors.red,
            hintText: Values.FORM_EMAIL,
          ),
        ),
      ),
    );
  }

  // Check email input using a regular expression *@*.*
  bool _checkEmail(String value) {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(value);
  }

  // Password field
  /// _passwordFocus is used to request focus using next keyboard button.
  /// _passwordController is used to check for password matching.
  /// _passwordDirection swaps the direction from Right to Left when user types in English.
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController _passwordController = TextEditingController();
  TextDirection _passwordDirection = TextDirection.rtl;
  Widget _buildPasswordField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Directionality(
        textDirection: _passwordDirection,
        child: TextFormField(
          controller: _passwordController,
          textInputAction: auth == Authentication.Login
              ? TextInputAction.done
              : TextInputAction.next,
          keyboardType: TextInputType.visiblePassword,
          focusNode: _passwordFocus,
          onFieldSubmitted: (value) {
            auth == Authentication.Signup
                ? _fieldFocusChange(context, _passwordFocus, _rePasswordFocus)
                : _submit();
          },
          validator: (value) {
            if (value.isEmpty || value.length < 6)
              return Values.AUTH_WRONG_PASSWORD;
          },
          onSaved: (value) => _formData[Values.PASSWORD] = value,
          onChanged: (value) {
            if (value.isNotEmpty && _passwordDirection == TextDirection.ltr)
              return;
            setState(() {
              _passwordDirection =
                  (value.isEmpty ? TextDirection.rtl : TextDirection.ltr);
            });
          },
          obscureText: true,
          autofocus: false,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: Values.FORM_PASSWORD,
          ),
        ),
      ),
    );
  }

  // Re-enter password field
  /// _rePasswordFocus is used to request focus using next keyboard button.
  /// _rePasswordDirection swaps the direction from Right to Left when user types in English.
  final FocusNode _rePasswordFocus = FocusNode();
  TextDirection _rePasswordDirection = TextDirection.rtl;
  Widget _buildPasswordVerifyField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Directionality(
        textDirection: _rePasswordDirection,
        child: TextFormField(
          textInputAction: TextInputAction.done,
          focusNode: _rePasswordFocus,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autofocus: false,
          onChanged: (value) {
            setState(() {
              _rePasswordDirection =
                  (value.isEmpty ? TextDirection.rtl : TextDirection.ltr);
            });
          },
          onFieldSubmitted: (value) => _submit(),
          validator: (value) {
            if (_passwordController.text != value)
              return Values.PASSWORD_DONT_MATCH;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline),
            hintText: Values.RE_ENTER_PASSWORD,
          ),
        ),
      ),
    );
  }

  // Auth button depending on the authentication state (Login, Signup)
  Widget _buildAuthButton() {
    return GestureDetector(
      onTap: _submit,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Theme.of(context).primaryColor),
        child: Text(
          auth == Authentication.Login ? Values.LOGIN : Values.SIGNUP,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  /// _formData stores the input data from user.
  final Map<String, dynamic> _formData = {};

  /// _formKey identify the Form to use validate function.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // Submit user input.
  void _submit() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    userModel
        .authenticate(
            _formData[Values.EMAIL], _formData[Values.PASSWORD], auth, context)
        .then((value) => checkAuthenticateResult(value));
  }

  // Check the returned authentication result from Firebase Provider.
  void checkAuthenticateResult(String value) {
    // If value success, navigate to the Main page.
    if (value == Values.OPERATION_SUCCESS) {
      Navigator.of(context).pushReplacementNamed(Values.MAIN_PAGE);
    }
    // If failed to authenticate user, show an alert dialog with the error message.
    else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(Values.ERROR_TITLE, textDirection: TextDirection.rtl),
          content: Text(value, textDirection: TextDirection.rtl),
          actions: <Widget>[
            FlatButton(
              child: Center(child: Text(Values.EXIT)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  // Button that let the user swap between Login and Signup.
  Widget _buildSwapState() {
    return FlatButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: auth == Authentication.Login
          ? Text(Values.DONT_HAVE_ACCOUT)
          : Text(Values.HAVE_ACCOUNT),
      onPressed: () => setState(() => auth = (auth == Authentication.Login
          ? Authentication.Signup
          : Authentication.Login)),
    );
  }

  // The main form.
  /// _formKey identify the form values to use validate functions.
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _buildEmailField(),
          SizedBox(height: 15),
          _buildPasswordField(),
          auth == Authentication.Signup ? SizedBox(height: 15) : Container(),
          _willBuildPasswordVerifyField(),
        ],
      ),
    );
  }

  Widget _willBuildPasswordVerifyField() =>
      auth == Authentication.Signup ? _buildPasswordVerifyField() : Container();

  // Build the authentication button.
  // if the provider is loading, build a Circular Indicator.
  Widget _willBuildAuthButton() {
    return !userModel.isLoading
        ? _buildAuthButton()
        : CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor);
  }
}
