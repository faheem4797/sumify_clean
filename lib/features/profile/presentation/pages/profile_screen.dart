import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!context.mounted) return;
                  context.read<AppUserCubit>().updateUser(null);
                  context.goNamed(AppRouteConstants.signinRouteName);
                },
                child: const Text('Sign Out')),
          )
        ],
      ),
    );
  }
}
