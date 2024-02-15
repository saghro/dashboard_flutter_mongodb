import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Card( // Made Card const
              child: ListTile(
                title: Text('Number of Students'),
                subtitle: Text('20'), // Changed to a constant value
              ),
            ),
             Card( // Made Card const
              child: ListTile(
                title: Text('Number of Courses'),
                subtitle: Text('10'), // Changed to a constant value
              ),
            ),
            // Add more cards if needed for additional information
          ],
        ),
      ),
    );
  }
}
