import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/register_screen_comic.dart';
import 'package:project_aplikasi_mobile/features/layouts/layout_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _emailError = '';
  String _passwordError = '';
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _emailError = email.isEmpty ? 'Email harus diisi' : '';
        _passwordError = password.isEmpty ? 'Password harus diisi' : '';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _emailError = 'Email harus mengandung simbol @!';
        _passwordError = '';
      });
      return;
    }

    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');

    if (savedEmail == null) {
      setState(() {
        _emailError =
            'Email tidak terdaftar! Silakan register terlebih dahulu.';
        _passwordError = '';
      });
      return;
    }

    if (email != savedEmail) {
      setState(() {
        _emailError = 'Email tidak sesuai dengan akun terdaftar!';
        _passwordError = '';
      });
      return;
    }

    if (password != savedPassword) {
      setState(() {
        _passwordError = 'Password salah!';
        _emailError = '';
      });
      return;
    }

    print("*** Login Berhasil ***");
    prefs.setBool('isSignedIn', true);
    prefs.setBool('is_logged_in', true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login berhasil!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LayoutScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Brand logo / title
                Image.asset(
                  'images/auth/logo.png',
                  width: 500,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'COMICU',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Form
                      Form(
                        child: Column(
                          children: [
                            const Padding(padding: EdgeInsets.all(20)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  errorText: _emailError.isNotEmpty
                                      ? _emailError
                                      : null,
                                  labelText: 'Email',
                                  prefixIcon: const Icon(Icons.email),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.5,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  errorText: _passwordError.isNotEmpty
                                      ? _passwordError
                                      : null,
                                  labelText: 'Kata sandi',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.5,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () => setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),

                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amberAccent,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  _onLogin();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("Don't have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const RegisterScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        color: Color.fromRGBO(33, 150, 243, 1),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
