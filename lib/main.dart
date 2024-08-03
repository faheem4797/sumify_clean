import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sumify_clean/routing/app_route_config.dart';
import 'firebase_options.dart';

//TODO! LEARN GO ROUTER and GET IT

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Sumify',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routeInformationParser: MyAppRouter().router.routeInformationParser,
      routerDelegate: MyAppRouter().router.routerDelegate,
      routeInformationProvider: MyAppRouter().router.routeInformationProvider,
      // home: const Scaffold(),
    );
  }
}
