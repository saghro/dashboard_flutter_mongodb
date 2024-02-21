import 'package:flutter/material.dart';
import 'package:frontend/widgets/sidebar/sidebar_layout_desktop.dart';
import 'package:frontend/widgets/sidebar/sidebar_layout_mobile.dart';
import 'package:frontend/widgets/responsive_layout.dart';

class SideBarScreen extends StatelessWidget {
  const SideBarScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileWidget:  SideBarLayoutMobile(),
        desktopWidget:  SideBarLayoutWeb(),
      ),
    );
  }
}