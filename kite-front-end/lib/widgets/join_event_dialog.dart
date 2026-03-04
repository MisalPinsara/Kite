import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_button.dart';
import 'custom_input_field.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';

class JoinEventDialog extends StatefulWidget {
  final ValueChanged<String> onJoinSuccess;
  final String message;
  final String? initialEmail;

  const JoinEventDialog({
    super.key,
    required this.onJoinSuccess,
    required this.message,
    this.initialEmail,
  });

  @override
  State<JoinEventDialog> createState() => _JoinEventDialogState();
}

class _JoinEventDialogState extends State<JoinEventDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.initialEmail ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),
              CustomInputField(
                label: 'Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  if (!EmailValidatorFlutter().validateEmail(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Submit',
                height: 52,
                icon: Icons.arrow_forward,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                    widget.onJoinSuccess(_emailController.text);
                  }
                },
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}

void showJoinEventDialog({
  required BuildContext context,
  required ValueChanged<String> onJoinSuccess,
  required String message,
  String? initialEmail,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => JoinEventDialog(
      onJoinSuccess: onJoinSuccess, 
      message: message,
      initialEmail: initialEmail,
    ),
  );
}
