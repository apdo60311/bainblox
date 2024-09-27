import 'package:BrainBlox/presentaition/screens/teacher_or_student/teacher_or_student_screen.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  static const String routeName = "seetings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, TeacherOrStudentScreen.routeName);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.logout,
                    size: 50,
                  ),
                  Text(
                    "Log out",
                    style: theme.textTheme.titleLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
