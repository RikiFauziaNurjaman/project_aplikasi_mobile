import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/login_screen_comic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _usernameError = '';
  String _emailError = '';
  String _passwordError = '';
  bool isSignedIn = false;
  bool _obscurePassword = true;

  void _onRegister() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() {
        _usernameError = username.isEmpty ? 'Username harus diisi' : '';
        _emailError = email.isEmpty ? 'Email harus diisi' : '';
        _passwordError = password.isEmpty ? 'Password harus diisi' : '';
      });
      return;
    }

    if (email.length < 3) {
      setState(() {
        _emailError = "Field Email minimal 3 karakter!";
        _usernameError = '';
        _passwordError = '';
      });
      return;
    }

    if (username.length < 3) {
      setState(() {
        _usernameError = "Field Username minimal 3 karakter!";
        _emailError = '';
        _passwordError = '';
      });
      return;
    }

    String? existingUsername = prefs.getString('username');
    if (existingUsername != null && existingUsername == username) {
      setState(() {
        _usernameError = 'Username sudah terdaftar! Gunakan username lain.';
        _emailError = '';
        _passwordError = '';
      });
      return;
    }

    if (!email.contains('@')) {
      setState(() {
        _emailError = 'Email harus mengandung simbol @!';
        _usernameError = '';
        _passwordError = '';
      });
      return;
    }

    if (password.length < 8 ||
        !password.contains(RegExp(r'[A-Z]')) ||
        !password.contains(RegExp(r'[a-z]')) ||
        !password.contains(RegExp(r'[0-9]'))) {
      setState(() {
        _passwordError =
            'Minimal 8 Karakter dengan Huruf Kapital, kecil, dan angka';
        _usernameError = '';
        _emailError = '';
      });
      return;
    }
    setState(() {
      _usernameError = '';
      _emailError = '';
      _passwordError = '';
    });

    print("*** Sign Up Berhasil ***");

    prefs.setString(
      'username',
      username,
    ); // Simpan username ke SharedPreferences
    prefs.setString('email', email); // Simpan email ke SharedPreferences
    prefs.setString(
      'password',
      password,
    ); // Simpan password ke SharedPreferences

    // Set isSignedIn false karena user baru register, belum login
    prefs.setBool('isSignedIn', false);

    // Tampilkan SnackBar untuk notifikasi sukses
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Register berhasil! Silakan Login.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate ke login screen setelah 2 detik
    await Future.delayed(Duration(seconds: 1));
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // void _onRegister() {
  //   if (_formKey.currentState?.validate() ?? false) {
  //     // TODO: wire real auth. For now just pop or show a snackbar.
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('Logging in...')));
  //   }
  // }

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

                  // color: Colors.white,
                  child: Column(
                    children: [
                      const Text(
                        'COMICU',
                        style: TextStyle(
                          fontFamily: 'Fredoka',
                          fontSize: 65,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Form
                      Form(
                        // key: _formKey,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(20)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextFormField(
                                controller: _usernameController,
                                decoration: InputDecoration(
                                  errorText: _usernameError.isNotEmpty
                                      ? _usernameError
                                      : null,
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.5,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
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
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 2.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
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
                                  _onRegister();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Register',
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
                                  const Text("Already have an account? "),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Login',
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
