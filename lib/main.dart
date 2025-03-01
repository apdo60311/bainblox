import 'dart:math';

import 'package:brain_blox/core/routes/generator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:brain_blox/presistance/bloc/auth/auth_cubit.dart';
import 'package:brain_blox/core/theme/theme_app.dart';
import 'package:brain_blox/firebase_options.dart';
import 'package:brain_blox/presistance/model/course_model.dart';
import 'package:brain_blox/presistance/model/lecture_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authCubit = AuthCubit();
  await authCubit.checkCurrentUser();

  runApp(BlocProvider(
    create: (context) => authCubit,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          theme: ApplicationTheme.lightMode,
          themeMode: ThemeMode.light,
          onGenerateRoute: RouteGenerator.generate,
        );
      },
    );
  }
}

Future<void> insertRandomCourses(int count) async {
  final firestore = FirebaseFirestore.instance;
  final random = Random();

  for (int i = 0; i < count; i++) {
    final courseId = 'course_${i + 1}';
    final course = CourseModel(
      id: courseId,
      title: 'Course Title ${i + 1}',
      description: 'Description for course ${i + 1}',
      imageUrl: 'https://example.com/image${i + 1}.jpg',
      instructor: 'Instructor ${random.nextInt(10)}',
      lectures: [], // Populate with LectureModel instances if needed
      students: [], // Populate with UserModel instances if needed
    );

    // Insert course into Firestore
    await firestore.collection('courses').doc(course.id).set(course.toJson());

    // Insert random lectures as a sub-collection
    final lectureCount = random.nextInt(5) + 1;
    for (int j = 0; j < lectureCount; j++) {
      final lecture = LectureModel(
          title: 'Lecture Title ${j + 1}',
          fileUrl: 'https://example.com/lecture${j + 1}.mp4',
          duration: random.nextInt(60) +
              1, // Random duration between 1 and 60 minutes
          attendance: {},
          assignmentFileUrl:
              'https://example.com/lecture${j + 1}.pdf', // Initialize attendance as empty
          time: '10:00 AM');

      await firestore
          .collection('courses')
          .doc(course.id)
          .collection('lectures')
          .doc('lecture_${j + 1}')
          .set(lecture.toJson());
    }
  }
}
