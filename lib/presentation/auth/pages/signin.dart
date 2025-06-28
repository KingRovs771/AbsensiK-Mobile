import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            // Jika login gagal, tampilkan pesan error
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state is AuthAuthenticated) {
            // Jika login berhasil, pindah ke halaman utama dan hapus halaman login dari stack
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => HomePage(user: state.user)),
            );
          }
        },
        child: SafeArea(
          minimum: EdgeInsets.only(top: 20, right: 16, left: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _imageApp(),
                SizedBox(height: 20),
                _signInText(),
                _textAccount(),
                SizedBox(height: 20),
                _usernameField(),
                SizedBox(height: 16),
                _passwordField(),
                SizedBox(height: 16),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    // Jika state sedang loading, tampilkan CircularProgressIndicator
                    if (state is AuthLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Jika tidak loading, tampilkan tombol
                    return ElevatedButton(
                      // Menggunakan ElevatedButton sebagai contoh
                      style: ElevatedButton.styleFrom(
                          minimumSize:
                              const Size(double.infinity, 50), // Lebar penuh
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: const Color(0xff558ef8),
                          foregroundColor: Colors.white),
                      onPressed: () {
                        // 5. Saat tombol ditekan, kirim event ke AuthBloc
                        context.read<AuthBloc>().add(
                              LoginButtonPressed(
                                username: _usernameController.text.trim(),
                                password: _passwordController.text.trim(),
                              ),
                            );
                      },
                      child:
                          const Text('Sign In', style: TextStyle(fontSize: 16)),
                    );
                  },
                ),
                SizedBox(height: 16),
                _forgetPassword(),
                SizedBox(height: 20),
                _textVersion(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _imageApp() {
    return const Image(
      image: AssetImage(AppImages.imageLogin),
      width: 200,
      height: 200,
    );
  }

  Widget _signInText() {
    return const Text(
      'Hello Welcome Back',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: Color.fromARGB(255, 0, 0, 0),
      ),
    );
  }

  Widget _textAccount() {
    return const Text(
      'Log in your existant account',
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _usernameField() {
    return TextField(
      controller: _usernameController,
      style: TextStyle(color: Color(0xf0558ef8)),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people_alt),
        prefixIconColor: Color(0xf0558ef8),
        iconColor: Color(0xf0558ef8),
        hintText: 'Username',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff558ef8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xfd9d9d9d),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return TextField(
      controller: _passwordController,
      obscureText: true,
      style: TextStyle(
        color: Color(0xf0558ef8),
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.key),
        prefixIconColor: Color(0xf0558ef8),
        hintText: 'Password',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xff558ef8),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(
            width: 1,
            color: Color(0xfd9d9d9d),
          ),
        ),
      ),
    );
  }

  Widget _forgetPassword() {
    return Column(
      children: <Widget>[
        Text(
          'Forget Password?, Call Administrator',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _textVersion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            'Version: V0.0.1',
          ),
        )
      ],
    );
  }
}
