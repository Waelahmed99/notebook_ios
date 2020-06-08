import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notebook_provider/models/enums.dart';
import 'package:notebook_provider/pages/books_list.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _buildBackgroundImage(context),
            SizedBox(height: 30),
            MenuButton(
              assetName: 'assets/heart.svg',
              title: 'مفضلتي',
              onTap: () => _myFavoriteCallback(context),
            ),
            SizedBox(height: 30),
            MenuButton(
              assetName: 'assets/chat.svg',
              title: 'تواصل معنا',
              onTap: _contactUsCallback,
            ),
            SizedBox(height: 30),
            MenuButton(
              assetName: 'assets/terms.svg',
              title: 'الشروط والأحكام',
              onTap: () => _termsAndConditionsCallback(context),
            ),
            SizedBox(height: 30),
            MenuButton(
              assetName: 'assets/star.svg',
              title: 'قيم التطبيق',
              onTap: _rateApplicationCallback,
            ),
            SizedBox(height: 30),
            MenuButton(
              assetName: 'assets/share.svg',
              title: 'شارك التطبيق',
              onTap: _shareApplicationCallback,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return SafeArea(
      child: SvgPicture.asset(
        'assets/profile_background.svg',
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  void _myFavoriteCallback(BuildContext context) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BooksListPage(mode: ListMode.Liked)));
  }

  void _contactUsCallback() async {
    String email = 'waelahmed6599@gmail.com';
    String subject = 'عن تطبيق نوت بوك';
    // String body = '';
    var url = 'mailto:$email?subject=$subject';
    if (await canLaunch(url)) await launch(url);
  }

  void _termsAndConditionsCallback(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'الشروط والأحكام',
          textDirection: TextDirection.rtl,
        ),
        content: SingleChildScrollView(
          child: Text(
            '''
          هذالتطبيق تم تصميمه من قبل Emy Ahmed\n
           وتم العمل على تطوير التطبيق بصفة شخصية على يد مهندس البرمجيات وائل أحمد.\n
           مع العلم أن البيانات المسجلة في هذا التطبيق غير مدعومة من خلال مصدر ما، وهي مجرد بيانات مؤقته في التطبيق.\n
           المطورين غير مسئولين على ما يحتويه التطبيق من بيانات سواء كانت محتوى الكتب أو وصف الكتاب.\n
           هذا التطبيق مزود بإمكانية الوصول لمساحة التخزين الداخلية في الجهاز لكي يتمكن من تحميل ملفات الPDF الخاصة بالكتب.
           ''',
            textDirection: TextDirection.rtl,
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('تم'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _rateApplicationCallback() async {
    var url = 'https://play.google.com/store';
    if (await canLaunch(url)) await launch(url);
  }

  void _shareApplicationCallback() async {
    String title = 'قم بتحميل تطبيق نوت بوك الآن من خلال متجر جوجل بلاي';
    String content =
        'نوت بوك هو تطبيق يتيح لك إمكانية الإستماع الى الكتب المسموعة وكذلك قراءتها';
    String link = 'عذراً رابط التطبيق غير متوفر الآن';
    Share.share(title + '\n' + content + '\n' + link);
  }
}

class MenuButton extends StatelessWidget {
  final String assetName;
  final String title;
  final Function onTap;
  MenuButton({
    @required this.assetName,
    @required this.title,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(width: 50),
            SvgPicture.asset(assetName),
          ],
        ),
      ),
    );
  }
}
