import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:BrainBlox/bloc/auth/auth_cubit.dart';
import 'package:BrainBlox/bloc/courses_bloc/course_cubit.dart';
import 'package:BrainBlox/bloc/lecture_cubit/lecture_cubit.dart';
import 'package:BrainBlox/core/theme/theme_app.dart';
import 'package:BrainBlox/firebase_options.dart';
import 'package:BrainBlox/model/course_model.dart';
import 'package:BrainBlox/model/lecture_model.dart';
import 'package:BrainBlox/modules/arabic/arabic_screen.dart';
import 'package:BrainBlox/modules/chemistry/chemistry_screen.dart';
import 'package:BrainBlox/modules/course_screen/course_screen.dart';
import 'package:BrainBlox/modules/english/english_screen.dart';
import 'package:BrainBlox/modules/geography/geography_screen.dart';
import 'package:BrainBlox/modules/history/history_screen.dart';
import 'package:BrainBlox/modules/home_screen/home_screen.dart';
import 'package:BrainBlox/modules/login_student_screen/login_student_screen.dart';
import 'package:BrainBlox/modules/math/math_screen.dart';
import 'package:BrainBlox/modules/physics/physics_screen.dart';
import 'package:BrainBlox/modules/register_screen/register_screen.dart';
import 'package:BrainBlox/modules/settings/setting_screen.dart';
import 'package:BrainBlox/modules/teacher_or_student/teacher_or_student_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'modules/login_teacher_screen/login_teacher_screen.dart';

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
          initialRoute: (state is UserAuthSuccess)
              ? HomeScreen.routeName
              : TeacherOrStudentScreen.routeName,
          theme: ApplicationTheme.lightMode,
          themeMode: ThemeMode.light,
          routes: {
            TeacherOrStudentScreen.routeName: (context) =>
                TeacherOrStudentScreen(),
            LoginStudentScreen.routeName: (context) =>
                const LoginStudentScreen(),
            LoginTeacherScreen.routeName: (context) =>
                const LoginTeacherScreen(),
            RegisterScreen.routeName: (context) => const RegisterScreen(),
            HomeScreen.routeName: (context) => BlocProvider(
                  create: (context) => CourseCubit()..fetchCourses(),
                  child: const HomeScreen(),
                ),
            SettingsScreen.routeName: (context) => const SettingsScreen(),
            CourseScreen.routeName: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => CourseCubit(),
                    ),
                    BlocProvider(
                      create: (context) => LectureCubit(),
                    ),
                  ],
                  child: CourseScreen(),
                ),
            MathScreen.routeName: (context) => MathScreen(),
            ChemistryScreen.routeName: (context) => ChemistryScreen(),
            HistoryScreen.routeName: (context) => HistoryScreen(),
            EnglishScreen.routeName: (context) => EnglishScreen(),
            ArabicScreen.routeName: (context) => ArabicScreen(),
            PhysicsScreen.routeName: (context) => PhysicsScreen(),
            GeographyScreen.routeName: (context) => GeographyScreen(),
          },
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
