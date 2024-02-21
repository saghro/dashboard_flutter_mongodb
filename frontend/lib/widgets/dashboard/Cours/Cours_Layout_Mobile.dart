import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoursLayoutMobile extends StatefulWidget {
  const CoursLayoutMobile({Key? key}) : super(key: key);

  @override
  _CoursLayoutMobileState createState() => _CoursLayoutMobileState();
}

class _CoursLayoutMobileState extends State<CoursLayoutMobile> {
  List<Map<String, dynamic>> _courses = [];
  String _searchTerm = '';
  int _currentPage = 1;
  int _coursesPerPage = 6;


  @override
  void initState() {
    super.initState();
    _fetchCourses();
  }

  Future<void> _fetchCourses() async {
    final response =
    await http.get(Uri.parse('http://localhost:8080/api/courses'));

    if (response.statusCode == 200) {
      setState(() {
        _courses = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print('Failed to fetch courses: ${response.statusCode}');
    }
  }

  List<Map<String, dynamic>> _getCurrentPageCourses() {
    final int startIndex = (_currentPage - 1) * _coursesPerPage;
    final int endIndex = startIndex + _coursesPerPage;
    if (endIndex <= _courses.length) {
      return _courses.sublist(startIndex, endIndex);
    } else {
      return _courses.sublist(startIndex);
    }
  }


  Future<void> _addCourse(String name, String description) async {
    try {
      if (_isCourseDuplicate(name)) {
        print('Ce cours existe déjà.');
        return;
      }
      final response = await http.post(
        Uri.parse('http://localhost:8080/api/courses'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final newCourse = json.decode(response.body);
        setState(() {
          _courses.add(newCourse);
        });
        Navigator.of(context).pop();
      } else {
        print('Failed to add course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error adding course: $e');
    }
  }

  bool _isCourseDuplicate(String name) {
    final String lowerCaseName = name.toLowerCase();

    for (final course in _courses) {
      final String existingName = course['name'].toString().toLowerCase();
      if (existingName == lowerCaseName) {
        return true;
      }
    }
    return false;
  }

  Future<void> _deleteCourse(String id) async {
    try {
      final response =
      await http.delete(Uri.parse('http://localhost:8080/api/courses/$id'));

      if (response.statusCode == 200) {
        setState(() {
          _courses.removeWhere((course) => course['id'] == id);
        });

        await _fetchCourses();
      } else {
        print('Failed to delete course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error deleting course: $e');
    }
  }

  Future<void> _updateCourse(String courseId, String name,
      String description) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:8080/api/courses/$courseId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': name,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        final updatedCourse = json.decode(response.body);
        setState(() {
          int index = _courses.indexWhere((course) => course['id'] == courseId);
          if (index != -1) {
            _courses[index] = updatedCourse;
          }
        });

        await _fetchCourses();
      } else {
        print('Failed to update course: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Déclaration de filteredCourses ici
    List<Map<String, dynamic>> filteredCourses = _courses.where((course) {
      final courseName = course['name'].toString().toLowerCase();
      return courseName.contains(_searchTerm.toLowerCase());
    }).toList();

    List<Map<String, dynamic>> _getCurrentPageCourses() {
      // Calcul de l'index de début et de fin pour la pagination
      final int startIndex = (_currentPage - 1) * _coursesPerPage;
      final int endIndex = startIndex + _coursesPerPage;

      // Renvoi des cours de la page actuelle
      if (endIndex <= filteredCourses.length) {
        return filteredCourses.sublist(startIndex, endIndex);
      } else {
        return filteredCourses.sublist(startIndex);
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un cours...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.grey, // Couleur de la bordure
                    width: 1.0, // Épaisseur de la bordure
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AddCourseDialog(
                      onAddCourse: _addCourse,
                    );
                  },
                );
              },
              child: const Text('Ajouter un cours'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _getCurrentPageCourses().length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(width: 50, child: Center(child: Text('ID'))),
                          SizedBox(width: 150,
                              child: Center(child: Text('Nom'))),
                          Expanded(child: Center(child: Text('Description'))),
                          SizedBox(width: 100,
                              child: Center(child: Text('Actions'))),
                        ],
                      ),
                    );
                  } else if (index == _getCurrentPageCourses().length + 1) {
                    // Affichage des boutons de pagination
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              if (_currentPage > 1) {
                                _currentPage--;
                              }
                            });
                          },
                        ),
                        Text('Page $_currentPage'),
                        IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              if ((_currentPage * _coursesPerPage) <
                                  filteredCourses.length) {
                                _currentPage++;
                              }
                            });
                          },
                        ),
                      ],
                    );
                  } else {
                    final course = _getCurrentPageCourses()[index - 1];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 50,
                            child: Center(child: Text(course['id'].toString())),
                          ),
                          SizedBox(
                            width: 150,
                            child: Center(
                                child: Text(course['name'].toString())),
                          ),
                          Expanded(
                            child: Text(course['description'].toString()),
                          ),
                          SizedBox(
                            width: 100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.update),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return UpdateCourseDialog(
                                          courseId: course['_id'].toString(),
                                          courseName: course['name'],
                                          courseDescription: course['description'],
                                          onUpdateCourse: _updateCourse,
                                        );
                                      },
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                              'Confirmation de suppression'),
                                          content: Text(
                                            'Êtes-vous sûr de vouloir supprimer ce cours ?',
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text('Annuler'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text('Supprimer'),
                                              onPressed: () {
                                                _deleteCourse(course['_id']);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            )

          ],
        ),
      ),
    );
  }
}

  class AddCourseDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final Function(String, String) onAddCourse;

  AddCourseDialog({required this.onAddCourse});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un cours'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration:const InputDecoration(
                labelText: 'Nom du cours',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description du cours',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
          child: const Text('Ajouter'),
          onPressed: () {
            final name = nameController.text;
            final description = descriptionController.text;
            onAddCourse(name, description);
          },
        ),
      ],
    );
  }
}

class UpdateCourseDialog extends StatelessWidget {
  final String courseId;
  final String courseName;
  final String courseDescription;
  final Function(String, String, String) onUpdateCourse;

  UpdateCourseDialog({
    super.key,
    required this.courseId,
    required this.courseName,
    required this.courseDescription,
    required this.onUpdateCourse,
  });

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    nameController.text = courseName;
    descriptionController.text = courseDescription;

    return AlertDialog(
      title: const Text('Mettre à jour le cours'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nom du cours',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description du cours',
              ),
              keyboardType: TextInputType.multiline,
              maxLines: null,
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
          child: const Text('Mettre à jour'),
          onPressed: () async {
            final name = nameController.text;
            final description = descriptionController.text;

            await onUpdateCourse(courseId, name, description);

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
