import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallWidget extends StatefulWidget {
  final String title;
  final String description;
  final List<Package> packages;
  final ValueChanged<Package> onClickedPackage;

  const PaywallWidget({
    Key key,
    this.title,
    this.description,
    this.packages,
    this.onClickedPackage,
  }) : super(key: key);

  @override
  _PaywallWidgetState createState() => _PaywallWidgetState();
}

class _PaywallWidgetState extends State<PaywallWidget> {
  @override
  Widget build(BuildContext context) => Material(
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Text(
                  widget.title,
                  style: GoogleFonts.quicksand(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.quicksand(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                buildPackages(),
              ],
            ),
          ),
        ),
      );

  Widget buildPackages() => ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: widget.packages.length,
        itemBuilder: (context, index) {
          final package = widget.packages[index];
          return buildPackage(context, package);
        },
      );

  Widget buildPackage(BuildContext context, Package package) {
    final product = package.product;

    return Card(
      color: Colors.blueGrey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: ThemeData.light(),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Text(
            product.title,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            product.description,
            style: GoogleFonts.quicksand(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          trailing: Text(
            product.priceString,
            style: GoogleFonts.quicksand(
              fontSize: 16,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () => widget.onClickedPackage(package),
        ),
      ),
    );
  }
}
