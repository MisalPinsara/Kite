import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/events.dart';

class EventCard extends StatelessWidget {
  final Event event;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.width,
    this.height,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isWide = MediaQuery.of(context).size.width >= 800;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Event Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.asset(
                event.image ?? 'assets/images/hero-banner-bg.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isWide ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: isWide ? 60 : 42,
                    child: Text(
                      event.name,
                      style: GoogleFonts.inter(
                        fontSize: isWide ? 22 : 16,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: isWide ? 16 : 12),
                  _buildInfoRow(Icons.calendar_month, event.date, isWide),
                  SizedBox(height: isWide ? 8 : 4),
                  _buildInfoRow(Icons.access_time_filled, event.time, isWide),
                  SizedBox(height: isWide ? 8 : 4),
                  _buildInfoRow(Icons.location_on, event.location, isWide),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isWide) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: isWide ? 20 : 14, color: Colors.black),
        SizedBox(width: isWide ? 10 : 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: isWide ? 14 : 10,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
