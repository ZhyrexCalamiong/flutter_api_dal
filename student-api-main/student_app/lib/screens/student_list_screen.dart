import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/student.dart';
import 'add_student_screen.dart';
import '../widgets/student_card.dart';

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/students'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        setState(() {
          students = jsonList.map((json) => Student.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load students');
      }
    } catch (e) {
      print('Error fetching students: $e');
    }
  }

  Future<void> _addStudent(Student student) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/students'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(student.toJson()),
      );

      if (response.statusCode == 201) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to add student');
      }
    } catch (e) {
      print('Error adding student: $e');
    }
  }

  Future<void> _editStudent(int id, Student updatedStudent) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3000/api/students/$id'), // Use the student ID for the URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode(updatedStudent.toJson()),
      );

      if (response.statusCode == 200) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to update student');
      }
    } catch (e) {
      print('Error editing student: $e');
    }
  }

  Future<void> _deleteStudent(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('http://localhost:3000/api/students/$id')); // Use the student ID for the URL

      if (response.statusCode == 200) {
        _fetchStudents(); // Refresh the list
      } else {
        throw Exception('Failed to delete student');
      }
    } catch (e) {
      print('Error deleting student: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        centerTitle: true,
      ),
      body: students.isEmpty
          ? Center(child: Text('No students added yet.'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return StudentCard(
                  student: students[index],
                  onEdit: () async {
                    final updatedStudent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddStudentScreen(
                          existingStudent: students[index], // Pass existing student for editing
                        ),
                      ),
                    );

                    if (updatedStudent != null) {
                      _editStudent(students[index].id, updatedStudent); // Update student using ID
                    }
                  },
                  onDelete: () => _deleteStudent(students[index].id), // Delete student using ID
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newStudent = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStudentScreen()),
          );

          if (newStudent != null) {
            _addStudent(newStudent); // Add new student
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add Student',
      ),
    );
  }
}
