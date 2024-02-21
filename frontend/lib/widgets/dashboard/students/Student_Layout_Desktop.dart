import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StudentLayoutDesktop extends StatefulWidget {
  const StudentLayoutDesktop({Key? key}) : super(key: key);

  @override
  _StudentLayoutDesktopState createState() => _StudentLayoutDesktopState();
}

class _StudentLayoutDesktopState extends State<StudentLayoutDesktop> {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
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
                          vertical: 10.0, horizontal: 10.0),
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
                ),
                SizedBox(width: 20),
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
                  child: const Text('Ajouter un étudiant'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _deleteSelectedStudents,
                  child: const Text('Supprimer les étudiants '),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // Change background color to red
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: screenWidth/1.3,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Nom')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Sélectionner')),
                  ],
                  rows: filteredStudents.map<DataRow>((student) {
                    return DataRow(
                      selected: _selectedStudents.contains(student['_id']),
                      onSelectChanged: (selected) {
                        setState(() {
                          if (selected != null && selected) {
                            _selectedStudents.add(student['_id']);
                          } else {
                            _selectedStudents.remove(student['_id']);
                          }
                        });
                      },
                      cells: [
                        DataCell(Text(student['id'].toString())),
                        DataCell(Text(student['name'].toString())),
                        DataCell(Text(student['email'].toString())),
                        DataCell(Checkbox(
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
                        )),
                      ],
                    );
                  }).toList(),
                ),
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
