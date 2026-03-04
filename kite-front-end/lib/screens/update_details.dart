import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kite/models/user.dart';
import 'package:kite/sevices/user.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import 'settings.dart';
import '../widgets/custom_header.dart';
import '../widgets/custom_dialog.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';
import '../widgets/responsive_wrapper.dart';

class UpdateDetails extends StatefulWidget {
  final User? currentUser;
  const UpdateDetails({super.key, this.currentUser});

  @override
  State<UpdateDetails> createState() => _UpdateDetailsState();
}

class _UpdateDetailsState extends State<UpdateDetails> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final EmailValidatorFlutter _emailValidator = EmailValidatorFlutter();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.currentUser != null) {
      _usernameController.text = widget.currentUser!.username;
      _emailController.text = widget.currentUser!.email;
      _passwordController.text = widget.currentUser!.password;
      _confirmPasswordController.text = widget.currentUser!.password;
      _mobileController.text = widget.currentUser!.mobileNo;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<bool> _updateUser(
    String username,
    String email,
    String password,
    String mobile,
  ) async {
    User newUser = User(
      id: widget.currentUser?.id,
      username: username,
      email: email,
      password: password,
      mobileNo: mobile,
    );

    return UserServices().putUser(newUser);
  }

  void _handleUpdate(
    String username,
    String email,
    String password,
    String mobile,
  ) async {
    if (_formKey.currentState!.validate()) {
      bool result = await _updateUser(username, email, password, mobile);

      if (result) {
        User updatedUser = User(
          id: widget.currentUser?.id,
          username: username,
          email: email,
          password: password,
          mobileNo: mobile,
        );

        showCustomDialog(
          context: context,
          message: "successfully updated the user details",
          type: DialogType.success,
          onPrimaryAction: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Settings(currentUser: updatedUser)),
            );
          },
        );
      } else {
        showCustomDialog(
          context: context,
          message: "Error while updating the user",
          type: DialogType.failure,
          onPrimaryAction: () => Navigator.pop(context),
        );
      }
    }
  }

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
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    const CustomHeader(),

                    // Back Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.arrow_back, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Back',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Update Details Card
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              'Update details',
                              style: GoogleFonts.inter(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF333333),
                              ),
                            ),
                            const SizedBox(height: 32),

                            CustomInputField(
                              label: 'Username',
                              controller: _usernameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: 'E-mail',
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!_emailValidator.validateEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: 'Password',
                              isPassword: true,
                              controller: _passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'password is required';
                                }
                                if (_passwordController.text.length <= 6) {
                                  return 'password must contain atleast 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            CustomInputField(
                              label: 'Mobile No:',
                              isPassword: false,
                              controller: _mobileController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'mobile number is required';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 48),

                            CustomButton(
                              text: 'Update',
                              onPressed: () => _handleUpdate(
                                _usernameController.text.replaceAll(' ', '').toLowerCase(),
                                _emailController.text,
                                _passwordController.text,
                                _mobileController.text,
                              ),
                              icon: Icons.arrow_forward,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
