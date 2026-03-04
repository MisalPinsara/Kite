import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kite/screens/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Kite",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w900,
                    fontSize: 76,
                  ),
                ),
                Image.asset(
                  'assets/images/Kite_logo.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ),
          Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  'Fly like a Kite, Enjoying every breath of your life!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  bottom: 35,
                  left: 35,
                  right: 35,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Login()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Colors.black,
                                shadowColor: null,
                              ),
                              child: Text(
                                'get started ->',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
