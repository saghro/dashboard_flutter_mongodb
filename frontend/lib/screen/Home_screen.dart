import 'package:flutter/material.dart';
import 'package:frontend/widgets/dashboard/Home/Home_Layout_Desktop.dart';
import 'package:frontend/widgets/dashboard/Home/Home_Layout_Mobile.dart';
import 'package:frontend/widgets/responsive_layout.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileWidget:  HomeLayoutMobile(),
          desktopWidget:  HomeLayoutDesktop()
      ),
    );
  }
}