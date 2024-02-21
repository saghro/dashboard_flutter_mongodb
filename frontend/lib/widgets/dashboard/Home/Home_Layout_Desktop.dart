import 'package:flutter/material.dart';

class HomeLayoutDesktop extends StatelessWidget {
  const HomeLayoutDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCard(
            'Number of Students', '20',
            Icons.people, screenWidth/3,
            screenHeight/4, 50, 20.0, 16.0,
          ), // width: 200, height: 150
          _buildCard(
            'Number of Courses',
            '10', Icons.book,
            screenWidth/3, screenHeight/4,
            50, 20.0, 16.0,
          ), // width: 200, height: 150
          // Add more cards if needed for additional information
        ],

      )
    );
  }

  Widget _buildCard(
      String title,
      String subtitle,
      IconData iconData,
      double width,
      double height,
      double iconSize,
      double titleFontSize,
      double subtitleFontSize) {
    return Container(
      width: width,
      height: height,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.lightBlueAccent,
        child: ListTile(
          leading: Icon(
            iconData,
            size: iconSize,
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: titleFontSize),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: subtitleFontSize),
          ),
        ),
      ),
    );
  }
}
