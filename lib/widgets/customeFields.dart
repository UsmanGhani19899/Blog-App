import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeField extends StatefulWidget {
  TextEditingController? controller;
  String? fieldName;
  int? maxLine;
  CustomeField({super.key, this.controller, this.fieldName, this.maxLine});

  @override
  State<CustomeField> createState() => _CustomeFieldState();
}

class _CustomeFieldState extends State<CustomeField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      child: TextFormField(
        maxLines: widget.maxLine,
        controller: widget.controller,
        validator: ((val) => widget.controller!.text.isEmpty
            ? "Please Enter ${widget.fieldName}"
            : null),
        onChanged: (value) {
          setState(() {
            value = widget.controller!.text;
          });
        },
        style: GoogleFonts.roboto(color: Colors.white),
        decoration: InputDecoration(
            border: OutlineInputBorder(borderSide: BorderSide.none),
            hintText: '${widget.fieldName}',
            hintStyle: GoogleFonts.roboto(color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.grey.shade800.withOpacity(0.25)),
      ),
    );
  }
}
