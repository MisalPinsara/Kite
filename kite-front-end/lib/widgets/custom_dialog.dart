import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_button.dart';

enum DialogType { success, failure, question }

class CustomDialog extends StatelessWidget {
  final String message;
  final DialogType type;
  final bool isConfirmation;
  final String primaryActionText;
  final String? secondaryActionText;
  final VoidCallback onPrimaryAction;
  final VoidCallback? onSecondaryAction;

  const CustomDialog({
    super.key,
    required this.message,
    required this.type,
    this.isConfirmation = false,
    this.primaryActionText = 'Continue',
    this.secondaryActionText,
    required this.onPrimaryAction,
    this.onSecondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.info;
    Color iconBackgroundColor = const Color(0xFFE0E0E0);
    
    switch (type) {
      case DialogType.success:
        iconData = Icons.check;
        iconBackgroundColor = const Color(0xFFE0E0E0);
        break;
      case DialogType.failure:
        iconData = Icons.close;
        iconBackgroundColor = const Color(0xFFE0E0E0);
        break;
      case DialogType.question:
        iconData = Icons.help_outline;
        iconBackgroundColor = const Color(0xFFE0E0E0);
        break;
    }

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
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.withOpacity(0.3), width: 8),
                ),
                child: Center(
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      iconData,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              if (isConfirmation)
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: primaryActionText,
                        onPressed: onPrimaryAction,
                        height: 50,
                        icon: Icons.arrow_forward,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: CustomButton(
                        text: secondaryActionText ?? 'No',
                        onPressed: onSecondaryAction ?? () => Navigator.pop(context),
                        height: 50,
                        icon: Icons.arrow_forward,
                      ),
                    ),
                  ],
                )
              else
                CustomButton(
                  text: primaryActionText,
                  onPressed: onPrimaryAction,
                  icon: Icons.arrow_forward,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Helper method to show the dialog
void showCustomDialog({
  required BuildContext context,
  required String message,
  required DialogType type,
  bool isConfirmation = false,
  String primaryActionText = 'Continue',
  String? secondaryActionText,
  required VoidCallback onPrimaryAction,
  VoidCallback? onSecondaryAction,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => CustomDialog(
      message: message,
      type: type,
      isConfirmation: isConfirmation,
      primaryActionText: primaryActionText,
      secondaryActionText: secondaryActionText,
      onPrimaryAction: () {
        Navigator.of(dialogContext).pop();
        onPrimaryAction();
      },
      onSecondaryAction: () {
        Navigator.of(dialogContext).pop();
        onSecondaryAction?.call();
      },
    ),
  );
}
