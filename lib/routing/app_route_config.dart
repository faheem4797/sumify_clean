import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAppRouter {
  GoRouter router = GoRouter(routes: [
    GoRoute(
      name: 'home',
      path: '/',
      pageBuilder: (context, state) {
        return const MaterialPage(child: Scaffold());
      },
    ),
    // GoRoute(
    //   name: 'home',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: Scaffold());
    //   },
    // ),
    // GoRoute(
    //   name: 'home',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: Scaffold());
    //   },
    // ),
    // GoRoute(
    //   name: 'home',
    //   path: '/',
    //   pageBuilder: (context, state) {
    //     return const MaterialPage(child: Scaffold());
    //   },
    // ),
  ]);
}
