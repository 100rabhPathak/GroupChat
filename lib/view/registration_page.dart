import 'package:chatapp/helper/helper_function.dart';
import 'package:chatapp/services/auth_services.dart';
import 'package:chatapp/view/home_page.dart';
import 'package:chatapp/view/login_page.dart';
import 'package:flutter/material.dart';

import '../shared/constant.dart';
import '../shared/widget.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  bool _isloading = false;
  AuthServices authServices = AuthServices();
  resigter() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await authServices
          .registerUserWithEmailAndPassword(fullName, email, password)
          .then((value) async {
        if (value == true) {
          await HelperFunction.saveUserLoggedInStatus(true);
          await HelperFunction.saveUserName(fullName);
          await HelperFunction.saveUserEmail(email);
          nextScreenReplace(context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(
                color: Constant.primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Form(
                  key: formkey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/logo.png",
                            width: 80,
                          ),
                        ),
                        const Text(
                          "Create Your Account Now To Chat & Explore",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w700),
                        ),
                        Image.asset(
                          "assets/register.png",
                          height: 300,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isNotEmpty) {
                              return null;
                            } else {
                              return "Please Enter Your Name";
                            }
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: "Full Name",
                              prefixIcon: Icon(
                                Icons.person,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            return RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value!)
                                ? null
                                : "please Enter a Valid Email";
                          },
                          decoration: textInputDecoration.copyWith(
                              labelText: "Email",
                              prefixIcon: Icon(
                                Icons.email,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.length < 6) {
                              return "Password is too short";
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Password",
                              prefixIcon: Icon(
                                Icons.key,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value != password) {
                              return "Password is not matching";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(
                              labelText: "Confirm Password",
                              prefixIcon: Icon(
                                Icons.key,
                                color: Constant.primaryColor,
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 200,
                          height: 45,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constant.primaryColor,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25))),
                              onPressed: () {
                                resigter();
                              },
                              child: const Text(
                                "SignUp",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w700),
                              )),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already Have An Account?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                nextScreen(context, const LoginPage());
                              },
                              child: Text(
                                " LogIn Now",
                                style: TextStyle(
                                    color: Constant.primaryColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ),
    );
  }
}
