import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_management/screen/register_screen.dart';

import '../ui/mycolor.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: backgroundColor,
        child: SafeArea(
          child: Column(children: [
            SizedBox(height: size.height * 0.1),
            Image.asset(
              "assets/start.png",
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Get things done with Task App",
                style: GoogleFonts.actor(
                    fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 15),
            Align(
              alignment: Alignment.center,
              child: Text(
                "Task management is process of effectively and ",
                style: GoogleFonts.actor(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "efficiently tracking, managing, and executing the",
                style: GoogleFonts.actor(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                "life cycle of a task.",
                style: GoogleFonts.actor(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.black38),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Container(
                      height: 45,
                      width: 300,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(15)),
                      child: Center(
                        child: Text(
                          "Get Started",
                          style: GoogleFonts.actor(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
