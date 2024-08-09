import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/forgot_password_screen.dart';
// import 'package:sumify_clean/features/authentication/presentation/pages/sign_in_screen.dart';
// import 'package:sumify_clean/features/authentication/presentation/pages/sign_up_screen.dart';
// import 'package:sumify_clean/features/authentication/presentation/pages/splash_screen.dart';

class MyAppRouter {
  GoRouter router = GoRouter(routes: [
    // GoRoute(
    //   name: 'splash',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: SplashScreen());
    //   },
    // ),
    // GoRoute(
    //   name: 'signup',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: SignUpScreen());
    //   },
    // ),
    // GoRoute(
    //   name: 'signin',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: SignInScreen());
    //   },
    // ),
    GoRoute(
      name: 'forgotPassword',
      path: '/',
      pageBuilder: (context, state) {
        return const MaterialPage(child: ForgotPasswordScreen());
      },
    ),

    // GoRoute(
    //   name: 'home',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: Scaffold());
    //   },
    // ),
  ]);
}
