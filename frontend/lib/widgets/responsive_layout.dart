import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileWidget;
  final Widget desktopWidget;

  const ResponsiveLayout({
    Key? key,
    required this.mobileWidget,
    required this.desktopWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < 600) {
        return mobileWidget;
      } else {
        return desktopWidget;
      }
    });
  }
}