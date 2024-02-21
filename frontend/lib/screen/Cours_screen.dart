import 'package:flutter/material.dart';
import 'package:frontend/widgets/dashboard/Cours/Cours_Layout_Desktop.dart';
import 'package:frontend/widgets/dashboard/Cours/Cours_Layout_Mobile.dart';
import 'package:frontend/widgets/responsive_layout.dart';



class CoursScreen extends StatelessWidget {
  const CoursScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileWidget:  CoursLayoutMobile(),
          desktopWidget:  CoursLayoutDesktop()
      ),
    );
  }
}