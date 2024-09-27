class LectureModel {
  final String title;
  final String fileUrl;
  final int duration;
  final String time;
  final Map<String, dynamic> attendance;
  final String assignmentFileUrl;

  LectureModel({
    required this.title,
    required this.fileUrl,
    required this.duration,
    required this.time,
    required this.attendance,
    required this.assignmentFileUrl,
  });

  factory LectureModel.fromJson(Map<String, dynamic> data) {
    return LectureModel(
      title: data['title'] ?? '',
      fileUrl: data['fileUrl'] ?? '',
      duration: data['duration'] ?? 0,
      time: data['time'] ?? '',
      attendance: data['attendance'] ?? {},
      assignmentFileUrl: data['assignmentFileUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'fileUrl': fileUrl,
      'duration': duration,
      'time': time,
      'attendance': attendance,
      'assignmentFileUrl': assignmentFileUrl,
    };
  }

  void markAttendance(String studentId, bool mark) {
    if (!attendance.containsKey(studentId)) {
      attendance[studentId] = mark;
    }
  }
}
