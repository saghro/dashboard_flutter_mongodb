import 'package:flutter/material.dart';
import 'package:frontend/widgets/dashboard/students/Student_Layout_Desktop.dart';
import 'package:frontend/widgets/dashboard/students/Student_Layout_Mobile.dart';
import 'package:frontend/widgets/responsive_layout.dart';



class StudentScreen extends StatelessWidget {
  const StudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveLayout(
          mobileWidget:  StudentLayoutMobile(),
          desktopWidget:  StudentLayoutDesktop()
      ),
    );
  }
}