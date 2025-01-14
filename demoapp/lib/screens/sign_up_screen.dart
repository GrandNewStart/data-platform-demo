import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

import '../comm/api.dart';
import '../comm/app_state.dart';
import '../comm/crypto_utils.dart';
import '../models/key_pair.dart';
import 'main_screen.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  var _name = "";

  void login() async {
    try {
      KeyPair kp = CryptoUtils.generateKeyPair();
      final response = await Api.login(_name, kp);
      final code = response['code'] as int;
      final message = response['message'] as String;
      showToast(message);
      if (code == 201) {
        if (mounted) {
          AppState.initialize(_name, kp);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => MainScreen(name: _name, kp: kp)));
        }
      }
    } catch (e) {
      showToast(e.toString());
    }
  }

  void showToast(String message) {
    if (mounted) {
      Toastification().show(
          context: context,
          title: Text(message),
          showIcon: false,
          showProgressBar: false,
          autoCloseDuration: const Duration(seconds: 1),
          dragToClose: false,
          alignment: Alignment.bottomCenter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Medistock',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 16),
                      TextField(
                          onChanged: (text) {
                            setState(() {
                              _name = text;
                            });
                          },
                          decoration: const InputDecoration(
                              hintText: 'Enter your name',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0))),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 18)),
                      const SizedBox(height: 8),
                      MaterialButton(
                          onPressed: login,
                          color: Colors.grey,
                          splashColor: Colors.grey,
                          elevation: 0,
                          child: Container(
                              width: double.infinity,
                              height: 50,
                              alignment: Alignment.center,
                              child: const Text('Login',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 18))))
                    ]))));
  }
}
