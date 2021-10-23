import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:valuhworld/OnlyGlobalPages/purchase_api.dart';
import 'package:valuhworld/OnlyWidgets/paywall_widget.dart';

class MakePaymentPage extends StatefulWidget {
  final String userId;
  MakePaymentPage({this.userId});

  @override
  _MakePaymentPageState createState() => _MakePaymentPageState(userId: userId);
}

class _MakePaymentPageState extends State<MakePaymentPage> {
  String userId;
  _MakePaymentPageState({this.userId});

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff3aa792),
        title: Text(
          'Upgrade',
          style: GoogleFonts.quicksand(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 80,
              ),
              Icon(
                FontAwesomeIcons.usersSlash,
                size: 36,
                color: Colors.grey[400],
              ),
              SizedBox(
                height: 32,
              ),
              Text(
                'Your are on a free plan',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                'With a free plan you can only have one person in your circle. '
                'Click the button below to upgrade and add unlimited number of people to your circle',
                style: GoogleFonts.quicksand(
                  textStyle: TextStyle(
                    fontSize: 16.0,
                    letterSpacing: .5,
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    color: Color(0xff3aa792),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      side: BorderSide(
                        color: Color(0xff3aa792),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        'Subscribe NOW',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: .5,
                          ),
                        ),
                      ),
                    ),
                    onPressed: () {
                      isLoading ? null : fetchOffers();
                    },
                  ),
                  // const SizedBox(width: 8),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffers();
    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No plans found'),
        ),
      );
    } else {
      // final offer = offerings.first;
      // print('offer: $offer');

      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showCupertinoModalBottomSheet(
        context: context,
        builder: (context) => PaywallWidget(
          packages: packages,
          title: 'Upgrade your plan',
          description: 'Get your new plan to enjoy more benefits',
          onClickedPackage: (package) async {
            await PurchaseApi.purchasePackage(package);
            Navigator.pop(context);
          },
        ),
      );
    }
  }
}
