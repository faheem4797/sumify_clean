import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReAuthenticationData {
  final String email;
  final String password;

  ReAuthenticationData({required this.email, required this.password});
}

Future<ReAuthenticationData> showReAuthenticationDialog(
    BuildContext context) async {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  return await showDialog(
    context: context,
    builder: ((context) => AlertDialog(
          title: Text(
            'For Account Deletion, please re-authenticate:',
            style: TextStyle(fontSize: 20.sp),
          ),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email here:',
                    labelText: 'Email Adress',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Please enter an email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    email = value;
                  },
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Enter your password here:',
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == '' || value == null) {
                      return 'Please enter a password';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    password = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  final isValid = formKey.currentState?.validate();
                  if (isValid == true) {
                    Navigator.pop(context,
                        ReAuthenticationData(email: email, password: password));
                  }
                },
                child: const Text('Submit'))
          ],
        )),
  );
}
