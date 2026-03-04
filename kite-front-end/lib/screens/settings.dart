import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'login.dart';
import 'update_details.dart';
import '../widgets/custom_button.dart';
import '../models/user.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_dialog.dart';
import '../widgets/responsive_wrapper.dart';

// ignore: must_be_immutable
class Settings extends StatelessWidget {
  final User? currentUser;
  const Settings({super.key, this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Stack(
          children: [
            ResponsiveWrapper(
              maxWidth: 500,
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const CustomHeader(),

                    // Account Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'User Account',
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF333333),
                            ),
                          ),
                          const SizedBox(height: 48),

                          _buildAccountRow('Username:', currentUser?.username ?? 'N/A'),
                          const SizedBox(height: 24),
                          _buildAccountRow('E-mail:', currentUser?.email ?? 'N/A'),
                          const SizedBox(height: 24),
                          _buildAccountRow('Password:', '*********'),
                          const SizedBox(height: 24),
                          _buildAccountRow('Mobile No:', currentUser?.mobileNo ?? 'N/A'),

                          const SizedBox(height: 64),

                          // Action Buttons
                          CustomButton(
                            text: 'Edit details',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UpdateDetails(currentUser: currentUser),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Log out',
                            onPressed: () {
                              showCustomDialog(
                                context: context,
                                message: 'Do You want to log out?',
                                type: DialogType.question,
                                isConfirmation: true,
                                primaryActionText: 'Yes',
                                secondaryActionText: 'No',
                                onPrimaryAction: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                },
                              );
                            },
                            textColor: Colors.red,
                            isOutlined: true,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            text: 'Delete account',
                            onPressed: () {
                              showCustomDialog(
                                context: context,
                                message: 'Do you want to delete your account?',
                                type: DialogType.question,
                                isConfirmation: true,
                                primaryActionText: 'Yes',
                                secondaryActionText: 'No',
                                onPrimaryAction: () async {
                                  if (currentUser != null && currentUser!.id != null) {
                                    
                                    await http.delete(Uri.parse('https://vambraced-unappreciably-bebe.ngrok-free.dev/users/delete/${currentUser!.id}'));
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Login(),
                                      ),
                                    );
                                  }
                                },
                              );
                            },
                            textColor: Colors.red,
                            isOutlined: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Nav Bar
            CustomBottomNavBar(selectedIndex: 3, user: currentUser),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
