import 'package:brain_blox/core/routes/routes.dart';
import 'package:brain_blox/presentaition/screens/course_screen/course_screen.dart';
import 'package:brain_blox/presentaition/screens/home_screen/home_screen.dart';
import 'package:brain_blox/presentaition/screens/login_student_screen/login_student_screen.dart';
import 'package:brain_blox/presentaition/screens/login_teacher_screen/login_teacher_screen.dart';
import 'package:brain_blox/presentaition/screens/register_screen/register_screen.dart';
import 'package:brain_blox/presentaition/screens/splash_screen/splash_screen.dart';
import 'package:brain_blox/presentaition/screens/teacher_or_student/teacher_or_student_screen.dart';
import 'package:brain_blox/presistance/bloc/auth/auth_cubit.dart';
import 'package:brain_blox/presistance/bloc/courses_bloc/course_cubit.dart';
import 'package:brain_blox/presistance/bloc/lecture_cubit/lecture_cubit.dart';
import 'package:brain_blox/presistance/model/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RouteGenerator {
  static Route<dynamic> generate(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (context) => SplashScreen(
                  nextScreen:
                      (context.read<AuthCubit>().state is UserAuthSuccess)
                          ? Routes.home
                          : Routes.teacherOrStudent,
                ));
      case Routes.teacherOrStudent:
        return MaterialPageRoute(
            builder: (context) => TeacherOrStudentScreen());
      case Routes.loginStudent:
        return MaterialPageRoute(
            builder: (context) => const LoginStudentScreen());
      case Routes.loginTeacher:
        return MaterialPageRoute(
            builder: (context) => const LoginTeacherScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case Routes.course:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => CourseCubit(),
              ),
              BlocProvider(
                create: (context) => LectureCubit(),
              ),
            ],
            child: CourseScreen(
              courseModel: CourseModel.fromJson(
                  (settings.arguments as Map<String, dynamic>)['courseData']),
            ),
          ),
        );
      case Routes.home:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => CourseCubit()..fetchCourses(),
                  child: const HomeScreen(),
                ));

      default:
        return _getErrorRoute();
    }
  }

  static Route<dynamic> _getErrorRoute() {
    return MaterialPageRoute(builder: (context) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Colors.red[700],
                ),
                const SizedBox(height: 20),
                Text(
                  'Oops! Something went wrong',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'We apologize for the inconvenience',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
