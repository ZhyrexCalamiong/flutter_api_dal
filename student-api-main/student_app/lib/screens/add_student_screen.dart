import 'package:flutter/material.dart';
import '../models/student.dart';

class AddStudentScreen extends StatefulWidget {
  final Student? existingStudent; // Optional parameter for existing student

  AddStudentScreen({this.existingStudent});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  String course = 'bsit'; // Set a default course value that exists in the items
  String year = 'First Year'; // Set a default year value that exists in the items
  bool enrolled = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingStudent != null) {
      // Populate fields if editing
      firstName = widget.existingStudent!.firstName;
      lastName = widget.existingStudent!.lastName;
      course = widget.existingStudent!.course;
      year = widget.existingStudent!.year;
      enrolled = widget.existingStudent!.enrolled;
    } else {
      // Default values if adding new student
      firstName = '';
      lastName = '';
      enrolled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.existingStudent == null ? 'Add Student' : 'Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    firstName = value;
                  });
                },
                initialValue: firstName, // Set initial value for editing
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    lastName = value;
                  });
                },
                initialValue: lastName, // Set initial value for editing
              ),
              DropdownButtonFormField<String>(
                value: course,
                decoration: InputDecoration(labelText: 'Course'),
                items: <String>[
                  'bsit',
                  'educ',
                  'crim',
                  'engr',
                  'nursing',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    course = value!;
                  });
                },
                // Ensure there are no duplicates
                validator: (value) {
                  if (value == null) {
                    return 'Please select a course';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: year,
                decoration: InputDecoration(labelText: 'Year'),
                items: <String>[
                  'First Year',
                  'Second Year',
                  'Third Year',
                  'Fourth Year',
                  'Fifth Year',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    year = value!;
                  });
                },
                // Ensure there are no duplicates
                validator: (value) {
                  if (value == null) {
                    return 'Please select a year';
                  }
                  return null;
                },
              ),
              SwitchListTile(
                title: Text('Enrolled'),
                value: enrolled,
                onChanged: (value) {
                  setState(() {
                    enrolled = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Create or update the Student object and pass it back
                    final newStudent = Student(
                      id: widget.existingStudent?.id ?? 0, // Pass the existing ID or 0 for new
                      firstName: firstName,
                      lastName: lastName,
                      course: course,
                      year: year, // Include year
                      enrolled: enrolled,
                    );
                    Navigator.pop(context, newStudent); // Return the new or updated student
                  }
                },
                child: Text(widget.existingStudent == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
