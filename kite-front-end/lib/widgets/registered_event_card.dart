import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'custom_button.dart';

class RegisteredEventCard extends StatelessWidget {
  final String title;
  final String date;
  final String time;
  final String location;
  final String? registeredMail;
  final VoidCallback onCancel;
  final VoidCallback onUpdate;

  const RegisteredEventCard({
    super.key,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    this.registeredMail,
    required this.onCancel,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: DottedBorder(
        options: const RoundedRectDottedBorderOptions(
          radius: Radius.circular(24),
          dashPattern: [10.0, 5.0],
          color: Colors.black,
          strokeWidth: 2,
        ),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailItem(Icons.calendar_month, date),
              const SizedBox(height: 8),
              _buildDetailItem(Icons.access_time_filled, time),
              const SizedBox(height: 8),
              _buildDetailItem(Icons.location_on, location),
              if (registeredMail != null) ...[
                const SizedBox(height: 8),
                _buildDetailItem(Icons.email, registeredMail!),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Update',
                      onPressed: onUpdate,
                      icon: Icons.arrow_forward,
                      height: 56,
                      borderRadius: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'Cancel',
                      onPressed: onCancel,
                      icon: Icons.arrow_forward,
                      textColor: Colors.red,
                      isOutlined: true,
                      height: 56,
                      borderRadius: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.black),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF333333),
            ),
          ),
        ),
      ],
    );
  }
}
