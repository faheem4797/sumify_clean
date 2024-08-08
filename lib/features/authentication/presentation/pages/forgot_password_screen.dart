// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:sumify_clean/core/constants/constants.dart';


// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
//   final TextEditingController _emailController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;

//   @override
//   void dispose() {
//     _emailController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return
//         // width: double.infinity,
//         // height: double.infinity,
//         // decoration: BoxDecoration(
//         //   color: white,
//         //   image: const DecorationImage(
//          // image: AssetImage(Constants.splashBackgroundImage),
//         //     fit: BoxFit.cover,
//         //   ),
//         // ),
//         Scaffold(
//       appBar: AppBar(
//         backgroundColor: lightTeal,
//       ),
//       backgroundColor: Colors.transparent,
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           image: DecorationImage(
//           image: AssetImage(Constants.splashBackgroundImage),
//             fit: BoxFit.cover,
//           ),
//         ),
//         child: SingleChildScrollView(
//           child: Form(
//             key: formKey,
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 25.w),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   SizedBox(height: 230.h),
//                   TextFormField(
//                     controller: _emailController,
//                     style: GoogleFonts.nunito(),
//                     keyboardType: TextInputType.emailAddress,
//                     validator: (value) {
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
//                     decoration: InputDecoration(
//                       floatingLabelBehavior: FloatingLabelBehavior.never,
//                       hintText: 'Please enter your email address',
//                       labelText: 'Email Address',
//                       suffixIconColor: Colors.grey,
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: darkTeal),
//                       ),
//                       border: UnderlineInputBorder(
//                         borderSide: BorderSide(color: darkTeal),
//                       ),
//                       focusedBorder: UnderlineInputBorder(
//                         borderSide: BorderSide(color: darkTeal, width: 2),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 25.h),
//                   SizedBox(
//                     width: double.maxFinite,
//                     height: 45.h,
//                     child: ElevatedButton(
//                         onPressed: isLoading
//                             ? null
//                             : () async {
//                                 FocusScope.of(context).unfocus();
//                                 final isValid =
//                                     formKey.currentState?.validate();
//                                 if (isValid == true) {
//                                   formKey.currentState?.save();

//                                   setState(() {
//                                     isLoading = true;
//                                   });
//                                   String? message =
//                                       await AuthService().resetPassword(
//                                     email: _emailController.text,
//                                   );
//                                   setState(() {
//                                     isLoading = false;
//                                   });

//                                   if (message!.contains('Success')) {
//                                     if (!context.mounted) return;
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                         content:
//                                             Text('Password Reset Email Sent'),
//                                       ),
//                                     );
//                                     Navigator.pop(context);
//                                     // Navigator.of(context).pushReplacement(
//                                     //     MaterialPageRoute(
//                                     //         builder: (context) =>
//                                     //             const MyWidget()));
//                                   } else {
//                                     if (!context.mounted) return;
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       SnackBar(
//                                         content: Text(message),
//                                       ),
//                                     );
//                                   }
//                                 }
//                               },
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20.r),
//                           ),
//                           backgroundColor: darkTeal,
//                         ),
//                         child: isLoading
//                             ? CircularProgressIndicator(
//                                 color: white,
//                               )
//                             : Text(
//                                 'Reset Password',
//                                 style: GoogleFonts.nunito(
//                                     textStyle: TextStyle(
//                                         fontSize: 22.sp,
//                                         fontWeight: FontWeight.normal)),
//                               )),
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
