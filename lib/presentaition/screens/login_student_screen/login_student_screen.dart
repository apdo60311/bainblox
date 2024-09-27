import 'package:BrainBlox/presistance/bloc/auth/auth_cubit.dart';
import 'package:BrainBlox/core/widgets/custom_text_form_field.dart';
import 'package:BrainBlox/presentaition/screens/home_screen/home_screen.dart';
import 'package:BrainBlox/presentaition/screens/register_screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginStudentScreen extends StatefulWidget {
  static const String routeName = "login_student";

  const LoginStudentScreen({super.key});

  @override
  State<LoginStudentScreen> createState() => _LoginStudentScreenState();
}

class _LoginStudentScreenState extends State<LoginStudentScreen> {
  TextEditingController emailController = TextEditingController();

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
          "Student Login",
          style: theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is UserAuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("email or password is wrong"),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is UserAuthSuccess) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              HomeScreen.routeName,
              (Route<dynamic> route) => false,
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.asset("assets/images/student-login.png"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Not a member yet?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w300),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RegisterScreen.routeName);
                            },
                            child: const Text(
                              "Sign up!",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontSize: 16,
                                  color: Colors.green),
                            ))
                      ],
                    ),
                    CustomTextFormField(
                      controller: emailController,
                      title: "UserName",
                      labelText: "UserName",
                      prefixIcon:
                          const Icon(Icons.supervised_user_circle_rounded),
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
                        icon:
                            Icon(sec ? Icons.visibility : Icons.visibility_off),
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
                      height: 30,
                    ),
                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: (state is UserAuthLoading)
                              ? null
                              : () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthCubit>().signIn(
                                        emailController.text,
                                        passwordController.text);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Login"),
                              (state is UserAuthLoading)
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 1,
                                      ),
                                    )
                                  : const Icon(Icons.arrow_forward)
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
