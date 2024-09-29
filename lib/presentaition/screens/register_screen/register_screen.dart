import 'package:brain_blox/core/routes/routes.dart';
import 'package:brain_blox/presistance/bloc/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widgets/custom_text_form_field.dart';

class RegisterScreen extends StatefulWidget {
  @override
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  bool sec = true;

  var formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is UserAuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is UserAuthSuccess) {
          Navigator.of(context).pushReplacementNamed(Routes.home);
        }
      },
      builder: (context, state) {
        return Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/register_background.png"))),
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                toolbarHeight: 100,
                backgroundColor: Colors.transparent,
                title: Text(
                  "Create Account",
                  style: theme.textTheme.titleLarge,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Form(
                    key: formkey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: mediaQuery.height * 0.11,
                        ),
                        CustomTextFormField(
                          controller: nameController,
                          title: "FullName",
                          labelText: "Name",
                          valdiator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "you must enter your name";
                            }
                            return null;
                          }, //valdiator
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                          controller: emailController,
                          title: "UserName",
                          labelText: "UserName",
                          valdiator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "you must enter your UserName";
                            }
                            return null;
                          }, //valdiator
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                          controller: phoneController,
                          title: "Phone",
                          labelText: "PhoneNumber",
                          keytype: TextInputType.phone,
                        ),
                        CustomTextFormField(
                          controller: passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                                sec ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                sec = !sec;
                              });
                            },
                          ),
                          sec: sec,
                          title: "Password",
                          labelText: "Password",
                          valdiator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "you must enter your password";
                            }
                            // if (!regex.hasMatch(value)) {
                            // return 'Enter valid password';
                            //  }
                            return null;
                          }, //valdiator
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomTextFormField(
                          controller: confirmPasswordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                                sec ? Icons.visibility : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                sec = !sec;
                              });
                            },
                          ),
                          sec: sec,
                          title: "Password",
                          labelText: "Confirm Password",
                          valdiator: (String? value) {
                            if (value == null || value.trim().isEmpty) {
                              return "you must enter your password";
                            }
                            if (value != passwordController.text) {
                              return "password doesn't match";
                            }
                            return null;
                          }, //valdiator
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 60,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: (state is UserAuthLoading)
                                      ? WidgetStateProperty.all(
                                          Colors.blue.withOpacity(0.5))
                                      : WidgetStateProperty.all(Colors.blue),
                                  shape: WidgetStateProperty.all(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.blue)))),
                              onPressed: (state is UserAuthLoading)
                                  ? null
                                  : () {
                                      if (formkey.currentState!.validate()) {
                                        signUpLogic(context);
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Create Account",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 25),
                                  ),
                                  (state is UserAuthLoading)
                                      ? const SizedBox(
                                          width: 25,
                                          height: 25,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(Icons.arrow_forward),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }

  void signUpLogic(BuildContext context) {
    context.read<AuthCubit>().signUp({
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneController.text,
      "type": "student",
      "image":
          "https://gravatar.com/avatar/${emailController.text}${phoneController.text}?s=400&d=identicon&r=x",
    }, passwordController.text);
  }
}
