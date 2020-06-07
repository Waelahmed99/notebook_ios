import 'package:flutter/material.dart';
import 'package:share/share.dart';

/* Constant/Static values and strings that will be used inside Notebook app */
class Values {
  // ThemeData
  static final Color primaryColor = Color(0xfff95563);
  static final Color accentColor = Color(0xfffeebee);
  static final String fontFamily = 'Gulf';
  static final Color GREY_BACKGROUND = Color(0xfff6f6f6);
  static final Color BACKGROUND_COLOR = Color(0xff6be7e6e7);

  // Firebase constants
  static final String BOOKS = 'books';
  static final String PERSONAL_BOOKS = 'personal books';

  // Book constants
  static final String BOOK_ID = 'id';
  static final String BOOK_AUTHOR = 'author';
  static final String BOOK_IMAGE = 'image';
  static final String BOOK_IS_FAVORITE = 'isFavorite';
  static final String BOOK_FAVORITE = 'favorite';
  static final String BOOK_TITLE = 'title';
  static final String BOOK_SELL_COUNT = 'sellCount';
  static final String BOOK_TYPE = 'type';
  static final String BOOK_VIEW_COUNT = 'viewCount';
  static final String BOOK_READ_COST = 'readCost';
  static final String BOOK_LISTEN_COST = 'listenCost';
  static final String BOOK_DESCRIPTION = 'description';
  static final String BOOK_NOMINATIONS = 'nominations';
  static final String BOOK_SELECTIONS = 'selections';
  static final String BOOK_READ_BOUGHT = 'readBought';
  static final String BOOK_LISTEN_BOUGHT = 'listenBought';
  static final String BOOK_IS_READ_BOUGHT = 'isReadBought';
  static final String BOOK_IS_LISTEN_BOUGHT = 'isListenBought';

  // Strings
  static final String AUTH_TITLE = 'The Notebook';
  static final String AUTH_QUOTE = 'أنت تسمع، نحن نقرأ';
  static final String READ_MORE = 'اقرأ أيضاً';
  static final String HOME = 'الرئيسية';
  static final String SEARCH = 'بحث';
  static final String MY_BOOKS = 'كتبي';
  static final String MORE = 'المزيد';
  static final String MOST_RECENT = 'الأحدث قراءة';
  static final String BEST_SELLING = 'الأكثر مبيعاً';
  static final String EXIT = 'اغلاق';
  static final String CURRENCY = 'دينار';
  static final String READ_BOOK = 'اقرأ الكتاب';
  static final String LISTEN_TO_BOOK = 'استمع إلى الكتاب';
  static final String NOMINATE_BOOK = 'ترشيح الكتاب';
  static final String UN_NOMINATE_BOOK = 'الغاء ترشيح الكتاب';

  // Error messages
  static final String NO_BOUGHT_BOOKS = 'أنت لا تمتلك أي كتاب حتى الآن';
  static final String NO_PDF_ERROR = 'حدث خطأ ما، برجاء المحاولة مرةً اخرى';
  static final String NO_BOOK_FOUND = 'لم يتم العثور على هذا الكتاب';
  static final String AUTH_INVALID_EMAIL = 'البريد الإلكتروني خاطئ';
  static final String AUTH_WRONG_PASSWORD = 'كلمة المرور خاطئة';
  static final String AUTH_USER_NOT_FOUND = 'عفواً لا يوجد مستخدم بهذا البريد';
  static final String AUTH_USER_DISABLED = 'لقد تم إيقاف هذا المستخدم';
  static final String AUTH_EMAIL_ALREADY_IN_USE = 'هذا البريد مسجل بالفعل';
  static final String AUTH_TOO_MANY_REQUESTS = 'برجاء المحاولة مرة اخرى';
  static final String AUTH_OPERATION_NOT_ALLOWED =
      'حدث خطأ، برجاء التواصل معنا';
  static final String AUTH_UNEXPECTED_ERROR = 'حدث خطأ غير معروف';
  static final String ERROR_TITLE = 'حدث خطأ';
  static final String ENTER_RIGHT_EMAIL = 'برجاء إدخال بريد صحيح';
  static final String PASSWORD_DONT_MATCH = 'الرقم السري غير متطابق';

  // Form strings
  static final String FORM_EMAIL = 'البريد الإلكتروني';
  static final String FORM_PASSWORD = 'الرقم السري';
  static final String RE_ENTER_PASSWORD = 'أعد ادخال الرقم السري';
  static final String LOGIN = 'تسجيل الدخول';
  static final String SIGNUP = 'تسجيل الحساب';
  static final String DONT_HAVE_ACCOUT = 'ليس لديك حساب؟ قم بالتسجيل الآن';
  static final String HAVE_ACCOUNT = 'لديك حساب بالفعل؟ قم بالدخول الآن';

  // Authentication strings
  static final String EMAIL = 'email';
  static final String PASSWORD = 'password';
  static final String USER_ID = 'userId';
  static final String USER_EMAIL = 'userEmail';
  static final String OPERATION_SUCCESS = 'success';

  // Assets
  static final String LOGO_ASSET = 'assets/logo.svg';
  static final String HOME_ASSET = 'assets/home.svg';
  static final String SEARCH_ASSET = 'assets/search.svg';
  static final String BOOK_ASSET = 'assets/book.svg';
  static final String MORE_ASSET = 'assets/more.svg';
  static final String PLACE_HOLDER = 'assets/place_holder.png';
  static final String READ_ASSET = 'assets/read.svg';

  // Pages
  static final String MAIN_PAGE = '/main';
  static final String AUTH_PAGE = '/auth';

  // Static functions
  static void SHARE_BOOK(String title, String description) {
    Share.share(
        'اقرأ واستمع الى كتاب ${title} من خلال تطبيق نوت بوك الآن\n${description}');
  }

  static String BOOK_PAGE(String bookId) {
    return '/$BOOKS/$bookId';
  }

  static String PDF_PAGE(String bookId) {
    return '/PDF/$bookId';
  }
}
