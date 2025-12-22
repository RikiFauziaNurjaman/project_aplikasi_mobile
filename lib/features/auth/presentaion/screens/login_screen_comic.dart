import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/register_screen_comic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorText = '';
  bool _isLogin = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String savedEmail = prefs.getString('email') ?? '';
    final String savedPassword = prefs.getString('password') ?? '';
    final String enteredEmail = _emailController.text.trim();
    final String enteredPassword = _passwordController.text.trim();

    if (enteredEmail.isEmpty || enteredPassword.isEmpty) {
      setState(() {
        _errorText = 'Nama Pengguna dan Kata Sandi harus diisi.';
      });
      return;
    }

    if (savedEmail.isEmpty || savedPassword.isEmpty) {
      setState(() {
        _errorText = 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
      });
      return;
    }

    if (enteredEmail == savedEmail && enteredPassword == savedPassword) {
      setState(() {
        _isLogin = true;
        _errorText = '';
      });
      await prefs.setBool('isSignedIn', true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(
          context,
        ).popUntil((route) => route.isFirst); // Kembali ke halaman utama
      });

      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute<void>(builder: (context) => HomeScreen()),
      //   ); // Navigasi ke halaman utama
      // });

    } else {
      setState(() {
        _errorText = 'Nama Pengguna atau Kata Sandi salah.';
      });
    }
  
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: wire real auth. For now just pop or show a snackbar.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logging in...')));
    }
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
                  width: 600,
                  // height: ,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color : Colors.white,
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
                      
                      // Form
                      Form(
                        // key: _formKey,
                        child: Column(
                          children: [
                            Padding(padding: EdgeInsets.all(20)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0, color: Colors.grey),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.5, color: Colors.blue),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: _obscurePassword,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: const Icon(Icons.lock),
                                  border: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0, color: Colors.grey),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(width: 3, color: Colors.blue),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () =>
                                        setState(() => _obscurePassword = !_obscurePassword),
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
                                  foregroundColor: Colors.white
                                ),
                                onPressed: (){} , //_onLogin,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'LOGIN',
                                    style: TextStyle(
                                      fontSize: 20, 
                                      fontWeight : FontWeight.bold,
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
                                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
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
