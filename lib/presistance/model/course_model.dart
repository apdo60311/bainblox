import 'package:BrainBlox/presistance/model/lecture_model.dart';
import 'package:BrainBlox/presistance/model/user_model.dart';

class CourseModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String instructor;
  final List<LectureModel> lectures;
  final List<UserModel> students;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.instructor,
    required this.lectures,
    required this.students,
  });

  factory CourseModel.fromJson(Map<String, dynamic> data) {
    return CourseModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      instructor: data['instructor'] ?? '',
      lectures: (data['lectures'] as List<dynamic>?)
              ?.map((lectureData) => LectureModel.fromJson(lectureData))
              .toList() ??
          [],
      students: (data['students'] as List<dynamic>?)
              ?.map((studentData) => UserModel.fromJson(studentData))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'instructor': instructor,
      'lectures': lectures.map((lecture) => lecture.toJson()).toList(),
      'students': students.map((student) => student.toJson()).toList(),
    };
  }
}
