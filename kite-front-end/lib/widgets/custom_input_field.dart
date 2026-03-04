import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;

  const CustomInputField({
    super.key,
    required this.label,
    this.isPassword = false,
    this.controller,
    this.validator,
    this.onSaved,
    this.keyboardType,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          validator: widget.validator,
          onSaved: widget.onSaved,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          onFieldSubmitted: widget.onFieldSubmitted,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            suffixIcon: widget.isPassword ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ) : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.black, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            errorStyle: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
