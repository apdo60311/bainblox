import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:BrainBlox/model/course_model.dart';
import 'package:BrainBlox/model/lecture_model.dart';
import 'package:flutter/material.dart';

part 'course_state.dart';

class CourseCubit extends Cubit<CourseState> {
  CourseCubit() : super(CoursesInitialState());

  Future<void> fetchCourses() async {
    emit(CoursesLoadingState());

    try {
      final coursesSnapshot =
          await FirebaseFirestore.instance.collection('courses').get();

      final List<CourseModel> courses = coursesSnapshot.docs.map((courseDoc) {
        return CourseModel.fromJson({
          'id': courseDoc.id,
          ...courseDoc.data(),
          'lectures': [],
          'students': [],
        });
      }).toList();

      emit(CoursesLoadedState(courses));
    } catch (e) {
      emit(CourseFailureState(e.toString()));
    }
  }

  Future<List<LectureModel>> fetchLectures(String courseId) async {
    emit(LecturesLoadingState());
    try {
      final lecturesSnapshot = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .collection('lectures')
          .get();

      final List<LectureModel> lectures =
          lecturesSnapshot.docs.map((lectureDoc) {
        return LectureModel.fromJson(lectureDoc.data());
      }).toList();

      emit(LecturesLoadedState(lectures));
      return lectures;
    } catch (e) {
      emit(CourseFailureState(e.toString()));
      print('ERROR: ${e.toString()}');
      return [];
    }
  }
}
