import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kite/models/user.dart';
import 'package:kite/screens/login.dart';
import 'package:kite/sevices/user.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/responsive_wrapper.dart';
import 'package:email_validator_flutter/email_validator_flutter.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final EmailValidatorFlutter _emailValidator = EmailValidatorFlutter();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  Future<bool> signUp(
    String username,
    String email,
    String password,
    String mobileNo,
  ) async {
    User user = User(
      username: username,
      email: email,
      password: password,
      mobileNo: mobileNo,
    );

    return UserServices().postUser(user);
  }

  void _handleSignUp(
    String username,
    String email,
    String password,
    String mobileNo,
  ) async {
    if (_formKey.currentState!.validate()) {
      bool result = await signUp(username, email, password, mobileNo);

      if (result) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error while registering new user')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ResponsiveWrapper(
            maxWidth: 450,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sign up',
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Join Kite today! Create your account with your username, email and a password.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
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
                      label: 'Confirm Password',
                      isPassword: true,
                      controller: _confirmPasswordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'confirm password is required';
                        }
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          return 'confirm password must be same as password';
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
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Sign up',
                      onPressed: () {
                        _handleSignUp(
                          _usernameController.text.replaceAll(' ', '').toLowerCase(),
                          _emailController.text,
                          _passwordController.text,
                          _mobileController.text,
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                          children: const [
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: 'Sign in',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}