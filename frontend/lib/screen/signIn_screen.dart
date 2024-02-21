import 'package:flutter/material.dart';
import 'package:frontend/widgets/signin/SignIn_layout_desktop.dart';
import 'package:frontend/widgets/signin/SignIn_layout_mobile.dart';
import 'package:frontend/widgets/responsive_layout.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
        mobileWidget:  SignInLayoutMobile(),
        desktopWidget:  SignInLayoutDesktop()
      ),
    );
  }
}