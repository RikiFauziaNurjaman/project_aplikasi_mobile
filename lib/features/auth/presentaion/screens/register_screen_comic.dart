import 'package:flutter/material.dart';
import 'package:project_aplikasi_mobile/features/auth/presentaion/screens/login_screen_comic.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final _formKey = GlobalKey<FormState>();
  // final _emailController = TextEditingController();
  // final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
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
                  // height: ,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 12),
                Container(
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
                          fontSize: 67,
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
                            TextFormField(
                              // controller: _passwordController,
                              // obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'User Name',
                                prefixIcon: const Icon(Icons.person),
                                border: const OutlineInputBorder(),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Enter password';
                                if (v.length < 8) return 'Password too short';
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            TextFormField(
                              // controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),

                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              // controller: _passwordController,
                              // obscureText: _obscure,
                              decoration: InputDecoration(
                                labelText: 'Kata sandi',
                                prefixIcon: const Icon(Icons.lock),
                                border: const OutlineInputBorder(),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscure
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () =>
                                      setState(() => _obscure = !_obscure),
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.isEmpty) return 'Enter password';
                                if (v.length < 8) return 'Password too short';
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                      
                            SizedBox(
                              width: 200,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amberAccent,
                                  foregroundColor: Colors.white
                                ),
                                onPressed: (){} , //_onRegister,
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Register',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Already have an account? "),
                                GestureDetector(
                                  onTap: () {
                                      Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
