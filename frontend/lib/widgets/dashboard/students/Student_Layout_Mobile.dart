import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentLayoutMobile extends StatefulWidget {
  const StudentLayoutMobile({Key? key}) : super(key: key);

  @override
  _StudentLayoutMobileState createState() => _StudentLayoutMobileState();
}

class _StudentLayoutMobileState extends State<StudentLayoutMobile> {
  List<Map<String, dynamic>> _students = [];
  List<String> _selectedStudents = [];
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/students'));

    if (response.statusCode == 200) {
      setState(() {
        _students = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to fetch students: ${response.statusCode}');
    }
  }

  Future<void> _addStudent(String name, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/students'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final newStudent = json.decode(response.body);
        setState(() {
          _students.add(newStudent);
        });
      } else {
        print('Failed to add student: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> _deleteSelectedStudents() async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/students'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'ids': _selectedStudents,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _selectedStudents.clear();
        });
        await _fetchStudents();
      } else {
        print('Failed to delete selected students: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting selected students: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    List<Map<String, dynamic>> filteredStudents = _students.where((student) {
      final studentName = student['name'].toString().toLowerCase();
      return studentName.contains(_searchTerm.toLowerCase());
    }).toList();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un étudiant...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                  ),
                ),
              ),
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddStudentDialog(
                          onAddStudent: _addStudent,
                        );
                      },
                    );
                  },
                  child: const Text('Ajouter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
                ElevatedButton(
                  onPressed: _deleteSelectedStudents,
                  child: const Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: screenWidth / 10, child: Center(child: Text('ID'))),
                          SizedBox(width: screenWidth / 10, child: Center(child: Text('Nom'))),
                          SizedBox(width: screenWidth / 10, child: Center(child: Text('Email'))),
                          SizedBox(width: screenWidth / 9, child: Center(child: Text('Select'))),
                        ],
                      ),
                    );
                  } else {
                    final student = filteredStudents[index - 1];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth / 20,
                            child: Center(child: Text(student['id'].toString())),
                          ),
                          SizedBox(
                            width: screenWidth / 10,
                            child: Center(child: Text(student['name'].toString())),
                          ),
                          SizedBox(
                            width: screenWidth / 10,
                            child: Center(child: Text(student['email'].toString())),
                          ),
                          SizedBox(
                            width: screenWidth / 20,
                            child: Checkbox(
                              value: _selectedStudents.contains(student['_id']),
                              onChanged: (value) {
                                setState(() {
                                  if (value != null && value) {
                                    _selectedStudents.add(student['_id']);
                                  } else {
                                    _selectedStudents.remove(student['_id']);
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddStudentDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final Function(String, String) onAddStudent;

  AddStudentDialog({required this.onAddStudent});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ajouter un étudiant'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de l\'étudiant',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email de l\'étudiant',
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Ajouter'),
          onPressed: () async {
            final name = nameController.text;
            final email = emailController.text;
            await onAddStudent(name, email);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
