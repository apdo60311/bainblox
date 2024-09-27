part of 'course_cubit.dart';

@immutable
abstract class CourseState {}

class CoursesInitialState extends CourseState {}

class CoursesLoadingState extends CourseState {}

class CoursesLoadedState extends CourseState {
  final List<CourseModel> courses;

  CoursesLoadedState(this.courses);
}

class LecturesLoadedState extends CourseState {
  final List<LectureModel> lectures;
  LecturesLoadedState(this.lectures);
}

class LecturesLoadingState extends CourseState {}

class CourseFailureState extends CourseState {
  final String error;

  CourseFailureState(this.error);
}
