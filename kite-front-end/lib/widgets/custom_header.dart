import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Kite',
                    style: GoogleFonts.inter(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: Image.asset(
                      'assets/images/Kite_logo.png',
                      height: 68,
                      width: 68,
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Icon(Icons.notifications_none_outlined, size: 32),
        ],
      ),
    );
  }
}
