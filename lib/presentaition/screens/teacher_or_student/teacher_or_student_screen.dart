import 'package:BrainBlox/core/routes/routes.dart';
import 'package:BrainBlox/presentaition/screens/login_student_screen/login_student_screen.dart';
import 'package:flutter/material.dart';

class TeacherOrStudentScreen extends StatelessWidget {
  bool isTeacher = false;
  bool isStudent = false;

  TeacherOrStudentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "WHO YOU ARE?",
            style: theme.textTheme.titleLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.loginTeacher);
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage("assets/images/teacher_icon.png"),
                      // Replace with your child image path
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    "Teacher",
                    style: theme.textTheme.titleMedium,
                  )
                ],
              ),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, Routes.loginStudent);
                    },
                    child: const CircleAvatar(
                      radius: 50,
                      backgroundImage:
                          AssetImage("assets/images/student_icon.png"),
                      // Replace with your child image path
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  Text(
                    "Student",
                    style: theme.textTheme.titleMedium,
                  )
                ],
              )
            ],
          ),
// ElevatedButton(onPressed: (){
//   if(isStudent){
//     Navigator.pushNamed(context, LoginStudentScreen.routeName);
//   }
//   else{
//     Navigator.pushNamed(context, LoginTeacherScreen.routeName);
//   }
// },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.amber,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(30)
//       )
//     ),
//     child: Row(children: [Text("Go"),Icon(Icons.arrow_forward_sharp)],))
        ],
      ),
    );
  }
}
