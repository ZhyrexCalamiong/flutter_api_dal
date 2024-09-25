class Student {
  final int id; // Add this line for the student ID
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    required this.id, // Include ID in constructor
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled ? 1 : 0,
    };
  }

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'], // Assign ID from JSON
      firstName: json['firstName'],
      lastName: json['lastName'],
      course: json['course'],
      year: json['year'],
      enrolled: json['enrolled'] == 1,
    );
  }
}
