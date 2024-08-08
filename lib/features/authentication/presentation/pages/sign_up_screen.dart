import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sumify_clean/core/constants/constants.dart';
import 'package:sumify_clean/core/theme/app_pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool obscure = true;
  bool obscureConfirm = true;

  Future<void> _launchURL() async {
    final uri = Uri.parse(Constants.privacyPolicyURL);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Can not launch url";
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: AppPallete.kWhiteColor,
        image: DecorationImage(
          image: AssetImage(Constants.loginBackgroundImage),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 120.h),
                  Text(
                    'Sumify',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40.sp)),
                  ),
                  SizedBox(height: 50.h),
                  Text(
                    'Create your Account',
                    style: TextStyle(
                        color: AppPallete.klightTealColor,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50.h),

                  //
                  //
                  //
                  //
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //SizedBox(height: 10.h),
                        TextFormField(
                          controller: controller,
                          obscureText: pwdField == 1
                              ? obscure
                              : pwdField == 2
                                  ? obscureConfirm
                                  : false,
                          keyboardType: keyboardType,
                          validator: validator,
                          decoration: InputDecoration(
                              hintText: hintText,
                              labelText: labelText,
                              suffixIcon: pwdField == 0
                                  ? null
                                  : pwdField == 1
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obscure = !obscure;
                                            });
                                          },
                                          icon: Icon(obscure
                                              ? Icons.visibility
                                              : Icons.visibility_off))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              obscureConfirm = !obscureConfirm;
                                            });
                                          },
                                          icon: Icon(obscureConfirm
                                              ? Icons.visibility
                                              : Icons.visibility_off))),
                        )
                      ],
                    ),
                  ),

                  ///
                  ///
                  ///
                  ///
                  ///
                  ///
                  ///
                  ///
                  signupTextField(
                    _nameController,
                    'Full Name',
                    'Enter your name',
                    TextInputType.name,
                    0,
                    (value) {
                      if (_nameController.text == '') {
                        return 'Please enter a name';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  signupTextField(
                    _emailController,
                    'Email Address',
                    'Enter your email',
                    TextInputType.emailAddress,
                    0,
                    (value) {
                      if (_emailController.text == '') {
                        return 'Please enter an email';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(_emailController.text)) {
                        return 'Please enter a valid email';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  signupTextField(
                    _passwordController,
                    'Password',
                    'Enter your password',
                    TextInputType.name,
                    1,
                    (value) {
                      if (_passwordController.text == '') {
                        return 'Please enter a password';
                      } else if (_passwordController.text.length < 8) {
                        return 'Please enter a valid password';
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 10.h),
                  signupTextField(
                    _confirmPasswordController,
                    'Confirm Password',
                    'Confirm your password',
                    TextInputType.name,
                    2,
                    (value) {
                      if (_confirmPasswordController.text == '') {
                        return 'Please enter a password';
                      } else if (_confirmPasswordController.text.length < 8) {
                        return 'Please enter a valid password';
                      } else if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return "Password don't match";
                      } else {
                        return null;
                      }
                    },
                  ),
                  SizedBox(height: 50.h),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                'By clicking SIGN UP, you agree to and have read our ',
                            style: GoogleFonts.outfit(
                                textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            )),
                          ),
                          TextSpan(
                              style: GoogleFonts.outfit(
                                  textStyle: const TextStyle(
                                color: AppPallete.kDarkTealColor,
                                fontSize: 15,
                              )),
                              text: 'Privacy Policy',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await _launchURL();
                                }),
                          const TextSpan(
                              text: '.',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  signupButton(),
                  SizedBox(height: 30.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: GoogleFonts.nunito(
                            textStyle: TextStyle(
                          fontSize: 16.sp,
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (context) => const Login()));
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: AppPallete.kDarkTealColor,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox signupButton() {
    return SizedBox(
      width: double.maxFinite,
      height: 45.h,
      child: ElevatedButton(
          onPressed: isLoading
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final isValid = formKey.currentState?.validate();
                  if (isValid == true) {
                    formKey.currentState?.save();

                    setState(() {
                      isLoading = true;
                    });
                    // String? message = await AuthService().registration(
                    //     name: _nameController.text,
                    //     email: _emailController.text,
                    //     password: _passwordController.text);

                    // if (message!.contains('Success')) {
                    //   await userProvider.setUser();
                    //   setState(() {
                    //     isLoading = false;
                    //   });
                    //   if (!mounted) return;
                    //   Navigator.of(context).pushReplacement(MaterialPageRoute(
                    //       builder: (context) => const MainPage()));
                    // }
                    // setState(() {
                    //   isLoading = false;
                    // });
                    // if (!mounted) return;
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //   SnackBar(
                    //     content: Text(message),
                    //   ),
                    // );
                  }
                },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: AppPallete.kDarkTealColor,
          ),
          child: isLoading
              ? const CircularProgressIndicator(
                  color: AppPallete.kWhiteColor,
                )
              : Text(
                  'SIGN UP',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.normal,
                    color: AppPallete.kWhiteColor,
                  ),
                )),
    );
  }

  Align signupTextField(
      TextEditingController controller,
      String labelText,
      String hintText,
      TextInputType keyboardType,
      int? pwdField,
      String? Function(String?)? validator) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SizedBox(height: 10.h),
          TextFormField(
            controller: controller,
            obscureText: pwdField == 1
                ? obscure
                : pwdField == 2
                    ? obscureConfirm
                    : false,
            keyboardType: keyboardType,
            validator: validator,
            decoration: InputDecoration(
                hintText: hintText,
                labelText: labelText,
                suffixIcon: pwdField == 0
                    ? null
                    : pwdField == 1
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: Icon(obscure
                                ? Icons.visibility
                                : Icons.visibility_off))
                        : IconButton(
                            onPressed: () {
                              setState(() {
                                obscureConfirm = !obscureConfirm;
                              });
                            },
                            icon: Icon(obscureConfirm
                                ? Icons.visibility
                                : Icons.visibility_off))),
          )
        ],
      ),
    );
  }
}
