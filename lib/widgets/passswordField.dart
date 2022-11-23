import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomePasswordField extends StatefulWidget {
  TextEditingController? controller;
  String? fieldName;

  CustomePasswordField({super.key, this.controller, this.fieldName});

  @override
  State<CustomePasswordField> createState() => _CustomePasswordFieldState();
}

bool obsecureText = true;

class _CustomePasswordFieldState extends State<CustomePasswordField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        controller: widget.controller,
        validator: ((val) => widget.controller!.text.isEmpty
            ? "Please Enter ${widget.fieldName}"
            : null),
        onChanged: (value) {
          setState(() {
            value = widget.controller!.text;
          });
        },
        obscureText: obsecureText,
        style: GoogleFonts.roboto(color: Colors.white),
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  obsecureText = !obsecureText;
                });
              },
              child: Icon(
                obsecureText == true
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.white,
              ),
            ),
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: '${widget.fieldName}',
            hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade800.withOpacity(0.25)),
      ),
    );
  }
}
