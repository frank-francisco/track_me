import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:valuhworld/OnlyGlobalPages/GettingStartedPage.dart';

class OnBoardingPage extends StatefulWidget {
  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (_) => GettingStartedScreen(),
      ),
    );
  }

  Widget _buildImage(String assetName) {
    return Align(
      child: Image.asset('assets/images/$assetName.png', width: 350.0),
      alignment: Alignment.bottomCenter,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0, letterSpacing: .5, height: 1.2);
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
          title: 'Panic Button',
          body:
              'Valuhworld gives you the ability to send for help by just a tap of the SOS button whenever you are in trouble or feel like you are in \ntrouble.',
          image: _buildImage('sos'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Hosts',
          body:
              "Get connected with immediate help from our list of hosts. In case you need immediate help, our hosts are one alert away.",
          image: _buildImage('booking'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'One chat',
          body:
              "Feel like you’ve got your closest people right beside all the time as you can send messages to family and friends whenever \nyou feel like.",
          image: _buildImage('texting'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: 'Keep record',
          body:
              "Take photos of your tour experiences and have memories to go back home with as suveniers of places you have been",
          image: _buildImage('selfie'),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Share the moments",
          body:
              "Share experiences on how you view the world with different people and different places that are different from home",
          image: _buildImage('sharing'),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
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
