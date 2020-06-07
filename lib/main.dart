import 'package:flutter/material.dart';
import 'package:notebook_provider/constant_values.dart';
import 'package:notebook_provider/pages/book_details_page.dart';
import 'package:notebook_provider/pages/main_page.dart';
import 'package:notebook_provider/pages/pdf_viewer.dart';
import 'package:notebook_provider/providers/firebase_provider.dart';
import 'package:provider/provider.dart';
import 'pages/auth_page.dart';
import 'providers/user_provider.dart';

Future<void> main() async {
  // Authenticating User before showing pages.
  WidgetsFlutterBinding.ensureInitialized();
  UserModel model = UserModel();
  bool isAuth = await model.isAuthenticated();

  runApp(MyApp(model, isAuth));
}

/* Main application entry */
class MyApp extends StatelessWidget {
  final UserModel model;
  final bool isAuth;
  MyApp(
    this.model,
    this.isAuth,
  );

  // Application ThemeData.
  ThemeData _appTheme() {
    return ThemeData(
      primaryColor: Values.primaryColor,
      accentColor: Values.accentColor,
      fontFamily: Values.fontFamily,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Firebase provider that is used for data flow inside this project.
    FirebaseModel firebaseModel =
        FirebaseModel(isAuth ? model.user.userId : '');

    // Providing FirebaseModel and UserModel to the whole application.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: model),
        ChangeNotifierProvider.value(value: firebaseModel),
      ],
      child: MaterialApp(
        theme: _appTheme(),
        routes: {
          '/': (_) => isAuth ? MainPage() : AuthPage(),
          Values.MAIN_PAGE: (_) => MainPage(),
          Values.AUTH_PAGE: (_) => AuthPage(),
        },
        onGenerateRoute: (RouteSettings settings) {
          // '/books/{$bookId} <- Route for navigating to book details
          final List<String> path = settings.name.split('/');
          // After splitting: Null  |  books  |  bookId
          if (path[0] != '') return null;
          final String bookId = path[2];
          firebaseModel.selectedBookId = bookId;

          return MaterialPageRoute(
            builder: (_) => (path[1] == Values.BOOKS) ? BookDetailsPage() : PDFViewer(),
          );
        },
      ),
    );
  }
}
