import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sumify_clean/core/common/cubits/app_user_cubit.dart';
import 'package:sumify_clean/core/common/widgets/loader.dart';
import 'package:sumify_clean/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/forgot_password_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_in_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/splash_screen.dart';
import 'package:sumify_clean/features/authentication/presentation/pages/sign_up_screen.dart';
import 'package:sumify_clean/routing/app_route_constants.dart';

class MyAppRouter {
  GoRouter router = GoRouter(
    routes: [
      GoRoute(
        name: AppRouteConstants.splashRoute,
        path: '/splash',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SplashScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signupRoute,
        path: '/signup',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignUpScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.signinRoute,
        path: '/signin',
        pageBuilder: (context, state) {
          return const MaterialPage(child: SignInScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.forgotPasswordRoute,
        path: '/forgotPassword',
        pageBuilder: (context, state) {
          return const MaterialPage(child: ForgotPasswordScreen());
        },
      ),
      GoRoute(
        name: AppRouteConstants.homeRoute,
        path: '/loggedin',
        pageBuilder: (context, state) {
          return MaterialPage(
              child: Scaffold(
            body: Column(
              children: [
                const Center(
                  child: Text('Logged In'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      try {
                        await FirebaseAuth.instance.signOut();
                        context.read<AppUserCubit>().updateUser(null);
                        context.goNamed(AppRouteConstants.signinRoute);
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: const Text('Logout'))
              ],
            ),
          ));
        },
      ),
      GoRoute(
        name: AppRouteConstants.initialRoute,
        path: '/',
        pageBuilder: (context, state) {
          return const MaterialPage(
              child: Scaffold(
            body: Center(
              child: Text(''),
            ),
          ));
        },
      ),
      GoRoute(
        name: AppRouteConstants.loaderRoute,
        path: '/loader',
        pageBuilder: (context, state) {
          return const MaterialPage(child: InitialWidget());
        },
      ),
    ],
    redirect: (context, state) {
      if (state.matchedLocation == '/' || state.matchedLocation == '/loader') {
        final appUserState = context.read<AppUserCubit>().state;

        if (appUserState is AppUserInitial) {
          return '/splash';
        } else if (appUserState is AppUserLoggedIn) {
          return '/loggedin';
        } else if (appUserState is AppUserLoading) {
          return '/loader';
        }
      }

      return null;
    },
  );
}

class InitialWidget extends StatefulWidget {
  const InitialWidget({
    super.key,
  });

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
  StreamSubscription<AuthState>? _subscription;

  void _triggerEvent() {
    _subscription = context.read<AuthBloc>().stream.listen((state) {
      if (state is AuthSuccess) {
        context.read<AppUserCubit>().updateUser(state.user);

        _subscription?.cancel();
      } else if (state is AuthFailure) {
        context.read<AppUserCubit>().updateUser(null);

        _subscription?.cancel();
      }

      final appUserState = context.read<AppUserCubit>().state;
      if (appUserState is AppUserInitial) {
        context.goNamed(AppRouteConstants.splashRoute);
      } else if (appUserState is AppUserLoggedIn) {
        context.goNamed(AppRouteConstants.homeRoute);
      }
    });

    context.read<AuthBloc>().add(AuthIsUserLoggedIn());
  }

  @override
  void initState() {
    super.initState();
    _triggerEvent();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Loader(),
      ),
    );
  }
}
