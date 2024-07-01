import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management/screen/register_screen.dart';
import 'package:task_management/screen/start_screen.dart';

import '../components/shared_key/shared_key.dart';
import '../ui/dialogbox/dialogbox_screen.dart';
import '../ui/mycolor.dart';
import 'home_screen.dart';

class LoginPage extends StatefulWidget {
  String profile_name;
  LoginPage({super.key, required this.profile_name});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final RegExp _email = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  String errmsg = '';
  bool eye = true;
  void passwordchk() {
    setState(() {
      eye = !eye;
    });
  }

  void showloader() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void hideloader() {
    Navigator.of(context).pop();
  }

  void Loginnow() async {
    if (email.text.isEmpty) {
      showalert(context, 'Enter your email id');
    } else if (password.text.isEmpty) {
      showalert(
        context,
        'Enter the Password',
      );
    } else {
      showloader();
      try {
        UserCredential newuser =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email.text.trim(),
          password: password.text.trim(),
        );

        if (newuser.user != null) {
          hideloader();
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(SharedKey.isLogin.toString(), true);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Login...."),
              action: SnackBarAction(
                label: '',
                onPressed: () {},
              )));
        }
      } on FirebaseAuthException catch (e) {
        hideloader();
        showalert(
          context,
          e.code.toString(),
        );
        //hideloader();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: size.height * 1,
        width: size.width * 1,
        color: backgroundColor,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.03),
                Text(
                  "Welcome Back",
                  style: GoogleFonts.actor(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Image.asset(
                  "assets/login.png",
                  height: size.height * 0.4,
                  width: size.width * 0.6,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        if (_email.hasMatch(value)) {
                          errmsg = '';
                        } else {
                          errmsg = 'Enter valid email address';
                        }
                      });
                    },
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter your email',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.grey, size: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 10, horizontal: size.width * 0.06),
                  child: TextField(
                    style: GoogleFonts.inter(
                        fontSize: 15, fontWeight: FontWeight.w400),
                    controller: password,
                    obscureText: eye,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(20)),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Enter password',
                      hintStyle: GoogleFonts.kufam(
                          fontSize: 13, fontWeight: FontWeight.w400),
                      prefixIcon:
                          const Icon(Icons.key, color: Colors.grey, size: 18),
                      suffixIcon: IconButton(
                          onPressed: () {
                            passwordchk();
                          },
                          icon: Icon(
                            eye ? Icons.visibility_off : Icons.visibility,
                            size: 18,
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.1),
                  child: GestureDetector(
                    onTap: () {
                      Loginnow();
                    },
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account ? ",
                        style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ));
                        },
                        child: Text(
                          "Signup",
                          style: GoogleFonts.lato(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
