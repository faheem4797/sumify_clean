// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';

// class SignInScreen extends StatefulWidget {
//   const SignInScreen({super.key});

//   @override
//   State<SignInScreen> createState() => _SignInScreenState();
// }

// class _SignInScreenState extends State<SignInScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//   bool obscure = true;
//   //bool checkBox = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: double.infinity,
//       decoration: BoxDecoration(
//         color: white,
//         image: const DecorationImage(
//           image: AssetImage("assets/images/login/bg.png"),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 120.h),
//                   Text(
//                     'Sumify',
//                     style: GoogleFonts.poppins(
//                         textStyle: TextStyle(
//                             fontWeight: FontWeight.bold, fontSize: 40.sp)),
//                   ),
//                   SizedBox(height: 55.h),
//                   Text(
//                     'Login to your Account',
//                     style: GoogleFonts.nunito(
//                         textStyle: TextStyle(
//                             color: lightTeal,
//                             fontSize: 16.sp,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                   SizedBox(height: 55.h),
//                   loginTextField(
//                     _emailController,
//                     'Email Address',
//                     'Enter your email',
//                     false,
//                     (value) {
//                       if (_emailController.text == '') {
//                         return 'Please enter an email';
//                       } else if (!RegExp(
//                               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                           .hasMatch(_emailController.text)) {
//                         return 'Please enter a valid email';
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   SizedBox(height: 16.h),
//                   loginTextField(
//                     _passwordController,
//                     'Password',
//                     'Enter your password',
//                     true,
//                     (value) {
//                       if (_passwordController.text == '') {
//                         return 'Please enter a password';
//                       } else if (_passwordController.text.length < 8) {
//                         return 'Please enter a valid password';
//                       } else {
//                         return null;
//                       }
//                     },
//                   ),
//                   SizedBox(height: 20.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       // Row(
//                       //   children: [
//                       //     Checkbox(
//                       //       value: checkBox,
//                       //       checkColor: lightTeal,
//                       //       activeColor: darkTeal,
//                       //       shape: RoundedRectangleBorder(
//                       //           borderRadius: BorderRadius.circular(5.r)),
//                       //       onChanged: (value) {
//                       //         setState(() {
//                       //           checkBox = value ?? false;
//                       //         });
//                       //       },
//                       //     ),
//                       //     GestureDetector(
//                       //       onTap: () {
//                       //         setState(() {
//                       //           checkBox = !checkBox;
//                       //         });
//                       //       },
//                       //       child: Text(
//                       //         'Stay Logged In',
//                       //         style: GoogleFonts.spaceGrotesk(
//                       //             textStyle: TextStyle(fontSize: 12.sp)),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                       InkWell(
//                         onTap: () {
//                           //TODO: MIGHT NEED TO CHANGE EMAIL TEMPLATE SHOWING A DOMAIN AND ACTUAL NAME
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => const ForgotPassword()));
//                         },
//                         child: Text(
//                           'Forgot Password?',
//                           style: GoogleFonts.spaceGrotesk(
//                               textStyle: TextStyle(
//                                   fontSize: 12.sp,
//                                   color: darkTeal,
//                                   fontWeight: FontWeight.bold)),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20.h),
//                   signinButton(),
//                   SizedBox(height: 30.h),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         "Don't have an account? ",
//                         style: GoogleFonts.nunito(
//                             textStyle: TextStyle(
//                           fontSize: 16.sp,
//                         )),
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.of(context).pushReplacement(
//                               MaterialPageRoute(
//                                   builder: (context) => const Signup()));
//                         },
//                         child: Text(
//                           'Sign Up',
//                           style: GoogleFonts.nunito(
//                               textStyle: TextStyle(
//                                   color: darkTeal,
//                                   fontSize: 16.sp,
//                                   fontWeight: FontWeight.w500)),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   SizedBox signinButton() {
//     final userProvider = Provider.of<UserProvider>(context);

//     return SizedBox(
//       width: double.maxFinite,
//       height: 45.h,
//       child: ElevatedButton(
//           onPressed: isLoading
//               ? null
//               : () async {
//                   FocusScope.of(context).unfocus();
//                   final isValid = formKey.currentState?.validate();
//                   if (isValid == true) {
//                     formKey.currentState?.save();
//                     setState(() {
//                       isLoading = true;
//                     });
//                     String? message = await AuthService().login(
//                         email: _emailController.text,
//                         password: _passwordController.text);

//                     if (message!.contains('Success')) {
//                       await userProvider.setUser();
//                       setState(() {
//                         isLoading = false;
//                       });

//                       if (!mounted) return;
//                       Navigator.of(context).pushReplacement(MaterialPageRoute(
//                           builder: (context) => const MainPage()));
//                     }
//                     setState(() {
//                       isLoading = false;
//                     });
//                     if (!mounted) return;
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(message),
//                       ),
//                     );
//                   }
//                 },
//           style: ElevatedButton.styleFrom(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(20.r),
//             ),
//             backgroundColor: darkTeal,
//           ),
//           child: isLoading
//               ? CircularProgressIndicator(color: white)
//               : Text(
//                   'SIGN IN',
//                   style: GoogleFonts.nunito(
//                       textStyle: TextStyle(
//                     fontSize: 22.sp,
//                     fontWeight: FontWeight.normal,
//                     color: kColorText,
//                   )),
//                 )),
//     );
//   }

//   Align loginTextField(TextEditingController controller, String title,
//       String hintText, bool pwdField, String? Function(String?)? validator) {
//     return Align(
//       alignment: Alignment.centerLeft,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: GoogleFonts.spaceGrotesk(
//                 textStyle: TextStyle(
//                     //color: lightTeal,
//                     fontSize: 14.sp,
//                     fontWeight: FontWeight.bold)),
//           ),
//           SizedBox(height: 10.h),
//           TextFormField(
//             controller: controller,
//             style: GoogleFonts.spaceGrotesk(),
//             obscureText: pwdField ? obscure : false,
//             validator: validator,
//             decoration: InputDecoration(
//               floatingLabelBehavior: FloatingLabelBehavior.never,
//               suffixIconColor: Colors.grey,
//               suffixIcon: pwdField
//                   ? IconButton(
//                       onPressed: () {
//                         setState(() {
//                           obscure = !obscure;
//                         });
//                       },
//                       icon: Icon(
//                           obscure ? Icons.visibility : Icons.visibility_off))
//                   : null,
//               hintText: hintText,
//               enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: darkTeal),
//                   borderRadius: BorderRadius.all(Radius.circular(25.r))),
//               border: OutlineInputBorder(
//                   borderSide: BorderSide(color: darkTeal),
//                   borderRadius: BorderRadius.all(Radius.circular(25.r))),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: darkTeal, width: 2),
//                 borderRadius: BorderRadius.circular(25.r),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
