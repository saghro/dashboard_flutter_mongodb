import 'package:flutter/material.dart';
import 'package:frontend/widgets/responsive_layout.dart';
import 'package:frontend/widgets/signup/SignUp_layout_desktop.dart';
import 'package:frontend/widgets/signup/SignUp_layout_mobile.dart';


class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileWidget:  SignUpLayoutMobile(),
          desktopWidget:  SignUpLayoutDesktop()
      ),
    );
  }
}