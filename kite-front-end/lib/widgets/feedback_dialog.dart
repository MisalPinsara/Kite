import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_button.dart';

class FeedbackDialog extends StatefulWidget {
  final Function(String) onSubmit;
  const FeedbackDialog({super.key, required this.onSubmit});

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  final TextEditingController _feedbackController = TextEditingController();

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Write a feedback',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Feedback:',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: '',
                  filled: true,
                  fillColor: Colors.white,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Color(0xFFDCDCDC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: Colors.black, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Submit',
                onPressed: () {
                  if (_feedbackController.text.isNotEmpty) {
                    widget.onSubmit(_feedbackController.text);
                  }
                },
                icon: Icons.arrow_forward,
                height: 60,
                borderRadius: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showFeedbackDialog(BuildContext context, {required Function(String) onSubmit}) {
  showDialog(
    context: context,
    builder: (context) => FeedbackDialog(onSubmit: onSubmit),
  );
}
