import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import 'signup.dart';
import 'dashboard.dart';
import '../widgets/responsive_wrapper.dart';
import '../models/user.dart';
import '../sevices/user.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late User user;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void setUser(User newUser) {
    setState(() {
      user = newUser;
    });
  }

  Future<bool> signIn(String username, String password) async {
    User? user = await UserServices().getUser(username);
    if (user == null) return false;
    setUser(user);
    return user.password == password;
  }

  void _handleSignIn(String username, String password) async {
    if (_formKey.currentState!.validate()) {
      bool result = await signIn(username, password);

      if (result) {
        print(user);
        Navigator.pushReplacement(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => Dashboard(user: user)),
        );
      } else {
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(const SnackBar(content: Text('Invalid login')));
      }
    } else {
      print("Validation failed");
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
                      'Sign in',
                      style: GoogleFonts.inter(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Sign into your Kite account using username or email & password if you are already a member.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomInputField(
                      label: 'Username/ e-mail',
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(
                      label: 'Password',
                      controller: _passwordController,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length <= 6) {
                          return 'password must contain atleast 6 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Forgot Password?',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: 'Sign in',
                      onPressed: () => _handleSignIn(
                        _usernameController.text.replaceAll(' ', '').toLowerCase(),
                        _passwordController.text,
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            color: Colors.grey[800],
                            fontSize: 14,
                          ),
                          children: const [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign up',
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
