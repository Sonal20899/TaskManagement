import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget MyTextField(BuildContext context, TextEditingController controller,
    String hintText, IconData icon) {
  Size size = MediaQuery.sizeOf(context);
  return Padding(
    padding: EdgeInsets.symmetric(vertical: 10, horizontal: size.width * 0.08),
    child: TextField(
      style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400),
      controller: controller,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 10),
        border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20)),
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: GoogleFonts.kufam(fontSize: 13, fontWeight: FontWeight.w400),
        prefixIcon: const Icon(Icons.person, color: Colors.grey, size: 18),
      ),
    ),
  );
}
