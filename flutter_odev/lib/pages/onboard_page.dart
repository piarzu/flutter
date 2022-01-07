import 'package:flutter/material.dart';
import 'package:flutter_odev/pages/login_page.dart';
import 'package:flutter_svg/svg.dart';

import 'package:hive/hive.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_page.dart';

class OnBoardingPage extends StatefulWidget {

  const OnBoardingPage({Key? key}) : super(key: key);
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();


  void _onIntroEnd(context) {
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginPage()), (route) => false);
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: SvgPicture.asset('images/$assetName.svg', width: 350.0,height: 250,),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      descriptionPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          title: "Ürün Ara",
          body:"İstediğiniz ürünü ister barkod ile ister adı ile arayın",
          image: _buildImage('search'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Hızlı Kayıt",
          body: "Kolay ve hızlıca kayıt olun, istediğiniz ürünü aramaya başlayın",
          image: _buildImage('register'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Her An Takipte Olun",
          body:"Takip ettiğiniz ürünün fiyatında bir düşüş olursa hemen bilgi alın",
          image: _buildImage('notification'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Ürün Ara",
          body: "Kullanıcı dostu arayüzü ile yüzlerce ürün hizmetinde\n\nHadi Hemen Başla",
          image: _buildImage('app'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton:true,
      skipFlex: 0,
      nextFlex: 0,
      skip:  Text("Tanıtımı Atla"),
      next:  Icon(Icons.arrow_forward),
      done:  Text("BAŞLAYIN", style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}