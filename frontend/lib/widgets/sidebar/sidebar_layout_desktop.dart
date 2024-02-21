import 'package:flutter/material.dart';
import 'package:frontend/screen/Cours_screen.dart';
import 'package:frontend/screen/Home_screen.dart';
import 'package:frontend/screen/StudentScreen.dart';
import 'package:frontend/widgets/dashboard/StudentPage.dart';
import 'package:frontend/screen/signIn_screen.dart';

class SideBarLayoutWeb extends StatefulWidget {
  const SideBarLayoutWeb({Key? key}) : super(key: key);

  @override
  State<SideBarLayoutWeb> createState() => _SideBarLayoutWebState();
}

class _SideBarLayoutWebState extends State<SideBarLayoutWeb> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    StudentScreen(),
    CoursScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          // Sidebar
          Container(
            width: 300, // Width of your sidebar
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xffE6E6E6),
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            color: Color(0xffCCCCCC),
                            size: 100,

                          ),

                        ),
                        Text("admin",textAlign: TextAlign.center,),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      _onItemTapped(0);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.school),
                    title: Text('Students'),
                    onTap: () {
                      _onItemTapped(1);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Courses'),
                    onTap: () {
                      _onItemTapped(2);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Main content
          Expanded(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
