import 'package:absensi_alma/core/config/assets/app_images.dart';
import 'package:absensi_alma/presentation/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:reactive_button/reactive_button.dart';

class SigninPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: EdgeInsets.only(top: 20, right: 16, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _imageApp(),
            SizedBox(height: 20),
            _signInText(),
            _textAccount(),
            SizedBox(height: 20),
            _emailField(),
            SizedBox(height: 16),
            _passwordField(),
            SizedBox(height: 16),
            ReactiveButton(
              height: 50,
              width: 300,
              title: 'Sign In',
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              onSuccess: () {
                print('Action Succedd');
              },
              onFailure: (String error) {
                print('Action failde :$error');
              },
            ),
            SizedBox(height: 16),
            _forgetPassword(),
            SizedBox(height: 20),
            _textVersion(),
          ],
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

  Widget _emailField() {
    return TextField(
      style: TextStyle(color: Color(0xf0558ef8)),
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.people_alt),
        prefixIconColor: Color(0xf0558ef8),
        iconColor: Color(0xf0558ef8),
        hintText: 'Email',
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
