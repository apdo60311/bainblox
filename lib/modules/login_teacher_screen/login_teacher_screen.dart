import 'package:flutter/material.dart';

import '../../core/widgets/custom_text_form_field.dart';

class LoginTeacherScreen extends StatefulWidget {
  static const String routeName = "login_teacher";

  const LoginTeacherScreen({super.key});

  @override
  State<LoginTeacherScreen> createState() => _LoginTeacherScreenState();
}

class _LoginTeacherScreenState extends State<LoginTeacherScreen> {
  TextEditingController userNameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool sec = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 40,
        elevation: 0,
        title: Text(
          "Teacher Login",
          style: theme.textTheme.titleLarge,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/images/teacher-login.png"),
                const SizedBox(
                  height: 6,
                ),
                CustomTextFormField(
                  controller: userNameController,
                  title: "UserName",
                  labelText: "UserName",
                  prefixIcon: const Icon(Icons.supervised_user_circle_rounded),
                  valdiator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "you must enter your UserName";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  controller: passwordController,
                  title: "Password",
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  sec: sec,
                  suffixIcon: IconButton(
                    icon: Icon(sec ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        sec = !sec;
                      });
                    },
                  ),
                  valdiator: (String? value) {
                    if (value == null || value.trim().isEmpty) {
                      return "you must enter your Password";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  width: 90,
                  height: 60,
                  child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          //Login
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text("Login"), Icon(Icons.arrow_forward)],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
